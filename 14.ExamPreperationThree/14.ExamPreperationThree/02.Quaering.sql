--05.ClientByName
SELECT FirstName, LastName, Phone FROM Clients
ORDER BY LastName, ClientId DESC

--06.JobStatus
SELECT Status, IssueDate
 FROM Jobs
WHERE FinishDate IS NULL
ORDER BY IssueDate, JobId
--07.Mechanic Assignments

SELECT CONCAT(FirstName, ' ', LastName) AS Mechanic,
             j.Status, j.IssueDate 
FROM Mechanics AS m
JOIN Jobs AS j ON j.MechanicId = m.MechanicId
ORDER BY m.MechanicId, J.IssueDate, j.JobId
--08.CurrentClients

SELECT CONCAT(FirstName, ' ', LastName) AS Client,
DATEDIFF(DAY, j.IssueDate, '20170424') AS 'Days Going',
j.Status 
FROM Clients AS c
JOIN Jobs AS j ON j.ClientId = c.ClientId
WHERE j.Status != 'Finished'
ORDER BY [Days Going] DESC, c.ClientId ASC

--09.MechanicPerformans
SELECT CONCAT(FirstName, ' ', LastName) AS Mechanic, a.AVGDays AS AverageDays
FROM Mechanics AS m
JOIN 
(SELECT m.MechanicId AS 'Mechanic', avg(datediff(day, j.IssueDate, j.FinishDate)) AS 'AVGDays' FROM Jobs AS j
 JOIN Mechanics AS m ON m.MechanicId = j.MechanicId
 WHERE STATUS = 'Finished'
 GROUP BY m.MechanicId) AS a ON m.MechanicId = a.Mechanic 

--10.HardEarness
SELECT TOP 3 
	CONCAT(FirstName, ' ', LastName) AS Mechanic ,
	COUNT(j.Status) AS Jobs
FROM Mechanics AS m
JOIN Jobs AS j ON J.MechanicId = M.MechanicId
WHERE j.Status != 'Finished'
GROUP BY CONCAT(FirstName, ' ', LastName)
HAVING (COUNT(j.Status) > 1)
ORDER BY Jobs DESC

--11.AvailableMechanics
SELECT 
	CONCAT(m.FirstName, ' ', m.LastName) AS Available
FROM Mechanics AS m
JOIN
(SELECT * FROM Mechanics
WHERE MechanicId NOT IN (
SELECT MechanicId FROM Jobs
WHERE STATUS <> 'Finished' 
AND MechanicId IS NOT NULL)) AS s ON s.MechanicId = m.MechanicId

--12.PartsCost
SELECT 
	ISNULL(SUM(p.Price * op.Quantity),0) AS [Parts Total] 
FROM Parts AS P
JOIN OrderParts AS op ON op.PartId = p.PartId
JOIN Orders AS o ON o.OrderId = op.OrderId
WHERE o.IssueDate > (DATEADD(WEEK, -3 , '2017/04/24'))

--13.PastExpanses
SELECT 
  j.JobId,
  ISNULL(SUM(p.Price * op.Quantity),0) AS [Total] 
  FROM Parts AS P
FULL JOIN OrderParts AS op ON p.PartId = op.PartId
FULL JOIN Orders AS o ON op.OrderId = o.OrderId
FULL JOIN Jobs AS j ON o.JobId = j.JobId
WHERE j.STATUS = 'Finished'
GROUP BY j.JobId
ORDER BY [Total] DESC, j.JobId

--14.ModelRepairTime
SELECT m.ModelId, 
	   m.Name, 
	   CAST(AVG(DATEDIFF(DAY, j.IssueDate, j.FinishDate)
	   )AS VARCHAR(10)) + ' ' + 'days' AS [Average Service Time]
FROM Models AS m
JOIN Jobs AS j ON j.ModelId = m.ModelId
GROUP BY m.ModelId, m.Name
ORDER BY CAST(AVG(DATEDIFF(DAY, j.IssueDate, j.FinishDate)
	)AS VARCHAR(10)) + ' ' + 'days'

--15.FuiltiestModel
SELECT TOP 1 WITH TIES m.Name, COUNT(*) AS [Times Serviced],
(SELECT ISNULL(SUM(p.Price * op.Quantity),0) FROM Jobs AS j
JOIN Orders AS o ON O.JobId = j.JobId
JOIN OrderParts AS op ON op.OrderId = o.OrderId
JOIN Parts AS p ON p.[PartId] = op.PartId
WHERE j.ModelId = m.ModelId) AS [Parts Total]
 FROM Models AS m
JOIN Jobs AS j ON j.ModelId = m.ModelId
GROUP BY m.ModelId, m.Name
ORDER BY [Times Serviced] DESC

--16.MissingParts
SELECT 
	p.PartId,
	p.[Description],
	SUM(pn.Quantity) AS [Required],
	SUM(p.StockQty) AS [In Stock],
	ISNULL(SUM(op.Quantity),0) AS [Ordered]
FROM Parts AS p
JOIN PartsNeeded AS pn ON pn.PartId = p.PartId
JOIN Jobs AS j ON j.JobId = pn.JobId
LEFT JOIN Orders AS o ON o.JobId = j.JobId
LEFT JOIN OrderParts AS op ON op.OrderId = o.OrderId
WHERE j.Status <> 'Finished'
GROUP BY p.PartId, p.Description
HAVING SUM(pn.Quantity) > SUM(p.StockQty) + ISNULL(SUM(op.Quantity),0)
ORDER BY p.PartId
GO

--20.VendorReferences
WITH CTE_Parts
AS
(
	SELECT m.MechanicId,
		   v.VendorId,
		   SUM(op.Quantity) AS VendorItems
	 FROM Mechanics AS m
	JOIN Jobs AS j ON j.MechanicId = m.MechanicId
	JOIN Orders AS o ON o.JobId = j.JobId
	JOIN OrderParts AS op ON op.OrderId = o.OrderId
	JOIN Parts AS p ON p.PartId = op.PartId
	JOIN Vendors AS v ON v.VendorId = P.VendorId
	GROUP BY m.MechanicId, v.VendorId
)

SELECT CONCAT(m.FirstName, ' ', m.LastName) AS [Mechanic],
	   v.Name AS [Vendor],
	   c.VendorItems AS [Parts],
	   CAST(
		CAST(
		  CAST(VendorItems AS DECIMAL(6,2)) / (
					SELECT SUM(VendorItems) 
					FROM CTE_Parts 
					WHERE MechanicId = c.MechanicId) * 100 AS INT
					) AS VARCHAR(MAX)) + '%' AS Preference
	FROM CTE_Parts AS c
JOIN Mechanics AS m ON m.MechanicId = c.MechanicId
JOIN Vendors AS v ON v.VendorId = c.VendorId
ORDER BY Mechanic, Parts DESC, Vendor