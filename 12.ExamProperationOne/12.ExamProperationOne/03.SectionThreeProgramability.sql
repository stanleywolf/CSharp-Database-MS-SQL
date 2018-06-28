--17.EmployeesLoad
CREATE FUNCTION udf_GetReportsCount(@employeeId INT, @statusId INT) 
RETURNS INT
AS
BEGIN 
	DECLARE @sum int =	(
	SELECT COUNT(*) 
	FROM Reports
	WHERE StatusId = @statusId AND EmployeeId = @employeeId
	)
	RETURN @sum
END
GO

SELECT Id, FirstName, Lastname, dbo.udf_GetReportsCount(Id, 2) AS ReportsCount
FROM Employees
ORDER BY Id
GO
--18.AssignEmployee
CREATE PROC usp_AssignEmployeeToReport(@employeeId INT, @reportId INT) 
AS
BEGIN
	BEGIN TRAN
	DECLARE @categoryId INT = (
		SELECT CategoryId
		FROM Reports
		WHERE Id = @reportId
	)
	DECLARE @employeeDepId INT = (
		SELECT DepartmentId
		FROM Employees
		WHERE Id = @employeeId
	)
	DECLARE @categotyDepId INT = (
		SELECT DepartmentId
		FROM Categories
		WHERE Id = @categoryId
	)
	UPDATE Reports
	SET EmployeeId = @employeeId
	WHERE Id = @reportId

	IF(@employeeId IS NOT NULL AND @categotyDepId <> @employeeDepId)
	BEGIN 
		ROLLBACK;
		THROW 50013,
					'Employee doesn''t belong to the appropriate department!',
					 1;
	END;
	COMMIT;
END;

EXEC usp_AssignEmployeeToReport 17, 2;
SELECT EmployeeId FROM Reports WHERE id = 2
GO
--19.CloseReports
CREATE TRIGGER tr_CompleteStatus ON Reports 
AFTER UPDATE
AS
BEGIN
	UPDATE Reports
	SET StatusId = (
					SELECT Id
					FROM Status
					WHERE Label = 'completed'
	)
	WHERE Id IN (
					SELECT Id 
					FROM inserted
					WHERE Id IN(
							SELECT Id FROM deleted
							WHERE CloseDate IS NULL)
							AND CloseDate IS NOT NULL
					)
END;

UPDATE Reports
SET CloseDate = GETDATE()
WHERE EmployeeId = 5;

--20.CategoryRevision
SELECT C.Name AS [Category Name],
	   COUNT(R.StatusId) AS [Reports Number],
	   CASE
			WHEN SUM(CASE WHEN R.StatusId = 2 THEN 1 ELSE 0 END) >
				 SUM(CASE WHEN R.StatusId = 1 THEN 1 ELSE 0 END) THEN 'in progress'
		    WHEN SUM(CASE WHEN R.StatusId = 2 THEN 1 ELSE 0 END) <
				 SUM(CASE WHEN R.StatusId = 1 THEN 1 ELSE 0 END) THEN 'waiting'
            ELSE 'equal'
		END AS MainStatus
FROM Categories AS C
JOIN Reports AS R ON R.CategoryId = C.Id
WHERE R.StatusId IN(1,2)
GROUP BY C.Name
ORDER BY C.Name,[Reports Number],MainStatus

SELECT * FROM Employees
SELECT * FROM Departments
SELECT * FROM Categories
SELECT * FROM Users
SELECT * FROM Reports
SELECT * FROM Status