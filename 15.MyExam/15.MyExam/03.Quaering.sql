
--05.
SELECT Id,Name
FROM Cities
WHERE CountryCode = 'BG'
ORDER BY Name
--06.
SELECT( 
CASE 
 WHEN MiddleName IS NULL 
 THEN CONCAT(FirstName,' ',LastName)
 ELSE
	CONCAT(FirstName,' ',MiddleName,' ',LastName)END)AS [Full Name],
	
	DATEPART(YEAR,BirthDate) AS [BirthYear]
FROM Accounts
WHERE DATEPART(YEAR,BirthDate) > '1991'
ORDER BY [BirthYear] DESC,FirstName

--07.
SELECT FirstName,LastName,
	FORMAT(BirthDate,'MM-dd-yyyy') AS BirthDate,C.Name AS Hometown,Email
FROM Accounts AS A
JOIN Cities AS C ON C.Id = A.CityId
WHERE Email LIKE 'e%'
ORDER BY C.Name DESC

--08.
SELECT C.Name AS City,
	   count(H.Id) AS Hotels
FROM Cities AS C
LEFT JOIN Hotels AS H ON H.CityId = C.Id
GROUP BY C.Name
ORDER BY Hotels DESC,C.Name

--09.
SELECT R.Id,R.Price,H.Name as [Hotel],C.Name AS [City]
FROM Rooms AS R
JOIN Hotels AS H ON H.Id = R.HotelId
JOIN Cities AS C ON C.Id = H.CityId
WHERE R.Type = 'First Class'
ORDER BY R.Price DESC,R.Id

--10.
SELECT Id AS AccountId,FullName,MIN(H.LongestTrip),MAX(H.LongestTrip)
FROM(
SELECT A.Id AS AccountId,
	   CONCAT(FirstName,' ',LastName) AS FullName,
	   DATEDIFF(DAY,T.ArrivalDate,T.ReturnDate) AS LongestTrip
FROM Accounts AS A
LEFT JOIN AccountsTrips AS AC ON AC.AccountId = A.Id
LEFT JOIN Trips AS T ON T.Id = AC.TripId
WHERE T.CancelDate IS NOT NULL
GROUP BY A.Id,CONCAT(FirstName,' ',LastName), DATEDIFF(DAY,T.ArrivalDate,T.ReturnDate)
--HAVING T.CancelDate IS NOT NULL
--ORDER BY LongestTrip DESC, A.Id)
)AS H


WITH CTE_Count(AccountId,FullName,Trip)
AS
(
	SELECT A.Id,
		   CONCAT(A.FirstName,' ',A.LastName)as FullName,
	       (DATEDIFF(DAY,T.ArrivalDate,T.ReturnDate)) AS Trip
FROM Accounts AS A
 JOIN AccountsTrips AS AC ON AC.AccountId = A.Id
 JOIN Trips AS T ON T.Id = AC.TripId
WHERE A.MiddleName IS  NULL
)

SELECT AccountId,FullName,max(Trip) AS LongestTrip ,min(Trip)AS ShortestTrip
FROM CTE_Count

GROUP BY AccountId,FullName
ORDER BY LongestTrip DESC,AccountId


--11.
SELECT TOP(5)C.Id ,C.Name AS City,C.CountryCode AS Country,COUNT(C.Id) AS Accounts
FROM Cities AS C
JOIN Accounts AS A ON A.CityId = C.Id
GROUP BY C.Id,C.Name,C.CountryCode
ORDER BY Accounts DESC
--JOIN AccountsTrips AS ATR ON ATR.AccountId = A.Id
--JOIN Trips AS T ON T.Id = ATR.TripId

--12.
SELECT A.Id,A.Email,C.Name, COUNT()
FROM Accounts AS A
JOIN Cities AS C ON C.Id = A.CityId
JOIN AccountsTrips AS ATR ON ATR.AccountId = A.Id
JOIN Hotels AS H ON H.CityId = C.Id
WHERE H.CityId = A.CityId  
GROUP BY A.Id,A.Email,C.Name

SELECT A.Id,COUNT(ATR.TripId)
FROM Accounts AS A
JOIN Cities AS C ON C.Id = A.CityId
JOIN AccountsTrips AS ATR ON ATR.AccountId = A.Id
JOIN Hotels AS H ON H.CityId = C.Id
WHERE H.CityId = A.CityId
GROUP BY A.Id

--13.
SELECT TOP(10)C.Id,
	   C.Name ,
	   ISNULL(SUM(H.BaseRate + R.Price),0) AS [Total Revenue],
	   COUNT(T.Id) AS Trips
FROM Cities AS C
 JOIN HotelS AS H ON H.CityId = C.Id
 JOIN Rooms AS R ON R.HotelId = H.Id
 JOIN Trips AS T ON T.RoomId = R.Id
WHERE YEAR(T.BookDate) = '2016'
GROUP BY C.Id,C.Name
ORDER BY [Total Revenue] DESC,Trips DESC


--14.

SELECT T.Id,
		H.Name AS HotelName,
		R.Type AS RoomType,
		Revenue = (
		CASE 
		WHEN T.CancelDate IS NULL
		THEN ISNULL(SUM(H.BaseRate + R.Price),0)
		ELSE 0
		END
		) 
FROM Trips AS T
 JOIN Rooms AS R ON R.Id = T.RoomId
JOIN HotelS AS H ON H.Id = R.HotelId
GROUP BY T.Id,H.Name,R.Type,T.CancelDate
ORDER BY RoomType,T.Id

--15.
SELECT A.Id AS AccountId,
	   A.Email,
	   C.CountryCode,
	   COUNT(T.Id) AS Trips
FROM Accounts AS A
JOIN Cities AS C ON C.Id = A.CityId
JOIN AccountsTrips AS ATR ON ATR.AccountId = A.Id
JOIN Trips AS T ON T.Id = ATR.TripId
WHERE A.Id = ATR.AccountId
GROUP BY A.Id,A.Email,C.CountryCode
ORDER BY Trips DESC, A.Id


--16.
SELECT T.Id AS TripId,
	   ATR.Luggage,
	   SUM(ATR.Luggage)
FROM Trips AS T
JOIN AccountsTrips AS ATR ON ATR.TripId = T.Id
GROUP BY T.Id,ATR.Luggage
ORDER BY ATR.Luggage DESC


--17.
SELECT T.Id,
	   [Full Name] = (
	   CASE 
 WHEN a.MiddleName IS NULL 
 THEN CONCAT(a.FirstName,' ',a.LastName)
 ELSE
	CONCAT(FirstName,' ',MiddleName,' ',LastName)END
	   ),
	    F.Name AS [From],
		C.Name AS [To],
		Duration = (
		CASE WHEN T.CancelDate IS NULL
		THEN CAST(DATEDIFF(DAY,T.ArrivalDate,T.ReturnDate) AS VARCHAR) + ' days'
		ELSE 'Canceled'
		END
		)
FROM Trips AS T
JOIN AccountsTrips AS TA ON TA.TripId = T.Id
JOIN Accounts AS A ON A.Id = TA.AccountId
JOIN Rooms AS R ON R.Id = T.RoomId
JOIN Cities AS F ON F.Id = A.CityId
JOIN Hotels AS H ON H.Id = R.HotelId
join Cities AS C ON C.Id = H.CityId

ORDER BY [Full Name],T.Id





SELECT *FROM Cities
SELECT *FROM Trips
SELECT *FROM Accounts
SELECT *FROM Rooms
SELECT *FROM AccountsTrips
SELECT *FROM Hotels