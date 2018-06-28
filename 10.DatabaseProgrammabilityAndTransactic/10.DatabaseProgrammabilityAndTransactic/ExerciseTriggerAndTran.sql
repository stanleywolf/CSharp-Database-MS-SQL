CREATE TABLE Logs(
	LogId INT NOT NULL IDENTITY,
	AccountId INT,
	OldSum DECIMAL(15,2),
	NewSum DECIMAL(15,2),

	CONSTRAINT PK_LogId
	PRIMARY KEY(LogId),

	CONSTRAINT FK_Logs_Accounts
	FOREIGN KEY (AccountId)
	REFERENCES Accounts(Id)
)

INSERT INTO  Logs
VALUES
(1,1,123.12,113.12)
SELECT * FROM Logs
GO
--14.CreateTableLogs
CREATE TRIGGER tr_AccBallChange
ON Accounts FOR UPDATE
AS
	BEGIN
		DECLARE @accountId INT = (SELECT Id FROM inserted);
		DECLARE @oldBalance DECIMAL(15,2) = (SELECT Balance FROM deleted);
		DECLARE @newBalance DECIMAL(15,2) = (SELECT Balance FROM inserted);

		IF(@newBalance <> @oldBalance)
		INSERT INTO Logs VALUES(@accountId,@oldBalance,@newBalance);
	END
GO
--15.CreateTableEmail
CREATE TRIGGER tr_LogsNotificationEmails ON Logs FOR INSERT
AS
BEGIN

  DECLARE @recipient int = (SELECT AccountId FROM inserted);
  DECLARE @oldBalance money = (SELECT OldSum FROM inserted);
  DECLARE @newBalance money = (SELECT NewSum FROM inserted);
  DECLARE @subject varchar(200) = CONCAT('Balance change for account: ', @recipient);
  DECLARE @body varchar(200) = CONCAT('On ', GETDATE(), ' your balance was changed from ', @oldBalance, ' to ', @newBalance, '.');  

  INSERT INTO NotificationEmails (Recipient, Subject, Body) 
  VALUES (@recipient, @subject, @body)
END
--16.DepositMoney

CREATE PROCEDURE usp_DepositMoney (@accountId INT, @moneyAmount DECIMAL(15,4)) 
	AS
	BEGIN
		BEGIN TRANSACTION

	--IF(@moneyAmount <= 0)
	--BEGIN
	--	RAISERROR('Negative',16,1)
	--	ROLLBACK
	--	RETURN
	--END

		UPDATE  Accounts
		SET Balance = Balance + @moneyAmount
		WHERE Id = @accountId

		IF(@@ROWCOUNT <> 1)
		BEGIN
			RAISERROR('Invalid account!',16,1)
			ROLLBACK
			RETURN
		END

		COMMIT
	END
GO
--17.DepositMoney
CREATE PROCEDURE usp_WithdrawMoney  (@accountId INT, @moneyAmount DECIMAL(15,4)) 
	AS
	BEGIN
		BEGIN TRANSACTION

		UPDATE  Accounts
		SET Balance = Balance - @moneyAmount
		WHERE Id = @accountId
		
		IF(@@ROWCOUNT <> 1)
		BEGIN
			RAISERROR('Invalid account!',16,1)
			ROLLBACK
			RETURN
		END

		COMMIT
	END
