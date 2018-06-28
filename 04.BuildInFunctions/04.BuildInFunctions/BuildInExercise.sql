USE SoftUni
GO
SELECT * FROM Employees
--1.
SELECT FirstName,LastName 
FROM Employees
WHERE FirstName LIKE 'SA%'
--2.
SELECT FirstName,LastName 
FROM Employees
WHERE  LastName LIKE '%ei%'
--3.
SELECT FirstName
FROM Employees
WHERE DepartmentID IN(3,10) AND
(HireDate >= 1995 OR HireDate <= 2005)
--4.
SELECT FirstName,LastName 
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%' 
--5.
SELECT [Name]
FROM Towns
WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name] 
--6.
SELECT TownId,[Name]
FROM Towns
WHERE [Name] LIKE '[M|K|B|E]%'
ORDER BY [Name]
--7.
SELECT TownId,[Name]
FROM Towns
WHERE [Name] NOT LIKE '[R|D|B]%'
ORDER BY [Name]
GO
--8.
CREATE VIEW v_EmployeesHiredAfter2000 AS
SELECT FirstName,LastName
FROM Employees
WHERE HireDate > '2001'
GO
SELECT * FROM v_EmployeesHiredAfter2000
--9.
SELECT FirstName,LastName 
FROM Employees
WHERE LEN(LastName) = 5 
GO
USE Geography
--10.
SELECT CountryName,IsoCode
FROM Countries
WHERE CountryName LIKE '%A%A%A%'
ORDER BY IsoCode
--11.
SELECT PeakName,RiverName,LOWER(PeakName + RIGHT(RiverName,LEN(RiverName) -1)) AS 'Mix'
FROM Rivers,Peaks
WHERE RIGHT(PeakName,1) = LEFT(RiverName,1)
ORDER BY Mix
GO
USE Diablo
SELECT * FROM Users
--12.
SELECT TOP(50) Name,FORMAT(Start,'yyyy-MM-dd')AS Start FROM Games
WHERE YEAR(Start) BETWEEN 2011 AND 2012
ORDER BY Start, Name
--13.
SELECT UserName,RIGHT(Email, LEN(Email) - CHARINDEX('@',Email)) AS 'Email Provider'
FROM Users
ORDER BY [Email Provider],UserName
--14.
SELECT UserName,IpAddress
FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username
--15.
SELECT G.Name AS Game,
Case
WHEN DATEPART(HOUR,G.Start) BETWEEN 0 AND 11 THEN 'Morning'
WHEN DATEPART(HOUR,G.Start) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN DATEPART(HOUR,G.Start) BETWEEN 18 AND 23 THEN 'Evening'
END AS [Part of the Day],
CASE
WHEN G.Duration <= 3 THEN 'Extra Short'
WHEN G.Duration BETWEEN 4 AND 6 THEN 'Short'
WHEN G.Duration > 6 THEN 'Long'
ELSE 'Extra Long'
END AS [Duration]
FROM Games AS G
ORDER BY G.Name,[Duration],[Part of the Day]
GO
USE Orders
--16.
SELECT ProductName,OrderDate,
DATEADD(DAY,3,OrderDate) AS [Pay Due],
DATEADD(MONTH,1,OrderDate) AS [Deliver Due]
FROM Orders