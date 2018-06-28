
CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(15) NOT NULL,
	DailyRate INT,
	WeeklyRate INT,
	MonthlyRate INT,
	WeekendRate INT,
)
CREATE TABLE Cars(
	Id INT PRIMARY KEY IDENTITY,
	PlateNumber	INT NOT NULL,
	Manufacturer NVARCHAR(50),
	Model NVARCHAR(30),
	CarYear DATE,
	CategoryId INT CONSTRAINT FK_Cars_Categories FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Doors INT,
	Picture VARBINARY,
	Condition NVARCHAR(20),
	Available BIT,
)
CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Title NVARCHAR(30) NOT NULL,
	Notes NVARCHAR
)
CREATE TABLE Customers(
	Id INT PRIMARY KEY IDENTITY,
	DriverLicenceNumber INT NOT NULL,
	FullName NVARCHAR(30) NOT NULL,
	[Address] NVARCHAR(50),
	City NVARCHAR(30),
	ZIPCode INT,
	Notes NVARCHAR(100)
)
CREATE TABLE RentalOrders(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT CONSTRAINT FK_RentalOrders_Employees FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	CustomersId INT CONSTRAINT FK_RentalOrders_Customers FOREIGN KEY REFERENCES Customers(Id) NOT NULL,
	CarId INT CONSTRAINT FK_RentalOrders_Cars FOREIGN KEY REFERENCES Cars(Id) NOT NULL,
	TankLevel INT,
	KilometrageStart INT,
	KilometrageEnd INT,
	TotalKilometrage INT,
	StartDate DATE,
	EndDate DATE,
	TotalDays INT,
	RateApplied NVARCHAR(50),
	TaxRate NVARCHAR(50),
	OrderStatus NVARCHAR(15),
	Notes NVARCHAR(100)
)
INSERT INTO Employees(FirstName,LastName,Title,Notes)
VALUES
('Stanislav','Nikolov','Chef',NULL),
('Petya','Nikolova','Worker',NULL),
('Nikola','Nikolov','Small Boss',NULL)

INSERT INTO Categories(CategoryName,DailyRate,WeeklyRate,MonthlyRate,WeekendRate)
VALUES
('Best sales',1,2,3,4),
('Middle sales',9,4,3,4),
('Low sales',1,3,3,7)

INSERT INTO Customers(DriverLicenceNumber,FullName,
[Address],City,ZIPCode,Notes)
VALUES
(5214558,'Atanas Delchev','s.Rayovo','Samokov',2000,NULL),
(8696654,'Vasil Popov','s.Prodanovci','Samokov',2000,NULL),
(4036987,'Georgi Belchinski','s.Govedarci','Samokov',2000,NULL)

INSERT INTO Cars(PlateNumber,Manufacturer,Model,CarYear,
CategoryId,Doors,Picture,Condition,Available)
VALUES
(2058,'Ford','Mustang','2017',1,2,NULL,'Best',1),
(9999,'Honda','Civic','2000',3,2,NULL,'Worst',0),
(0000,'Nissan','Micra','1993',1,1,NULL,'Verry Bad',1)

INSERT INTO RentalOrders(EmployeeId,CustomersId,CarId,TankLevel,
KilometrageStart,KilometrageEnd,TotalKilometrage,StartDate,
EndDate,TotalDays,RateApplied,TaxRate,OrderStatus,Notes)
VALUES
(1,2,3,100,123000,133000,1000,NULL,NULL,NULL,NULL,NULL,'SELL',NULL),
(2,3,1,99,33000,45000,3000,NULL,NULL,NULL,NULL,NULL,'NOT',NULL),
(3,1,2,120,145000,236000,4500,NULL,NULL,NULL,NULL,NULL,'SELL',NULL)
