CREATE DATABASE Service

CREATE TABLE [Users]
(
Id INT PRIMARY KEY IDENTITY,
Username VARCHAR(30) NOT NULL,
Password VARCHAR(50) NOT NULL,
Name VARCHAR(50),
Birthdate DATETIME2,
Age INT CHECK (Age>=14 AND Age<=110),
Email VARCHAR(50) NOT NULL
)

CREATE TABLE Departments
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL
)

CREATE TABLE Employees
(
Id INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(25),
LastName VARCHAR(25),
Birthdate DATETIME2,
Age INT CHECK(Age>=18 AND Age<=110),
DepartmentId INT NOT NULL FOREIGN KEY REFERENCES  Departments(Id)
)

CREATE TABLE Categories
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
DepartmentId INT NOT NULL FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE Status
(
Id INT PRIMARY KEY IDENTITY,
Label VARCHAR(30) NOT NULL
)

CREATE TABLE Reports
(
Id INT PRIMARY KEY IDENTITY,
CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
StatusId INT NOT NULL FOREIGN KEY REFERENCES Status(Id),
OpenDate DATETIME2 NOT NULL,
CloseDate DATETIME2,
[Description] VARCHAR(200) NOT NULL,
UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id)
)

--Problem 2
INSERT INTO Employees(FirstName,LastName,Birthdate,DepartmentId)
VALUES
('Marlo','O''Malley','1958-9-21',1),
('Niki','Stanaghan','1969-11-26',4),
('Ayrton','Senna','1960-03-21',9),
('Ronnie','Peterson','1944-02-14',9),
('Giovanna','Amati','1959-07-20',5)

INSERT INTO Reports(CategoryId,StatusId,OpenDate,CloseDate,[Description],UserId,EmployeeId)
	VALUES
	(1,1,'2017-04-13',NULL,'Stuck Road on Str.133',6,2),
	(6,3,'2015-09-05','2015-12-06','Charity trail running',3,5),
	(14,2,'2015-09-07',NULL,'Falling bricks on Str.58',5,2),
	(4,3,'2017-07-03','2017-07-06','Cut off streetlight on Str.11',1,1)

--Problem 3
UPDATE Reports
SET CloseDate=GETDATE()
WHERE CloseDate IS NULL

--Problem 4
DELETE FROM Reports
	WHERE StatusId=4

DROP DATABASE [SERVICE]

--Problem 5
SELECT  Description,FORMAT(OpenDate,'dd-MM-yyyy') FROM Reports
	WHERE EmployeeId IS NULL
	ORDER BY OpenDate ASC,Description ASC

--Problem 6
SELECT r.Description,c.Name FROM Reports AS r
	JOIN Categories AS c ON r.CategoryId=c.Id 
	ORDER BY r.Description,c.Name

--Problem 7
SELECT TOP(5) c.Name,COUNT(*) AS ReportsNumber FROM Reports AS r
	JOIN Categories AS c ON r.CategoryId=c.Id
	GROUP BY c.Name
	ORDER BY ReportsNumber DESC, c.Name ASC

--Problem 8
SELECT u.Username,c.Name FROM Reports AS r
	JOIN Users AS u ON r.UserId=u.Id
	JOIN Categories AS c ON r.CategoryId=c.Id
	WHERE DAY(r.OpenDate)=DAY(u.Birthdate) AND MONTH(r.OpenDate)=MONTH(u.Birthdate)
	ORDER BY u.Username,c.Name

--Problem 9
SELECT e.FirstName+' '+e.LastName AS [FullName],COUNT(*) AS [UsersCount]  FROM Reports AS r
	 LEFT JOIN  Employees AS e ON r.EmployeeId=e.Id
	 LEFT JOIN Users AS u ON r.UserId=u.Id
	GROUP BY e.FirstName,e.LastName
	ORDER BY UsersCount DESC, FullName ASC

--Problem 10
SELECT CONCAT(e.FirstName,' ',e.LastName) AS Employee,
		d.Name AS Department,
		c.Name AS Category,
		r.Description,
		FORMAT(r.OpenDate,'dd.MM.yyyy'),
		s.Label AS Status,
		u.Name AS [User]
	 FROM Reports AS r
	JOIN Employees AS e ON r.EmployeeId=e.Id
	JOIN Categories AS c ON r.CategoryId=c.Id
	JOIN Status AS s ON r.StatusId=s.Id
	JOIN Users AS u ON r.UserId=u.Id
	JOIN Departments AS d ON e.DepartmentId=d.Id
	ORDER BY e.FirstName DESC,
			 e.LastName DESC,
			 Department ASC,
			 Category ASC,
			 Description ASC,
			 OpenDate ASC,
			 Status ASC,
			 User ASC


	