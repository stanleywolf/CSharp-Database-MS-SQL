CREATE DATABASE TableRelation
GO 
USE TableRelation
GO
CREATE TABLE Countries(
	CountryId INT NOT NULL IDENTITY,
	[Name] NVARCHAR(50), 

	CONSTRAINT PK_Countries
	PRIMARY KEY (CountryId)
)
CREATE TABLE Towns(
	TownId INT NOT NULL IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	CountryId INT NOT NULL,

	CONSTRAINT PK_Towns
	PRIMARY KEY (TownId),

	CONSTRAINT FK_Towns_Countries
	FOREIGN KEY (CountryId)
	REFERENCES Countries(CountryId)
)

INSERT INTO Countries
VALUES
('Bulgaria'),
('Germany'),
('Afganistan')

INSERT INTO Towns
VALUES
('Samokov',1),
('Gladbach',2),
('Kandahar',3)

SELECT * FROM Towns

--joins
SELECT *
FROM Countries AS C
JOIN Towns AS T
ON t.CountryId = c.CountryId
GO

CREATE TABLE Mountains(				
	MountainId INT NOT NULL IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_MountainId
	PRIMARY KEY (MountainId)
)
CREATE TABLE Peaks(					
	PeaksId INT NOT NULL IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	MountainId INT NOT NULL,

	CONSTRAINT PK_PeaksId
	PRIMARY KEY (PeaksId),

	CONSTRAINT FK_Peaks_Mountains
	FOREIGN KEY (MountainId)
	REFERENCES Mountains(MountainId)
)

CREATE TABLE Employees(
	EmployeeId INT NOT NULL IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_EmployeeId
	PRIMARY KEY (EmployeeId)
)
CREATE TABLE Projects(
	ProjectId INT NOT NULL IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_ProjectId
	PRIMARY KEY (ProjectId)
)
CREATE TABLE EmployeesProjects(
	EmployeeId INT NOT NULL ,
	ProjectId INT NOT NULL ,

	CONSTRAINT PK_EmployeeProjects
	PRIMARY KEY (EmployeeId,ProjectId),

	CONSTRAINT FK_EmployeesProjects_Employees
	FOREIGN KEY (EmployeeId)
	REFERENCES Employees(EmployeeId),

	CONSTRAINT FK_EmployeesProjects_Projects
	FOREIGN KEY (ProjectId)
	REFERENCES Projects(ProjectId)
)
INSERT INTO Employees
VALUES
('Gosho'),('Sasho'),('Pesho')

INSERT INTO Projects
VALUES
('MS SQL Server'),('Java Project'),('Swift Project')

INSERT INTO EmployeesProjects
VALUES
(1,2),(1,3),(2,2),(2,3),(3,2)

SELECT * FROM EmployeesProjects

USE SoftUni

SELECT *
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
ORDER BY e.FirstName

USE Geography

SELECT * 
FROM Mountains
SELECT * 
FROM Peaks

SELECT m.MountainRange, p.PeakName,p.Elevation 
FROM Mountains AS m
JOIN Peaks AS p
ON p.MountainId = m.Id
WHERE MountainId = 17
ORDER BY Elevation DESC