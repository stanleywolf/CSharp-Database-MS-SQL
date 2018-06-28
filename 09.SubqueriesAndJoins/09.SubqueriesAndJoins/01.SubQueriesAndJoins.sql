--01.EmployeeAddress
SELECT TOP(5) E.EmployeeID,
			  E.JobTitle,
			  E.AddressID,
			  A.AddressText
FROM Employees AS E
INNER JOIN Addresses AS A
ON A.AddressID = E.AddressID
ORDER BY E.AddressID
GO
--02.AdressesWithTowns
SELECT TOP(50)
		e.FirstName,
		e.LastName,
		t.[Name] AS Town,
		a.AddressText
FROM Employees AS e
	JOIN Addresses AS a
		ON a.AddressID = e.AddressID
	JOIN Towns AS t
		ON t.TownID = a.TownID
ORDER BY e.FirstName,e.LastName
GO
--03.SalesEmployee
SELECT e.EmployeeID,
		e.FirstName,
		e.LastName,
		d.Name AS DepartmentName
FROM Employees AS e
	INNER JOIN Departments AS d
ON (d.DepartmentID = e.DepartmentID AND d.Name = 'Sales')
ORDER BY e.EmployeeID
GO
--04.EmployeeDepartments
SELECT TOP(5) E.EmployeeID,E.FirstName,
			  E.Salary,D.Name AS DepartmentName
FROM Employees AS E
INNER JOIN Departments AS D
ON D.DepartmentID = E.DepartmentID
WHERE E.Salary > 15000
ORDER BY E.DepartmentID

GO
--05.EmployeesWithoutProject
SELECT TOP(3) E.EmployeeID,E.FirstName
FROM EmployeesProjects as EP
RIGHT JOIN Employees as E
ON E.EmployeeID = EP.EmployeeID
WHERE EP.EmployeeID IS NULL
ORDER BY EP.EmployeeID 

GO
--06.EmployeesHiredAfter
SELECT e.FirstName,e.LastName,
		e.HireDate,d.Name AS DeptName
FROM Employees AS E
INNER JOIN Departments AS D
ON (d.DepartmentID = e.DepartmentID 
	AND HireDate > '01/01/1999'
	AND D.Name IN ('Sales','Finance'))
ORDER BY HireDate
--07.EmployeeWithProject
SELECT TOP(5) E.EmployeeID,E.FirstName,
			  P.Name AS ProjectName
FROM Employees AS E
JOIN EmployeesProjects AS EP
ON EP.EmployeeID = E.EmployeeID
JOIN Projects AS P
ON P.ProjectID = EP.ProjectID
WHERE P.StartDate > '08/13/2002' AND P.EndDate IS NULL
ORDER BY E.EmployeeID

GO
--08.Employee24
SELECT TOP(5) E.EmployeeID,E.FirstName,
			  CASE
				WHEN P.StartDate < '2005' THEN P.Name
				ELSE NULL
			  END AS ProjectName
FROM Employees AS E
JOIN EmployeesProjects AS EP
ON EP.EmployeeID = E.EmployeeID
JOIN Projects AS P
ON P.ProjectID = EP.ProjectID
WHERE E.EmployeeID = 24

GO
--09.EmployeeManager
SELECT E.EmployeeID,E.FirstName,
	   E.ManagerID,M.FirstName AS ManagerName
FROM Employees AS E
JOIN Employees AS M
ON M.EmployeeID = E.ManagerID
WHERE E.ManagerID IN(3,7)
ORDER BY E.EmployeeID

GO
--10.EmployeeSummary
SELECT TOP(50) 
	emp.EmployeeID,
	emp.FirstName+' '+emp.LastName AS EmployeeName,
	mng.FirstName+' '+mng.LastName AS ManagerName,
	dept.[Name] AS DepartmentName
FROM Employees AS emp
LEFT OUTER JOIN Employees AS mng
ON mng.EmployeeID = emp.ManagerID
LEFT OUTER JOIN Departments AS dept
ON dept.DepartmentID = emp.DepartmentID
ORDER BY emp.EmployeeID
GO
--11.MinAverageSalary
SELECT MIN(AvgSalary.AverageSalary) AS MinAverageSalary
FROM
(
	SELECT AVG(Salary) AS AverageSalary
	FROM Employees AS e
	GROUP BY DepartmentID
) AS AvgSalary
GO
--12.HighestPeekInBulgaria
SELECT MC.CountryCode,M.MountainRange,
	   P.PeakName,P.Elevation
