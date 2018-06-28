--01.EmployeeSalaryAbove35000
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000 
AS
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary > 35000

EXEC GetEmployeesSalaryAbove35000
GO
--02.EmployeeSalaryAboveNumber
CREATE PROC usp_GetEmployeesSalaryAboveNumber (@limit DECIMAL(18,4))
AS
	SELECT FirstName,LastName
	FROM Employees
	WHERE Salary >= @limit

EXEC usp_GetEmployeesSalaryAboveNumber 48100
GO
--03.TownNamesStarting
CREATE PROC usp_GetTownsStartingWith (@firstChar VARCHAR(55))
AS
  BEGIN
	SELECT [Name]
	FROM Towns
	WHERE Name LIKE @firstChar + '%'
  END
EXEC usp_GetTownsStartingWith 'b'
GO
--04.EmployeeWithTown
CREATE PROC usp_GetEmployeesFromTown (@townName VARCHAR(55))
AS
  BEGIN
	SELECT FirstName,LastName
	FROM Employees AS E
	JOIN Addresses AS A ON A.AddressID = E.AddressID
	JOIN Towns AS T ON T.TownID = A.TownID
	WHERE T.Name LIKE @townName + '%'
  END
EXEC usp_GetEmployeesFromTown 'Sofia'
GO
--05.SalaryLevelFunction
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS VARCHAR(55)
AS
	BEGIN
		DECLARE @SalaryLevel VARCHAR(55)
			IF(@salary < 30000)
				BEGIN
				 SET @SalaryLevel = 'Low';
				END
			ELSE IF (@salary > 50000)
				BEGIN
					SET @SalaryLevel = 'High'
				END
			ELSE 
				BEGIN
					SET @SalaryLevel = 'Average'
				END
		RETURN @SalaryLevel
	END
GO	
--06.EmployeesBySalaryLevel
CREATE PROC usp_EmployeesBySalaryLevel (@salaryLevel VARCHAR(50))
AS
	SELECT FirstName,LastName
	FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel

EXEC usp_EmployeesBySalaryLevel 'High'
GO
--07.DefineFunction
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(55), @word VARCHAR(55)) 
RETURNS BIT
AS
	BEGIN
		DECLARE @isComprised BIT = 0;
		DECLARE @currentIndex INT = 1;
		DECLARE @currentChar CHAR;

		WHILE(@currentIndex <= LEN(@word))
			BEGIN
				SET @currentChar = SUBSTRING(@word,@currentIndex,1);
				IF(CHARINDEX(@currentChar,@setOfLetters) = 0)
				RETURN @isComprised;
				SET @currentIndex += 1;
			END
		RETURN @isComprised + 1;
	END
GO
--Testing
CREATE TABLE Testing (SetOfLetters varchar(max), Word varchar(max))
GO  -- DO NOT SUBMIT IN JUDGE "Go"

INSERT INTO Testing VALUES 
  ('oistmiahf', 'Sofia'), ('oistmiahf', 'halves'), ('bobr', 'Rob'), ('pppp', 'Guy')
GO  -- DO NOT SUBMIT IN JUDGE "Go"

SELECT SetOfLetters, Word,
  dbo.ufn_IsWordComprised(SetOfLetters, Word) AS Result
FROM Testing
GO
--08.DeleteEmployeesAndDepartments
BEGIN TRAN
GO
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN
DELETE FROM EmployeesProjects
WHERE EmployeeID IN (
						SELECT EmployeeID FROM Employees
						WHERE DepartmentID = @departmentId)

ALTER TABLE Departments
ALTER COLUMN ManagerID INT

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN(
					SELECT EmployeeID FROM Employees 
					WHERE DepartmentID = @departmentId)

UPDATE Departments
SET ManagerID = NULL
WHERE ManagerID IN(
					SELECT EmployeeID FROM Employees 
					WHERE DepartmentID = @departmentId)
DELETE FROM Employees
WHERE DepartmentID = @departmentId

DELETE FROM Departments
WHERE DepartmentID = @departmentId

SELECT COUNT(*)
FROM Employees
WHERE DepartmentID = @departmentId
END
ROLLBACK TRAN

GO
--09.FindFullName
CREATE PROC usp_GetHoldersFullName 
AS
	SELECT FirstName + ' ' + LastName AS [Full Name]
	FROM AccountHolders

EXEC usp_GetHoldersFullName
GO
--10.PeopleWhitBalanceHigherThan
CREATE PROC usp_GetHoldersWithBalanceHigherThan (@minBalance DECIMAL)
AS
BEGIN
		WITH CTE_MinBalanceAccountHolders(holderID) AS (
		SELECT AccountHolderId
		FROM Accounts
		GROUP BY AccountHolderId
		HAVING SUM(Balance) > @minBalance
	)
	
	SELECT AH.FirstName ,AH.LastName 
	FROM CTE_MinBalanceAccountHolders AS minBall
	JOIN AccountHolders AS AH ON AH.Id = minBall.holderID
	ORDER BY AH.LastName,AH.FirstName
END
EXEC usp_GetHoldersWithBalanceHigherThan 50000
GO
--11.FutureValueFunction
CREATE FUNCTION ufn_CalculateFutureValue 
(@sum DECIMAL(15,4), @yearlyInterestRate FLOAT, @numberOfYears INT)
RETURNS DECIMAL(15,4)
AS
	BEGIN
		DECLARE @result DECIMAL(15,4);
		SET @result = @sum * POWER(1 + @yearlyInterestRate,@numberOfYears);
		RETURN @result
	END
GO
--12.CalculatingInterest
CREATE PROC usp_CalculateFutureValueForAccount(@accountID INT,@interestRate FLOAT)
AS
  BEGIN
    DECLARE @years INT = 5;
	SELECT AC.AccountHolderId,
		   AH.FirstName,
		   AH.LastName,
		   AC.Balance AS [Current Balance],
		   dbo.ufn_CalculateFutureValue (AC.Balance,@interestRate,@years) AS [Balance in 5 years]
	FROM AccountHolders AS AH
	JOIN Accounts AS AC ON AC.AccountHolderId = AH.Id
	WHERE AC.Id = @accountID
  END
EXEC usp_CalculateFutureValueForAccount 1,0.1
GO
--13.ScalarFunction
CREATE FUNCTION ufn_CashInUsersGames (@gameName VARCHAR(50)) 
RETURNS TABLE AS
	RETURN
(
	SELECT SUM(E.Cash) AS [SumCash]
	FROM(
		SELECT G.Id,UG.Cash,ROW_NUMBER() OVER (ORDER BY UG.Cash DESC) AS [RowNumber]
		FROM Games AS G
		JOIN UsersGames AS UG ON UG.GameId = G.Id
		WHERE G.Name = @gameName) AS E
	WHERE E.RowNumber % 2 = 1
	)

GO
	
