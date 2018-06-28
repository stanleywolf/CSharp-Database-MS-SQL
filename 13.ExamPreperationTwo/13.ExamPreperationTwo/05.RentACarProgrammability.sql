--17.FindMyRide
CREATE FUNCTION udf_CheckForVehicle(@townName NVARCHAR(50), @seatsNumber INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @result VARCHAR(100) = ( 
	SELECT TOP(1) CONCAT(O.Name,' - ',M.Model)
	FROM Towns AS T 
	JOIN Offices AS O ON O.TownId = T.Id
	JOIN Vehicles AS V ON V.OfficeId = O.Id
	JOIN Models AS M ON M.Id = V.ModelId
	WHERE T.Name = @townName and M.Seats = @seatsNumber
	ORDER BY O.Name
	)

	IF(@result IS NULL)
	BEGIN
		RETURN 'NO SUCH VEHICLE FOUND'
	END
	RETURN @result
END
GO
--18.BayAVehicle
CREATE PROC usp_MoveVehicle(@vehicleId INT, @officeId INT) 
AS
BEGIN
	BEGIN TRANSACTION

	UPDATE Vehicles
	SET OfficeId = @officeId
	WHERE Id = @vehicleId

	DECLARE @countVehiclesById INT = (
		SELECT COUNT(v.Id) FROM Vehicles AS V
		WHERE V.OfficeId = @officeId
	)
	DECLARE @parkingPlaces INT = (
		SELECT ParkingPlaces FROM Offices AS O
		WHERE O.Id = @officeId
	)
	IF(@countVehiclesById > @parkingPlaces)
	BEGIN
		ROLLBACK
		RAISERROR('Not enough room in this office!',16,1)
	END
	COMMIT
END
GO
--19.MoveTheTally
CREATE TRIGGER tr_MoveTheTally 
ON Orders
FOR UPDATE
AS
BEGIN
	DECLARE @newTotalMileage INT = (
		SELECT TotalMileage FROM inserted
	) 
	DECLARE @oldTotalMileage INT = (
		SELECT TotalMileage FROM deleted
	) 
	DECLARE @vehicleId INT = (
		SELECT VehicleId FROM inserted
	)

	IF(@oldTotalMileage IS NULL AND @vehicleId IS NOT NULL)
	BEGIN
		UPDATE Vehicles
		SET Mileage += @newTotalMileage
		WHERE Id = @vehicleId
	END
END