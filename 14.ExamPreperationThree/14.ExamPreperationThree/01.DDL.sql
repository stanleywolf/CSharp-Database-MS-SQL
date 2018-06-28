
CREATE TABLE Clients(
	ClientId INT PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Phone CHAR(12)
)

CREATE TABLE Mechanics(
	MechanicId INT PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Address VARCHAR(255)
)

CREATE TABLE Models(
	ModelId INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(50) UNIQUE,
)

CREATE TABLE Jobs(
	JobId INT PRIMARY KEY IDENTITY(1,1),
	ModelId INT FOREIGN KEY REFERENCES Models(ModelId),
	Status VARCHAR(11) DEFAULT 'Pending' CHECK(Status = 'Pending' OR Status = 'In Progress' OR Status = 'Finished'),
	ClientId INT FOREIGN KEY REFERENCES Clients(ClientId),
	MechanicId INT FOREIGN KEY REFERENCES Mechanics(MechanicId),
	IssueDate DATE,
	FinishDate DATE
)

CREATE TABLE Orders(
	OrderId INT PRIMARY KEY IDENTITY(1,1),
	JobId INT FOREIGN KEY REFERENCES Jobs(JobId),
	IssueDate DATE NULL,
	Delivered BIT DEFAULT 'False'
)

CREATE TABLE Vendors(
	VendorId INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(50) UNIQUE
)

CREATE TABLE Parts(
	PartId INT PRIMARY KEY IDENTITY(1,1),
	SerialNumber VARCHAR(50) UNIQUE,
	Description VARCHAR(255),
	Price DECIMAL(8,2) CHECK(PRICE > 0),
	VendorId INT FOREIGN KEY REFERENCES Vendors(VendorId),
	StockQty INT DEFAULT 0 CHECK(StockQty >= 0)
)

CREATE TABLE OrderParts(
	OrderId INT,
	PartId INT,
	Quantity INT DEFAULT 1 CHECK(Quantity > 0),
	CONSTRAINT PK_OrderId_PartId PRIMARY KEY(OrderId, PartId),
	CONSTRAINT FK_OrderId_Orders FOREIGN KEY(OrderId) REFERENCES Orders(OrderId),
	CONSTRAINT FK_PartId_Parts FOREIGN KEY(PartId) REFERENCES Parts(PartId)
)

CREATE TABLE PartsNeeded(
	JobId INT,
	PartId INT,
	Quantity INT DEFAULT 1 CHECK(Quantity > 0),
	CONSTRAINT PK_JobId_PartId PRIMARY KEY(JobId, PartId),
	CONSTRAINT FK_JobId_Parts FOREIGN KEY(JobId) REFERENCES Jobs(JobId),
	CONSTRAINT FK_Parts FOREIGN KEY(PartId) REFERENCES Parts(PartId)
)
--02.Insert
INSERT INTO Clients (FirstName, LastName, Phone)
VALUES ('Teri', 'Ennaco', '570-889-5187'),
	   ('Merlyn', 'Lawler', '201-588-7810'),
	   ('Georgene', 'Montezuma', '925-615-5185'),
	   ('Jettie', 'Mconnell', '908-802-3564'),
	   ('Lemuel', 'Latzke', '631-748-6479'),
	   ('Melodie', 'Knipp', '805-690-1682'),
	   ('Candida', 'Corbley', '908-275-8357')

INSERT INTO Parts (SerialNumber, Description, Price, VendorId)
VALUES ('WP8182119', 'Door Boot Seal', '117.86', 2),
	   ('W10780048', 'Suspension Rod', '42.81', 1),
	   ('W10841140', 'Silicone Adhesive', '6.77', 4),
('WPY055980', 'High Temperature Adhesive', '13.94', 3)

--03.Update
UPDATE Jobs
SET MechanicId = 3
WHERE Status = 'Pending' AND MechanicId IS NULL

UPDATE Jobs
SET Status = 'In Progress'
WHERE MechanicId = 3 AND Status = 'Pending'

--04.Delete
DELETE FROM OrderParts
WHERE OrderId = 19
DELETE FROM Orders
WHERE OrderId = 19