GO
--18.MoneyTransfer
CREATE PROCEDURE usp_TransferMoney (@senderId int, @receiverId int, @transferAmount money)
AS
BEGIN 

  DECLARE @senderBalanceBefore money = (SELECT Balance FROM Accounts WHERE Id = @senderId);

  IF(@senderBalanceBefore IS NULL)
  BEGIN
    RAISERROR('Invalid sender account!', 16, 1);
    RETURN;

  END   

  DECLARE @receiverBalanceBefore money = (SELECT Balance FROM Accounts WHERE Id = @receiverId);  

  IF(@receiverBalanceBefore IS NULL)
  BEGIN
    RAISERROR('Invalid receiver account!', 16, 1);
    RETURN;
  END   

  IF(@senderId = @receiverId)
  BEGIN
    RAISERROR('Sender and receiver accounts must be different!', 16, 1);
    RETURN;
  END  

  IF(@transferAmount <= 0)
  BEGIN
    RAISERROR ('Transfer amount must be positive!', 16, 1); 
    RETURN;

  END 

  BEGIN TRANSACTION
  EXEC usp_WithdrawMoney @senderId, @transferAmount;
  EXEC usp_DepositMoney @receiverId, @transferAmount;

  DECLARE @senderBalanceAfter money = (SELECT Balance FROM Accounts WHERE Id = @senderId);
  DECLARE @receiverBalanceAfter money = (SELECT Balance FROM Accounts WHERE Id = @receiverId);  

  IF((@senderBalanceAfter <> @senderBalanceBefore - @transferAmount) OR 
     (@receiverBalanceAfter <> @receiverBalanceBefore + @transferAmount))
    BEGIN
      ROLLBACK;
      RAISERROR('Invalid account balances!', 16, 1);
      RETURN;
    END

  COMMIT;

END

--19.Trigger
CREATE TRIGGER tr_UserGamesItems ON UserGameItems
INSTEAD OF INSERT
AS
	INSERT INTO UserGameItems
	SELECT ItemId,UserGameId FROM inserted
	WHERE ItemId IN (
		SELECT Id
		FROM Items
		WHERE MinLevel <= (
			SELECT [Level]
			FROM UsersGames
			WHERE Id = UserGameId
		)
	)
GO

--20.MassiveShopping
BEGIN TRANSACTION [TRAN1]

UPDATE UsersGames
SET Cash = Cash - (
	SELECT SUM(I.Price)
	FROM Items AS I
	WHERE I.MinLevel BETWEEN 11 AND 12
)
WHERE Id = 110

INSERT INTO UserGameItems(UserGameId,ItemId)

SELECT 110,Id FROM Items WHERE MinLevel BETWEEN 11 AND 12

	DECLARE @cash DECIMAL = (
		SELECT Cash
		FROM UsersGames 
		WHERE GameId = 87 AND UserId = 9
	)
	IF(@cash <= 0)
	BEGIN
		ROLLBACK
	END

COMMIT TRANSACTION [TRAN1]
GO
BEGIN TRANSACTION [TRAN2]

UPDATE UsersGames
SET Cash = Cash - (
	SELECT SUM(I.Price)
	FROM Items AS I
	WHERE I.MinLevel BETWEEN 19 AND 21
)
WHERE Id = 110

INSERT INTO UserGameItems(UserGameId,ItemId)

SELECT 110,Id FROM Items WHERE MinLevel BETWEEN 19 AND 21

	DECLARE @cash DECIMAL = (
		SELECT Cash
		FROM UsersGames 
		WHERE GameId = 87 AND UserId = 9
	)
	IF(@cash <= 0)
	BEGIN
		ROLLBACK
	END

COMMIT TRANSACTION [TRAN2]
GO
--21.EmployeesWithThreeProject
CREATE PROC usp_AssignProject(@emloyeeId INT, @projectID INT) 
AS 
BEGIN
	BEGIN TRAN
		INSERT INTO EmployeesProjects(EmployeeID,ProjectID)
		VALUES(@emloyeeId,@projectID)

		DECLARE @employeeProjCount INT = (
			SELECT COUNT(*)
			FROM EmployeesProjects
			WHERE EmployeeID = @emloyeeId
		)
	IF(@employeeProjCount > 3)
		BEGIN 
			RAISERROR('The employee has too many projects!',16,1)
			ROLLBACK;
		END
	ELSE COMMIT;
END

GO
--22.DeleteEmployeed
CREATE TRIGGER tr_FiredEmployees
ON Employees
INSTEAD OF DELETE
AS
	INSERT INTO Deleted_Employees
	SELECT EmployeeId , FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary
	FROM deleted

DELETE FROM Employees
WHERE EmployeeID = 1
 