SELECT * FROM WizzardDeposits
--1.RecordCount
SELECT COUNT(*) AS [Count]
	FROM WizzardDeposits

--2.LongestMagicWand
SELECT MAX(MagicWandSize)
	FROM WizzardDeposits

--3.LongestMagicWandPerDepositGroups
SELECT DepositGroup,MAX(MagicWandSize) AS [LongestMagicWand]
	FROM WizzardDeposits
	GROUP BY DepositGroup

--4.SmallestDepositGroupPerMagicWandSize
SELECT TOP(2) DepositGroup 
	FROM WizzardDeposits
	GROUP BY DepositGroup 
	ORDER BY AVG(MagicWAndSize)

--5.DepositSum
SELECT  DepositGroup ,SUM(DepositAmount) AS [TotalSum]
	FROM WizzardDeposits
	GROUP BY DepositGroup

--6.DepositsSumForOllivanderFamily
SELECT DepositGroup,SUM(DepositAmount) AS [TotalSum]
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup

--7.DepositFilter
SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup
		HAVING SUM(DepositAmount) <= 150000
	ORDER BY TotalSum DESC

--8.DepositCharge
SELECT DepositGroup,MagicWandCreator,MIN(DepositCharge)
AS [MinDepositCharge]
	FROM WizzardDeposits
	GROUP BY DepositGroup,MagicWandCreator
	ORDER BY MagicWandCreator ASC,DepositGroup

--9.AgeGroups
SELECT[AgeGroup] =
	CASE
		WHEN Age >= 0 AND Age <= 10 THEN '[0-10]'
		WHEN Age >= 11 AND Age <= 20 THEN '[11-20]'
		WHEN Age >= 21 AND Age <= 30 THEN '[21-30]'
		WHEN Age >= 31 AND Age <= 40 THEN '[31-40]'
		WHEN Age >= 41 AND Age <= 50 THEN '[41-50]'
		WHEN Age >= 51 AND Age <= 60 THEN '[51-60]'
		WHEN Age >= 61  THEN '[61+]'
	END,
	COUNT(*)
FROM WizzardDeposits
GROUP BY 
CASE
		WHEN Age >= 0 AND Age <= 10 THEN '[0-10]'
		WHEN Age >= 11 AND Age <= 20 THEN '[11-20]'
		WHEN Age >= 21 AND Age <= 30 THEN '[21-30]'
		WHEN Age >= 31 AND Age <= 40 THEN '[31-40]'
		WHEN Age >= 41 AND Age <= 50 THEN '[41-50]'
		WHEN Age >= 51 AND Age <= 60 THEN '[51-60]'
		WHEN Age >= 61  THEN '[61+]'
	END

SELECT * FROM WizzardDeposits

--10.FirstLetter
SELECT DISTINCT LEFT(FirstName,1) AS [FirstLetter]
	FROM WizzardDeposits
	WHERE DepositGroup = 'Troll Chest'
	GROUP BY FirstName

--11.AverageInterest
SELECT DepositGroup,IsDepositExpired,AVG(DepositInterest)
AS [AverageInterest]
	FROM WizzardDeposits
	WHERE DepositStartDate >= '1985'
	GROUP BY DepositGroup,IsDepositExpired
	ORDER BY DepositGroup DESC,IsDepositExpired ASC

--12.RichWizardPoorWizard
SELECT SUM(e.[Difference]) AS SumDifference
FROM(
		SELECT
		DepositAmount - LEAD(DepositAmount) OVER (ORDER BY Id) AS [Difference]
FROM WizzardDeposits) AS e

--12.RichWizardPoorWizard
SELECT SUM(DiffTable.Diff) AS SumDifference FROM(
SELECT DepositAmount - (
	SELECT DepositAmount FROM WizzardDeposits
	WHERE Id = Host.Id + 1) AS Diff
FROM WizzardDeposits AS Host
) AS DiffTable 

--13.DepartmentsTotalSalaries
SELECT DepartmentID,SUM(Salary) AS [TotalSalary]
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

--14.EmployeeMinimumSalaries
SELECT DepartmentID,MIN(Salary) AS [MinimumSalary]
FROM Employees
WHERE DepartmentID IN(2,5,7)
AND HireDate >= '2000'
GROUP BY DepartmentID

--15.EmployeeAverageSalaries
SELECT *
INTO NewTable
FROM Employees
WHERE Salary > 30000

DELETE  FROM NewTable
WHERE ManagerID = 42

UPDATE NewTable
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS [AverageSalary]
FROM NewTable
GROUP BY DepartmentID

--16.EmployeeMaximumSalaries
SELECT DepartmentID,MAX(Salary) AS [MaxSalary]
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary)NOT BETWEEN 30000 AND 70000

--17.EmployeeCountSalaries
SELECT COUNT(Salary)
FROM Employees
WHERE ManagerID IS NULL

--18.3thHighestSalary
SELECT Salaries.DepartmentID, Salaries.Salary FROM(
	SELECT DepartmentId,MAX(Salary) AS Salary,
	DENSE_RANK()
	 OVER (PARTITION BY DepartmentId 
			ORDER BY Salary DESC) AS Rank
	FROM Employees
	GROUP BY DepartmentID, Salary) AS Salaries 
WHERE Rank=3


--19.SalaryChalange
SELECT TOP(10) FirstName,LastName,DepartmentID
FROM Employees AS e1
WHERE Salary > (
	SELECT AVG(Salary)
	FROM Employees AS e2
	WHERE e1.DepartmentID = e2.DepartmentID
	GROUP BY DepartmentID
)