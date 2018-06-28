CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Title NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(30)
)
CREATE TABLE Customers(
	AccountNumber INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	PhoneNumber INT,
	EmergencyName NVARCHAR(50),
	EmergencyNumber INT,
	Notes NVARCHAR(30)
)
CREATE TABLE RoomStatus(
	RoomStatus NVARCHAR(20)PRIMARY KEY NOT NULL,
	Notes NVARCHAR(50)
)
CREATE TABLE RoomTypes(
	RoomType NVARCHAR(20) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(50)
)
CREATE TABLE BedTypes(
	BedTypes NVARCHAR(20) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(50)
)
CREATE TABLE Rooms(
	RoomNumber INT PRIMARY KEY IDENTITY,
	RoomType NVARCHAR(20)  NOT NULL,
	BedType NVARCHAR(20)  NOT NULL,
	Rate  NVARCHAR(20),
	RoomStatus NVARCHAR(20) NOT NULL,
	Notes NVARCHAR(50)
)
CREATE TABLE Payments(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT CONSTRAINT FK_Payments_Employees FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	PaymentDate DATE NOT NULL,
	AccountNumber INT CONSTRAINT FK_Payments_Customers FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
	FirstDateOccupied DATE NOT NULL,
	LastDateOccupied DATE NOT NULL,
	TotalDays INT,
	AmountCharger INT NOT NULL,
	TaxRate INT,
	TaxAmount INT,
	PaymentTotal INT NOT NULL,
	Notes NVARCHAR(50)
)
CREATE TABLE Occupancies(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT CONSTRAINT FK_Occupancies_Employees FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	DateOccupied DATE,
	AccountNumber INT CONSTRAINT FK_Occupancies_Customers FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
	RoomNumber INT CONSTRAINT FK_Occupancies_Rooms FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL,
	RateAplied INT,
	PhoneCharge INT,
	Notes NVARCHAR(50)
)
INSERT INTO Employees(FirstName,LastName,Title,Notes)
VALUES
('Stanislav','Nikolov','Donkey',NULL),
('Nikola','Nikolov','Monkey',NULL),
('Yoan','Nikolov','Gorilla',NULL)
INSERT INTO Customers(FirstName,LastName,
PhoneNumber,EmergencyName,EmergencyNumber,Notes)
VALUES
('Stan4o','Stan4ev',0888789344,'Beep',123,NULL),
('Gosho','Stan4ev',0888789346,'Baap',123,NULL),
('Pe6o','Stan4ev',0888789345,'Buup',123,NULL)
INSERT INTO RoomStatus(RoomStatus,Notes)
VALUES
('Free',NULL),
('Not Free',NULL),
('Available',NULL)
INSERT INTO RoomTypes(RoomType,Notes)
VALUES
('Luxury',NULL),
('Small',NULL),
('Apartment',NULL)
INSERT INTO BedTypes(BedTypes,Notes)
VALUES
('small',NULL),
('middle',NULL),
('big',NULL)
INSERT INTO Rooms(RoomType,BedType,Rate,RoomStatus,Notes)
VALUES
('Luxury','small','Exelence','Free',NULL),
('Small','middle','Exelence','Available',NULL),
('Apartment','small','Exelence','Free',NULL)
INSERT INTO Payments(EmployeeId,PaymentDate,AccountNumber,
FirstDateOccupied,LastDateOccupied,TotalDays,AmountCharger,
TaxRate,TaxAmount,PaymentTotal,Notes)
VALUES
(1,'01/02/2015',1,CONVERT(datetime,'20/01/2015',103),CONVERT(datetime,'02/02/2015',103),13,5,10,15,100,NULL),
(2,'01/02/2015',3,CONVERT(datetime,'20/01/2015',103),CONVERT(datetime,'02/02/2015',103),11,5,4,10,88,NULL),
(3,'01/02/2015',2,CONVERT(datetime,'20/01/2015',103),CONVERT(datetime,'02/02/2015',103),12,5,3,1512,99,NULL)
INSERT INTO Occupancies(EmployeeId,DateOccupied,AccountNumber,
RoomNumber,RateAplied,PhoneCharge,Notes)
VALUES
(1,CONVERT(datetime,01/02/2017,103),1,1,9,2,NULL),
(2,CONVERT(datetime,01/04/2017,103),1,1,8,9,NULL),
(3,CONVERT(datetime,01/03/2017,103),1,1,7,4,NULL)

UPDATE Payments
SET TaxRate *= 0.97 

SELECT TaxRate FROM Payments

TRUNCATE TABLE Occupancies

SELECT * FROM Occupancies 