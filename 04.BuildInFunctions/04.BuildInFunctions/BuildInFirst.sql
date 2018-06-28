CREATE DATABASE MusicStore
GO
USE MusicStore
GO

CREATE TABLE Artists(
	ArtistId INT NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_ArtistId
	PRIMARY KEY (ArtistId)
)

CREATE TABLE Genres(
	GenreId INT NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	[Description] NVARCHAR(MAX),

	CONSTRAINT PK_GenreId
	PRIMARY KEY (GenreId)
)

CREATE TABLE Orders(
	OrderId INT NOT NULL,
	OrderDate DATE NOT NULL,
	UserName VARCHAR(50) NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	City NVARCHAR(50) NOT NULL,
	Email NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_Orders
	PRIMARY KEY(OrderId)
)

CREATE TABLE Albums(
	AlbumId INT NOT NULL,
	GenreId INT NOT NULL,
	ArtistId INT NOT NULL,
	Title VARCHAR(50) NOT NULL,
	Price DECIMAL(15,2) NOT NULL,
	AlbumArtUrl VARCHAR(100),

	CONSTRAINT PK_Albums
	PRIMARY KEY (AlbumId),

	CONSTRAINT FK_Albums_Artists
	FOREIGN KEY (ArtistId)
	REFERENCES Artists(ArtistId),

	CONSTRAINT FK_Albums_Genres
	FOREIGN KEY (GenreId)
	REFERENCES Genres(GenreId)
)

CREATE TABLE OrdersDetails(
	OrdersDetailsId INT NOT NULL,
	OrderId INT NOT NULL,
	AlbumId INT NOT NULL,
	Quantity INT NOT NULL,
	UnitPrice DECIMAL(15,2) NOT NULL,

	CONSTRAINT PK_OrdersDetails
	PRIMARY KEY (OrdersDetailsId),

	CONSTRAINT FK_OrdersDetails_Albums
	FOREIGN KEY (AlbumId)
	REFERENCES Albums(AlbumId),

	CONSTRAINT FK_OrdersDetails_Orders
	FOREIGN KEY (OrderId)
	REFERENCES Orders(OrderId)
)


--insert some data


