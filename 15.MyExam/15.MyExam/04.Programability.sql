--func
CREATE FUNCTION udf_GetAvailableRoom(
		@HotelId INT, 
		@Date DATETIME,
	    @People INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @result varchar(max)

RETURN @result

END
GO
--proc

CREATE PROC usp_SwitchRoom(@TripId INT, @TargetRoomId INT) 
AS
BEGIN
	BEGIN TRANSACTION
	UPDATE  Trips
	SET RoomId = @TargetRoomId
	WHERE Id = @TripId
	
	DECLARE @SAMEHOTELiD INT = (
		SELECT HotelId
		FROM Rooms as r
		join Trips as t on t.RoomId = r.Id
		where t.Id = @TripId
	)
	DECLARE @SAMEHOTELiD2 INT = (
		SELECT HotelId
		FROM Rooms as r
		join Trips as t on t.RoomId = r.Id
		where t.RoomId = @TargetRoomId
	)
	IF(@SAMEHOTELiD <> @SAMEHOTELiD2)
	begin
		ROLLBACK
		RAISERROR('Target room is in another hotel!',16,1)
	end
	declare @roomBeds int = (
		select r.Beds
		from Rooms as r
		join Trips as t on t.RoomId = r.Id
		where t.Id = @TripId
	)
	declare @roomBedstwo int = (
		select r.Beds
		from Rooms as r
		join Trips as t on t.RoomId = r.Id
		where t.Id = @TargetRoomId
	)
	IF(@roomBeds > @roomBedstwo)
	begin
		ROLLBACK
		RAISERROR('Not enough beds in target room!',16,1)
	end
	COMMIT
END
EXEC usp_SwitchRoom 10, 11
SELECT RoomId FROM Trips WHERE Id = 10


--trigger
CREATE TRIGGER tr_OrderDeliver ON Trips INSTEAD OF DELETE
AS
BEGIN

	DECLARE @CANCELDATE DATE = GETDATE()
	DECLARE @NewStatus INT = (SELECT CancelDate from deleted)


	SET 
--IF(@OldStatus = 0 AND @NewStatus = 1)
--BEGIN
--	UPDATE Parts
--	SET StockQty += op.Quantity
--	FROM Parts AS p
--	JOIN OrderParts AS op ON op.PartId = p.PartId
--	JOIN Orders AS o ON o.OrderId = op.OrderId
--	JOIN inserted AS i ON i.OrderId = o.OrderId
--	JOIN deleted AS d ON d.OrderId = i.OrderId
--	
--END
END
GO