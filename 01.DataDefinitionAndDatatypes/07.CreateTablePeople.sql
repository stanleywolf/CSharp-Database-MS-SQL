CREATE TABLE People(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(200) NOT NULL,
	Picture VARBINARY CHECK(DATALENGTH(Picture)<900*1024), 
	Height DECIMAL(15,2),
	[Weight] DECIMAL(15,2),
	Gender VARCHAR(1) CHECK(Gender in('m','f')) NOT NULL,
	--Gender varchar(1) NOT NULL Check(Gender ='m' OR Gender ='f'),
	Birthdate INT NOT NULL,
	Biography NVARCHAR(MAX)
)

INSERT INTO People([Name],Picture,
Height,[Weight],Gender,Birthdate,Biography)
VALUES
('Stanislav',null,1.78,78.8,'m',28.05,'chef'),
('Petya',null,1.58,52.8,'f',22.03,'banker'),
('Nikolay',null,1.83,98.5,'m',1.11,'iron man'),
('Nikola',null,1.22,23.5,'m',28.10,'schollboy'),
('Yoan',null,1.01,11.2,'m',14.01,'kindergarden')

