--01.OneToOne RelationShip
CREATE TABLE Passports(
	PassportID INT PRIMARY KEY ,
	PassportNumber NVARCHAR(255) 
)
CREATE TABLE Persons(
	PersonID INT PRIMARY KEY,
	FirstName NVARCHAR(255),
	Salary DECIMAL,
	PassportID INT UNIQUE
)
INSERT INTO Passports VALUES 
  (101, 'N34FG21B'), 
  (102, 'K65LO4R7'), 
  (103, 'ZE657QP2')
INSERT INTO Persons VALUES 
  (1, 'Roberto', 43330.00, 102),
  (2, 'Tom', 56100.00, 103),
  (3, 'Yana', 60200.00, 101)
ALTER TABLE Persons
	ADD CONSTRAINT FK_Persons_Passports 
	FOREIGN KEY (PassportID) 
	REFERENCES Passports(PassportID)

--02.OneToMany RelationShip

CREATE TABLE Manufacturers(
	ManufacturerID INT NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	EstablishedOn DATE
)
CREATE TABLE Models(
	ModelID INT IDENTITY(101,1),
	[Name] NVARCHAR(50) NOT NULL,
	ManufacturerID INT
)
INSERT INTO Manufacturers
VALUES
(1,'BMW','07/03/1916'),
(2,'Tesla','01/01/2003'),
(3,'Lada','01/05/1966')

INSERT INTO Models
VALUES
('X1',1),
('i6',1),
('Model S',2),
('Model X',2),
('Model 3',2),
('Nova',3)

ALTER TABLE Manufacturers
ADD CONSTRAINT PK_ManufacturerID
PRIMARY KEY (ManufacturerID)

ALTER TABLE Models
ADD CONSTRAINT PK_ModelID
PRIMARY KEY (ModelID)

ALTER TABLE Models
ADD CONSTRAINT FK_Models_Manufacturers
FOREIGN KEY (ManufacturerID)
REFERENCES Manufacturers(ManufacturerID)

--3.ManyToManyRealationships
CREATE TABLE Students(
	StudentID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)
CREATE TABLE Exams(
	ExamID INT PRIMARY KEY IDENTITY(101,1),
	[Name] NVARCHAR(50) NOT NULL
)
CREATE TABLE StudentsExams(
	StudentID INT,
	ExamID INT,

CONSTRAINT PK_StudentID_ExamID 
PRIMARY KEY(StudentID, ExamID),

CONSTRAINT FK_StudentsExams_Students
FOREIGN KEY (StudentID)
REFERENCES Students(StudentID),

CONSTRAINT FK_StudentsExams_Exams
FOREIGN KEY (ExamID)
REFERENCES Exams(ExamID)
)
INSERT INTO Students
VALUES
('Mila'),('Toni'),('Ron')

INSERT INTO Exams
VALUES
('SpringMVC'),('Neo4j'),('Oracle 11g')

INSERT INTO StudentsExams
VALUES
(1,101),(1,102),(2,101),(3,103),(2,102),(2,103)

--04.SelfReferencing
CREATE TABLE Teachers(
	TeacherID INT PRIMARY KEY IDENTITY(101,1),
	[Name] NVARCHAR(50),
	ManagerID INT,

	CONSTRAINT FK_ManagerID_TeacherID 
	FOREIGN KEY (ManagerID) REFERENCES Teachers(TeacherID)
)
INSERT INTO Teachers 
VALUES
  ( 'John', NULL),
  ( 'Maya', 106),
  ( 'Silvia', 106),
  ( 'Ted', 105),
  ( 'Mark', 101),
  ( 'Greta', 101)

--05.OnlineStoreDatabase

CREATE TABLE Cities(
	CityID INT IDENTITY,
	[Name] NVARCHAR(50),

	CONSTRAINT PK_CityID 
	PRIMARY KEY(CityID)
)
CREATE TABLE Customers(
	CustomerID INT IDENTITY,
	[Name] NVARCHAR(50),
	Birthday DATE,
	CityID INT,

	CONSTRAINT PK_CustomerID
	PRIMARY KEY(CustomerID),

	CONSTRAINT FK_Customers_Cities
	FOREIGN KEY(CityID)
	REFERENCES Cities(CityID)
)
CREATE TABLE Orders(
	OrderID INT IDENTITY,
	CustomerID INT,

	CONSTRAINT PK_OrderID 
	PRIMARY KEY(OrderID),

	CONSTRAINT FK_Orders_Customers
	FOREIGN KEY(CustomerID)
	REFERENCES Customers(CustomerID)
)
CREATE TABLE ItemTypes(
	ItemTypeID INT IDENTITY,
	[Name] NVARCHAR(50),

	CONSTRAINT PK_ItemTypeID 
	PRIMARY KEY(ItemTypeID)
)
CREATE TABLE Items(
	ItemID INT IDENTITY,
	[Name] NVARCHAR(50),
	ItemTypeID INT,

	CONSTRAINT PK_ItemID
	PRIMARY KEY(ItemID),

	CONSTRAINT FK_Items_ItemTypes
	FOREIGN KEY(ItemTypeID)
	REFERENCES ItemTypes(ItemTypeID)
)
CREATE TABLE OrderItems(
	OrderID INT ,
	ItemID INT,

	CONSTRAINT PK_OrderItems
	PRIMARY KEY (OrderID,ItemID),

	CONSTRAINT FK_OrderItems_Orders 
	FOREIGN KEY (OrderID) 
	REFERENCES Orders(OrderID),

    CONSTRAINT FK_OrderItems_Items 
	FOREIGN KEY (ItemID) 
	REFERENCES Items(ItemID)
)

--06.UniversityDatabase

CREATE TABLE Majors(
	MajorID INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_MajorID
	PRIMARY KEY (MajorID)
)
CREATE TABLE Subjects(
	SubjectID INT IDENTITY,
	SubjectName NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_SubjectID
	PRIMARY KEY (SubjectID)
)
CREATE TABLE Students(
	StudentID INT IDENTITY,
	StudentNumber INT NOT NULL,
	StudentName NVARCHAR(50) NOT NULL,
	MajorID INT,

	CONSTRAINT PK_StudentID
	PRIMARY KEY (StudentID),

	CONSTRAINT FK_Students_Majors
	FOREIGN KEY(MajorID)
	REFERENCES Majors(MajorID)
)
CREATE TABLE Payments(
	PaymentID INT IDENTITY,
	PaymentDate DATE NOT NULL,
	PaymentAmount DECIMAL(15,2) NOT NULL,
	StudentID INT,

	CONSTRAINT PK_PaymentID
	PRIMARY KEY (PaymentID),

	CONSTRAINT FK_Payments_Students
	FOREIGN KEY(StudentID)
	REFERENCES Students(StudentID)
)
CREATE TABLE Agenda(
	StudentID INT NOT NULL,
	SubjectID INT NOT NULL,

	CONSTRAINT PK_StudentID_SubjectID
	PRIMARY KEY (StudentID,SubjectID),

	CONSTRAINT FK_Agenda_Students
	FOREIGN KEY(StudentID)
	REFERENCES Students(StudentID),

	CONSTRAINT FK_Agenda_Subjects
	FOREIGN KEY(SubjectID)
	REFERENCES Subjects(SubjectID)
)

--09.PeaksInRila

SELECT M.MountainRange,PeakName,Elevation FROM Peaks AS P
JOIN  Mountains AS M
ON M.Id = P.MountainId
WHERE M.Id = 17
ORDER BY Elevation DESC
