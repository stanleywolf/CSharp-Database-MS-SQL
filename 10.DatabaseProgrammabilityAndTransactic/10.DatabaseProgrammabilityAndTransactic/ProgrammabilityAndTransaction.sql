--FUNCTIONS

CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@salary DECIMAL)
RETURNS VARCHAR(7)
AS 
BEGIN
	DECLARE @level VARCHAR(7);
		IF(@salary < 30000)
		BEGIN
			SET @level = 'Low';
		END
		ELSE IF(@salary >= 30000 AND @salary < 50000)
		BEGIN
			SET @level = 'Average';
		END
		ELSE
		BEGIN
			SET @level = 'High';
		END
	RETURN @level;
END
GO
SELECT E.FirstName,E.LastName,E.Salary,
	   [dbo].ufn_GetSalaryLevel(Salary) AS SalaryLevel
FROM Employees AS E
GO

--PROCEDURE
CREATE OR ALTER PROC udp_GetEmployeesBySeniority
AS
	SELECT *
	FROM Employees
	WHERE DATEDIFF(YEAR,HireDate,GETDATE()) > 15

EXEC udp_GetEmployeesBySeniority
GO

CREATE OR ALTER PROC udp_AssignProject(@EmployeeID INT,@ProjectID INT)
AS
BEGIN
	DECLARE @maxProjectCountToAssigh INT = 3;
	DECLARE @EmployeeProjectCount INT = (
		SELECT COUNT(ep.EmployeeID)
		FROM EmployeesProjects AS ep
		WHERE ep.EmployeeID = @EmployeeID
		)
		BEGIN TRAN
		INSERT INTO EmployeesProjects(EmployeeID,ProjectID)
		VALUES
		(@EmployeeID,@ProjectID)

		IF (@EmployeeProjectCount > @maxProjectCountToAssigh)
		BEGIN
			RAISERROR('Too many projects!',16,1);
			ROLLBACK
			RETURN;
		END
		ELSE
		COMMIT
END
GO 
EXEC udp_AssignProject 2,9
GO
--Transaction

CREATE OR ALTER PROC udp_WithdrowMoney @accountID INT,@amount DECIMAL
AS
BEGIN
   BEGIN TRANSACTION
   UPDATE Accounts
   SET Balance = Balance - @amount
   WHERE Id = @accountID

   DECLARE @newBalance DECIMAL =(
	SELECT Balance
	FROM Accounts
	WHERE Id = @accountID
   );
   IF (@newBalance < 0)
   BEGIN
	    RAISERROR('Invalid Transaction!', 16, 1);
		ROLLBACK;
		RETURN;
   END
   IF @@ROWCOUNT <> 1
   BEGIN
		RAISERROR('Invalid account!', 16, 2);
		ROLLBACK;
		RETURN;
	END
	COMMIT;
END
GO
--Triger
CREATE TRIGGER tr_TownsUpdate ON Towns FOR UPDATE
AS
 BEGIN
		IF(EXISTS(
			SELECT *
			FROM inserted
			WHERE(Name IS NULL OR LEN(Name) = 0)))
		BEGIN
			RAISERROR('The name cannot be null!',16,1);
			ROLLBACK;
			RETURN;
		END
 END
 UPDATE Towns
 SET Name = ''
WHERE TownID = 1






