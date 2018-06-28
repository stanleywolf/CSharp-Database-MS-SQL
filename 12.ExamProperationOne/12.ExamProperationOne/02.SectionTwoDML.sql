-- 02. Insert
use ReportService
INSERT INTO Employees(Firstname,
                      Lastname,
                      Gender,
                      Birthdate,
                      DepartmentId)
VALUES
('Marlo', 'O’Malley', 'M', '09/21/1958', '1'),
('Niki', 'Stanaghan', 'F', '11/26/1969', '4'),
('Ayrton', 'Senna', 'M', '03/21/1960 ', '9'),
('Ronnie', 'Peterson', 'M', '02/14/1944', '9'),
('Giovanna', 'Amati', 'F', '07/20/1959', '5');

INSERT INTO Reports(CategoryId,
                    StatusId,
                    OpenDate,
                    CloseDate,
                    Description,
                    UserId,
                    EmployeeId)
VALUES
('1', '1', '04/13/2017', NULL, 'Stuck Road on Str.133', '6', '2'),
('6', '3', '09/05/2015', '12/06/2015', 'Charity trail running', '3', '5'),
('14', '2', '09/07/2015', NULL, 'Falling bricks on Str.58', '5', '2'),
('4', '3', '07/03/2017', '07/06/2017', 'Cut off streetlight on Str.11', '1', '1');

-- 03. Update

UPDATE Reports
SET StatusId = 2 
WHERE StatusId = 1 AND CategoryId = 4

-- 04. Delete 
DELETE Reports
WHERE  StatusId = 4

--05.UserByAge
SELECT Username,Age
FROM Users
ORDER BY Age ASC, Username DESC

--06.UnassignedReports
SELECT Description,OpenDate
FROM Reports
WHERE EmployeeId IS NULL
ORDER BY OpenDate ASC, Description ASC

--07.Employee&Reports
SELECT E.FirstName,E.LastName,R.Description,
	   FORMAT( R.OpenDate, 'yyyy-MM-dd', 'en-US' )
FROM Employees AS E
JOIN Reports AS R ON R.EmployeeId = E.Id
WHERE R.EmployeeId IS NOT NULL
ORDER BY E.Id,R.OpenDate ,R.Id

--08.MostReportedCategory
SELECT Name AS CategoryName,COUNT(R.CategoryId)AS ReportsNumber
FROM Categories AS C
JOIN Reports AS R ON R.CategoryId = C.Id
GROUP BY Name 
ORDER BY ReportsNumber DESC,Name

--09.EmployessInCategory
SELECT C.Name AS CategoryName,COUNT(E.Id) AS [Employees Number]
FROM Employees AS E
JOIN Departments AS D ON D.Id = E.DepartmentId
JOIN Categories AS C ON C.DepartmentId = D.Id
GROUP BY C.Name
ORDER BY C.Name

--10.UsersPerEmployee
SELECT DISTINCT E.FirstName + ' ' + E.LastName AS [Name],
	   COUNT(r.UserId) as [Users Number]
FROM Reports AS R
 RIGHT JOIN Employees AS E ON E.Id = R.EmployeeId
GROUP BY E.FirstName + ' ' + E.LastName
ORDER BY [Users Number] DESC,Name

--11.EmergencyPatrol
SELECT R.OpenDate,R.Description,U.Email AS [Reporter Email]
FROM Reports AS R
JOIN Users AS U ON U.Id = R.UserId
JOIN Categories AS C ON C.Id = R.CategoryId
WHERE R.CloseDate IS NULL
AND LEN(R.Description) > 20
AND R.Description LIKE '%str%'
AND C.DepartmentId IN(1,4,5)
ORDER BY R.OpenDate,U.Email,R.Id

--12.BirthdayReport
SELECT DISTINCT C.Name AS [Categoty Name] 
FROM Categories AS C
JOIN Reports AS R ON R.CategoryId = C.Id
JOIN Users AS U ON U.Id = R.UserId
WHERE DAY(U.BirthDate) = DAY(R.OpenDate)
AND MONTH(U.BirthDate) = MONTH(R.OpenDate)
ORDER BY [Categoty Name]

--13.NumberCoincidence
SELECT DISTINCT Username
FROM Users AS U
JOIN Reports AS R ON R.UserId = U.Id
JOIN Categories AS C ON C.Id = R.CategoryId
WHERE LEFT(U.Username,1) LIKE '[0-9]' AND LEFT(U.Username,1) = CONVERT(VARCHAR(10),C.Id)
OR RIGHT(Username,1 )LIKE '[0-9]' AND RIGHT(Username,1) = CONVERT(VARCHAR(10),C.Id)

--14.Open/CloseStatistic
SELECT E.Firstname+' '+E.Lastname AS FullName, 
	   ISNULL(CONVERT(varchar, CC.ReportSum), '0') + '/' +        
       ISNULL(CONVERT(varchar, OC.ReportSum), '0') AS [Stats]
FROM Employees AS E
JOIN (SELECT EmployeeId,  COUNT(1) AS ReportSum
	  FROM Reports R
	  WHERE  YEAR(OpenDate) = 2016
	  GROUP BY EmployeeId) AS OC ON OC.Employeeid = E.Id
LEFT JOIN (SELECT EmployeeId,  COUNT(1) AS ReportSum
	       FROM Reports R
	       WHERE  YEAR(CloseDate) = 2016
	       GROUP BY EmployeeId) AS CC ON CC.Employeeid = E.Id
ORDER BY FullName

--15.AverageClosingTime
SELECT D.Name AS [Department Name],
	  ISNULL(CONVERT(VARCHAR(10),AVG( 
	  DATEDIFF(DAY,R.OpenDate,R.CloseDate))),'no info')
	  AS [Average Duration]
FROM Departments AS D
JOIN Categories AS C ON C.DepartmentId = D.Id
JOIN Reports AS R ON R.CategoryId = C.Id
GROUP BY D.Name

--16.FavoriteCategories
SELECT [Department Name],[Category Name],Percentage
FROM
(SELECT D.Name AS [Department Name],
	   C.Name AS [Category Name], 
	CAST(
	    ROUND(
		 COUNT(1) OVER(PARTITION BY C.Id) * 100.00 
		 / COUNT(1) OVER(PARTITION BY D.Id), 0
					  ) as int
				) AS Percentage
FROM Reports AS R 
JOIN Categories AS C ON C.Id = R.CategoryId
JOIN Departments AS D ON D.Id = C.DepartmentId) AS Stats
GROUP BY [Department Name],[Category Name],Percentage
ORDER BY [Department Name],[Category Name],Percentage