FROM Peaks AS P
JOIN Mountains AS M
ON M.Id = P.MountainId
JOIN MountainsCountries AS MC
ON MC.MountainId = M.Id
WHERE MC.CountryCode = 'BG' AND P.Elevation > 2835
ORDER BY P.Elevation DESC
GO
--13.CountMountainRange
SELECT CountryCode,COUNT(MountainId) AS MountainRanges
FROM MountainsCountries
WHERE CountryCode IN('BG','RU','US')
GROUP BY CountryCode
GO

--14.CountriesWithRivers
SELECT TOP(5)COU.CountryName,R.RiverName
FROM CountriesRivers AS CR
 JOIN Rivers AS R
ON R.Id = CR.RiverId
RIGHT JOIN Countries AS COU
ON COU.CountryCode = CR.CountryCode
JOIN Continents AS CONT
ON CONT.ContinentCode = COU.ContinentCode
WHERE CONT.ContinentName = 'Africa'
ORDER BY COU.CountryName ASC
GO

--15.ContinentsAndCurrencies
WITH CTE_CountriesInfo(ContinentCode,CurrencyCode,CurrencyUsage) AS(
SELECT ContinentCode,CurrencyCode,COUNT(CurrencyCode)
FROM Countries
GROUP BY ContinentCode,CurrencyCode
 HAVING COUNT(CurrencyCode) > 1
)

SELECT E.ContinentCode,CCI.CurrencyCode,E.MaxCurrency AS CurrencyUsage
 FROM(
SELECT ContinentCode,MAX(CurrencyUsage) AS MaxCurrency
FROM CTE_CountriesInfo
GROUP BY ContinentCode) AS E
 JOIN CTE_CountriesInfo AS CCI ON CCI.ContinentCode = E.ContinentCode
                                 AND CCI.CurrencyUsage = E.MaxCurrency


GO
--16.CountriesWithoutMounties
SELECT COUNT(*) AS CountriCode
 FROM Countries AS C
 LEFT JOIN MountainsCountries AS MC ON MC.CountryCode = C.CountryCode
 WHERE MC.CountryCode IS NULL
GO
--17.HighestPeakAndLongestRiverByCountries
SELECT TOP(5)C.CountryName,MAX(P.Elevation) AS HighestPeak,MAX(R.Length) AS LongestRiver
 FROM Countries AS C
 LEFT JOIN MountainsCountries AS MC ON MC.CountryCode = C.CountryCode
 LEFT JOIN Peaks AS P ON P.MountainId = MC.MountainId
 LEFT JOIN CountriesRivers AS CR ON CR.CountryCode = C.CountryCode
 LEFT JOIN Rivers AS R ON R.Id = CR.RiverId
GROUP BY C.CountryName
ORDER BY HighestPeak DESC, LongestRiver DESC,C.CountryName

GO
--18.HighestPeekNameAndElevationByCountries
WITH CTE_CountriesInfo(CountryName,PeakName,Elevation,Mountain)
AS(
	SELECT CS.CountryName,PE.PeakName,MAX(PE.Elevation),MO.MountainRange
	FROM Countries as CS
	LEFT JOIN MountainsCountries AS MC ON MC.CountryCode = CS.CountryCode
	LEFT JOIN Mountains AS MO ON MO.Id = MC.MountainId
	LEFT JOIN Peaks AS PE ON PE.MountainId = MC.MountainId
	GROUP BY CS.CountryName,PE.PeakName,MO.MountainRange
)
SELECT TOP(5) E.CountryName,
		ISNULL(CCI.PeakName,'(no highest peak)') as [Highest Peak Name],
		ISNULL(CCI.Elevation,0) AS [Highest Peak Elevation],
		ISNULL(CCI.Mountain,'(no mountain)') AS Mountain
FROM (
SELECT CountryName, MAX(Elevation) AS MaxElevation
 FROM CTE_CountriesInfo
GROUP BY CountryName) AS E
 LEFT JOIN CTE_CountriesInfo AS CCI 
 ON CCI.CountryName = E.CountryName 
 AND CCI.Elevation = E.MaxElevation
 ORDER BY E.CountryName,CCI.PeakName