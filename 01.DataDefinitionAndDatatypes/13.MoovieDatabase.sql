CREATE TABLE Directors(
	Id INT PRIMARY KEY IDENTITY,
	DirectorName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(100)
)
CREATE TABLE Genres(
	Id INT PRIMARY KEY IDENTITY,
	GenreName NVARCHAR(15) NOT NULL,
	Notes NVARCHAR(100)
)
CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(15) NOT NULL,
	Notes NVARCHAR(100)
)
CREATE TABLE Movies(
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(30) NOT NULL,
	DirectorId INT CONSTRAINT FK_Movies_Directors FOREIGN KEY REFERENCES Directors(Id) NOT NULL,
	CopyrightYear DATE,
	[Length] DECIMAL(10,2),
	GenreId INT CONSTRAINT FK_Movies_Genres FOREIGN KEY REFERENCES Genres(Id) NOT NULL,
	CategoryId INT CONSTRAINT FK_Movies_Category FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Rating INT,
	Notes NVARCHAR(100) 
)
INSERT INTO Directors(DirectorName,Notes)
VALUES
('Michael Bay','Good'),
('Anthony Hopkins',NULL),
('Ton Hanks','Poor'),
('Benisio Del Torro',NULL),
('Jerry Bruckhaimer','Best')

INSERT INTO Genres(GenreName,Notes)
VALUES
('Action',NULL),
('Drama',NULL),
('Sci-Fi','Ohhhh mi gosh'),
('Porn',NULL),
('Comedy',NULL)

INSERT INTO Categories(CategoryName,Notes)
VALUES
('BlockBuster',NULL),
('Indian movies',NULL),
('TW Guide',NULL),
('Series',NULL),
('European movies',NULL)

INSERT INTO Movies(Title,DirectorId,CopyrightYear,
			[Length],GenreId,CategoryId,Rating,Notes)
VALUES
('Transformers',1,'2017',1.36,5,1,9,NULL),
('Fast and Forious',2,'2015',1.47,2,4,5,NULL),
('Armmagedonn',3,'2010',1.56,3,3,9,NULL),
('Gods mabye crazy',4,'2008',1.24,4,2,0,NULL),
('Coyote Ugly',5,'1998',1.32,1,5,8,'Sucks')