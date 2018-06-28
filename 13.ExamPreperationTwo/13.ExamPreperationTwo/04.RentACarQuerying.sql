--05.Showrooms
SELECT Manufacturer,Model
FROM Models
ORDER BY Manufacturer,Id DESC

--06.YGeneration
SELECT FirstName,LastName
FROM Clients
WHERE Year(BirthDate) BETWEEN '1977' AND '1994'
ORDER BY FirstName,LastName,Id

--07.SpaciousOffice 
SELECT T.Name AS TownName,
	   O.Name AS OfficeName,
	   O.ParkingPlaces
FROM Offices AS O
JOIN Towns AS T ON T.Id = O.TownId
WHERE  O.ParkingPlaces > 25
ORDER BY T.Name ASC,O.Id ASC

--08.AvailableVehicles
SELECT M.Model,M.Seats,V.Mileage
FROM Models AS M
JOIN Vehicles AS V ON V.ModelId = M.Id
WHERE V.Id NOT IN(
			SELECT O.VehicleId
			FROM Orders as O
			WHERE O.ReturnDate IS NULL
)
ORDER BY V.Mileage,M.Seats DESC,M.Id

--09.OfficesPerTown
SELECT T.Name AS TownName,
		COUNT(O.Id) AS OfficesNumber
FROM Towns AS T
JOIN Offices AS O ON O.TownId = T.Id
GROUP BY T.Name
ORDER BY OfficesNumber DESC,T.Name ASC

--10.BuyersBestChoice
SELECT Manufacturer,Model,SUM(CountOfOrdersById) AS TimesOrdered
FROM(
SELECT M.Manufacturer,
	   M.Model,
	   V.Id,
	   COUNT(V.Id) AS CountOfOrdersById
FROM Orders AS O
LEFT JOIN Vehicles AS V ON V.Id = O.VehicleId
RIGHT JOIN Models AS M ON M.Id = V.ModelId
GROUP BY M.Manufacturer,M.Model,V.Id
) AS H1
GROUP BY Manufacturer,Model
ORDER BY TimesOrdered DESC, Manufacturer DESC,Model

--11.KindaPerson
SELECT Names,Class
FROM(
	SELECT CONCAT(C.FirstName,' ',C.LastName) AS Names,
		   M.Class AS Class,
		   RANK() OVER(PARTITION BY CONCAT(C.FirstName,' ',C.LastName) ORDER BY COUNT(M.Class) DESC) AS TopOrder
	FROM Clients AS C
	JOIN Orders AS O ON O.ClientId = C.Id
	JOIN Vehicles AS V ON V.Id = O.VehicleId
	JOIN Models AS M ON M.Id = V.ModelId
	GROUP BY  CONCAT(C.FirstName,' ',C.LastName),M.Class
	)AS J
WHERE TopOrder = 1
ORDER BY Names,Class

--12.AgeGroupRevenue
SELECT AgeGroup =
	CASE
		WHEN Year(c.BirthDate) BETWEEN 1970 AND 1979 THEN '70''s'
		WHEN Year(c.BirthDate) BETWEEN 1980 AND 1989 THEN '80''s'
		WHEN Year(c.BirthDate) BETWEEN 1990 AND 1999 THEN '90''s'
		ELSE 'Others'
	END,
	SUM(O.Bill) AS Revenue,
	AVG(O.TotalMileage) AS AverageMileage
FROM Clients AS C
JOIN Orders AS O ON O.ClientId = C.Id
GROUP BY
	CASE
		WHEN Year(c.BirthDate) BETWEEN 1970 AND 1979 THEN '70''s'
		WHEN Year(c.BirthDate) BETWEEN 1980 AND 1989 THEN '80''s'
		WHEN Year(c.BirthDate) BETWEEN 1990 AND 1999 THEN '90''s'
		ELSE 'Others'
	END
ORDER BY AgeGroup 

