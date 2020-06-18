CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000 
AS
	SELECT FirstName,LastName FROM Employees
	WHERE Salary>35000
GO

CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@minSalary DECIMAL(18,4))
AS
	SELECT FirstName,LastName FROM Employees
	WHERE Salary>=@minSalary
GO

--Problem 3
CREATE PROCEDURE usp_GetTownsStartingWith (@token NVARCHAR(20))
AS	
	SELECT Name FROM Towns
	WHERE Name LIKE CONCAT(@token,'%')

exec usp_GetTownsStartingWith 'bo'

GO
--Problem 4
CREATE PROCEDURE usp_GetEmployeesFromTown  (@name NVARCHAR(20))
AS	
	SELECT FirstName,LastName FROM Employees AS e
	JOIN Addresses AS a ON e.AddressID=a.AddressID
	JOIN Towns AS t ON a.TownID=t.TownID
	WHERE t.Name = @name

GO

exec usp_GetEmployeesFromTown 'SOFIA'
GO
--Problem 5
CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(7)
	IF (@salary<30000)  SET @salaryLevel='Low'
		ELSE IF @salary>=30000 AND @salary<=50000 SET @salaryLevel='Average'
		ELSE SET @salaryLevel= 'High'
	RETURN  @salaryLevel
END

GO

SELECT dbo.ufn_GetSalaryLevel(29999)

--Problem 6	
CREATE OR ALTER PROCEDURE usp_EmployeesBySalaryLevel (@salaryLevel VARCHAR(7))
AS
	SELECT FirstName,LastName FROM Employees
	WHERE DBO.ufn_GetSalaryLevel(Salary)=@salaryLevel

GO

EXEC usp_EmployeesBySalaryLevel 'LOW'