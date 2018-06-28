USE SoftUni
GO

SELECT DepartmentID,SUM(Salary) AS SumSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID ASC

SELECT DepartmentID,MAX(Salary)
FROM Employees
GROUP BY DepartmentID

SELECT COUNT(EmployeeID)
FROM Employees

SELECT COUNT(MiddleName)
FROM Employees

SELECT e.AddressID, COUNT(EmployeeID) AS TotalEmployees
FROM Employees AS e
GROUP BY e.AddressID
ORDER BY TotalEmployees DESC

SELECT DepartmentID,SUM(Salary)
FROM Employees
GROUP BY DepartmentID
HAVING SUM(Salary) > 200000

SELECT * FROM DailyIncome
PIVOT (
	AVG (IncomeAmount) FOR IncomeDay 
		IN ([MON],[TUE],[WED],[THU],[FRI],[SAT],[SUN])
	  ) 
	 AS AvgIncomePerDay

SELECT Salary, SUM(Salary)
OVER(ORDER BY EmployeeID)
FROM Employees