--13.ConsumptionInMind
SELECT TOP(7) H.Manufacturer,H.AverageConsumption
FROM(
SELECT TOP(7) M.Model,
		      M.Manufacturer,
			  AVG(M.Consumption) AS AverageConsumption,
			  COUNT(O.CollectionDate) AS Counter
FROM Orders AS O
RIGHT JOIN Vehicles AS V ON V.Id = O.VehicleId
JOIN Models AS M ON M.Id = V.ModelId
GROUP BY M.Manufacturer,M.Model
ORDER BY Counter DESC) AS H

WHERE AverageConsumption BETWEEN 5 AND 15
ORDER BY Manufacturer,AverageConsumption
--14.DebtHunter
SELECT Names,Emails,Bills,TownsName
FROM(
SELECT ROW_NUMBER() 
	OVER(PARTITION BY T.Name ORDER BY O.Bill DESC)  AS FirstBillDesc,
	CONCAT(C.FirstName,' ',C.LastName) AS Names,
	C.Email AS Emails,O.Bill AS Bills,T.Name AS TownsName,C.Id AS ClientId
FROM Orders AS O
JOIN Clients AS C ON C.Id = O.ClientId
JOIN Towns AS T ON T.Id  = O.TownId
WHERE O.CollectionDate > C.CardValidity
AND O.Bill IS NOT NULL) AS H
WHERE FirstBillDesc IN(1,2)
ORDER BY TownsName,Bills,ClientId

--15.TownStatistic
SELECT T.Name AS TownName,
	   (SUM(H.M)*100) / (ISNULL(SUM(H.M),0) + ISNULL(SUM(H.F),0)) AS MalePercent,
	   (SUM(H.F)*100) / (ISNULL(SUM(H.M),0) + ISNULL(SUM(H.F),0)) AS FemalePercent
FROM(
	SELECT O.TownId,
		CASE WHEN (Gender = 'M') THEN COUNT(O.Id)ELSE NULL END AS M,
		CASE WHEN (Gender = 'F') THEN COUNT(O.Id)ELSE NULL END AS F
	FROM Orders AS O
	JOIN Clients AS C ON C.Id = O.ClientId
	GROUP BY C.Gender,O.TownId
)AS H
JOIN Towns AS T ON T.Id = H.TownId
GROUP BY T.Name
GO
--16.HomeSweetHome
WITH CTE_RANKS(ReturnOfficeId,OfficeId,Id,Manufacturer,Model)
AS
(
SELECT RankedByDayDesc.ReturnOfficeId,
	   RankedByDayDesc.OfficeId,
	   RankedByDayDesc.Id,
	   RankedByDayDesc.Manufacturer,
	   RankedByDayDesc.Model
FROM(
SELECT DENSE_RANK() OVER
	   (PARTITION BY V.Id ORDER BY O.CollectionDate DESC) AS LastOrderedRank,
	   o.ReturnOfficeId,v.OfficeId,M.Manufacturer,M.Model,v.Id
FROM Orders AS O
RIGHT JOIN Vehicles AS V ON V.Id = O.VehicleId
JOIN Models AS M ON M.Id = V.ModelId) AS RankedByDayDesc
WHERE LastOrderedRank = 1
)
SELECT CONCAT(Manufacturer,' - ',Model) AS Vehicle,
	   Location =
		CASE
			WHEN (
				SELECT COUNT(*)
				FROM Orders as O
				WHERE O.VehicleId = CTE_RANKS.Id
			) = 0 --TODO
			THEN 'home'
			WHEN (
				CTE_RANKS.ReturnOfficeId IS NULL
				)
			THEN 'on a rent'
			WHEN(
				CTE_RANKS.OfficeId <> CTE_RANKS.ReturnOfficeId
			)
			THEN (
				SELECT CONCAT(T.Name,' - ',O.Name)
				FROM Towns AS T
				JOIN Offices AS O ON O.TownId = t.Id
				WHERE O.Id = CTE_RANKS.ReturnOfficeId
			)
		END
FROM CTE_RANKS
ORDER BY Vehicle,CTE_RANKS.Id












SELECT * FROM Clients
SELECT * FROM Models
SELECT * FROM Offices
SELECT * FROM Orders
SELECT * FROM Towns
SELECT * FROM Vehicles