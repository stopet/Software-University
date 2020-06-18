-- Problem 1
SELECT TOP(5) e.EmployeeID,e.JobTitle,a.AddressID,a.AddressText FROM Employees AS e
	JOIN Addresses AS a ON e.AddressID=a.AddressID 
	ORDER BY a.AddressID

-- Problem 2
SELECT TOP(50) e.FirstName,e.LastName,t.Name,a.AddressText FROM Employees AS e
	JOIN Addresses AS a ON e.AddressID=a.AddressID
	JOIN Towns AS t on a.TownID=t.TownID
	ORDER BY e.FirstName,e.LastName

-- Problem 3
SELECT e.EmployeeID,e.FirstName,e.LastName,d.Name FROM Employees AS e
	JOIN Departments AS d ON e.DepartmentID=d.DepartmentID
	WHERE d.Name='Sales'
	ORDER BY e.EmployeeID

-- Problem 4
SELECT TOP(5) e.EmployeeID,e.FirstName,e.Salary,d.Name FROM Employees AS e
	JOIN Departments AS d ON e.DepartmentID=d.DepartmentID
	WHERE e.Salary>15000
	ORDER BY d.DepartmentID

-- Problem 5
SELECT TOP(3) e.EmployeeID,e.FirstName FROM Employees AS e
	LEFT JOIN EmployeesProjects AS ep ON e.EmployeeID=ep.EmployeeID
	WHERE ep.ProjectID IS NULL
	ORDER BY e.EmployeeID

-- Problem 6
SELECT e.FirstName,e.LastName,e.HireDate,d.Name FROM Employees AS e
	JOIN Departments AS d ON e.DepartmentID=d.DepartmentID
	WHERE d.Name IN('Sales','Finance') AND e.HireDate>'1.1.1999' 
	ORDER BY e.HireDate

-- Problem 7
SELECT TOP(5) e.EmployeeID,e.FirstName,p.Name FROM Employees AS e
	 JOIN EmployeesProjects AS ep ON e.EmployeeID=ep.EmployeeID
	JOIN Projects AS p ON ep.ProjectID=p.ProjectID
	WHERE p.StartDate>'08.13.2002' AND p.EndDate IS NULL
	ORDER BY e.EmployeeID

-- Problem 8
SELECT  e.EmployeeID,e.FirstName,CASE
	WHEN YEAR(p.StartDate)>=2005 THEN NULL
	ELSE p.Name
	END AS [ProjectName]
	 FROM Employees AS e
	 JOIN EmployeesProjects AS ep ON e.EmployeeID=ep.EmployeeID
	JOIN Projects AS p ON ep.ProjectID=p.ProjectID
	WHERE e.EmployeeID=24

-- Problem 9
SELECT e1.EmployeeID,e1.FirstName,e1.ManagerID,e2.FirstName
	FROM Employees AS e1
	JOIN Employees AS e2 ON e1.ManagerID=e2.EmployeeID
	WHERE e1.ManagerID IN(3,7)

-- Problem 10
SELECT TOP(50) e1.EmployeeID,
				CONCAT(e1.FirstName,' ',e1.LastName) AS [EmployeeName],
				CONCAT(e2.FirstName,' ',e2.LastName) AS [ManagerName],
				d.Name AS [DepartmentName]
	FROM Employees AS e1
	JOIN Employees AS e2 ON e1.ManagerID=e2.EmployeeID
	JOIN Departments AS d ON e1.DepartmentID=d.DepartmentID
	ORDER BY EmployeeID

--Problem 11
SELECT TOP(1) AVG(e.Salary) AS MinAverageSalary FROM Employees AS e
	--JOIN Departments AS d ON e.DepartmentID=d.DepartmentID
	GROUP BY e.DepartmentID
	ORDER BY MinAverageSalary 

--Problem 12
SELECT mc.CountryCode,m.MountainRange,p.PeakName,p.Elevation FROM Peaks AS p
	JOIN Mountains AS m ON p.MountainId=M.Id
	JOIN MountainsCountries AS mc ON m.Id=mc.MountainId
	WHERE p.Elevation>2835 AND mc.CountryCode='BG'
	ORDER BY p.Elevation DESC

--Problem 13
SELECT CountryCode,COUNT(MountainId) AS MountainRanges FROM MountainsCountries
	WHERE CountryCode IN ('BG','RU','US')
	GROUP BY CountryCode
	
--Problem 14
SELECT TOP(5) c.CountryName,r.RiverName FROM Countries AS c
	LEFT JOIN CountriesRivers AS cr ON c.CountryCode=cr.CountryCode
	LEFT JOIN Rivers AS r ON cr.RiverId=r.Id
	WHERE c.ContinentCode='AF'
	ORDER BY c.CountryName

--Problem 15
SELECT  ContinentCode,
		CurrencyCode,
		CurrencyCount
			FROM 
			(SELECT ContinentCode,
					CurrencyCode,
					CurrencyCount,
					DENSE_RANK() OVER
					(PARTITION BY ContinentCode ORDER BY CurrencyCount DESC) AS [CurrencyRank]
		
					FROM	
						(SELECT ContinentCode,
								CurrencyCode,
								COUNT(*) AS [CurrencyCount] 
						FROM Countries
						GROUP BY ContinentCode,CurrencyCode) AS [CurrencyCountQuery]
					WHERE CurrencyCount >1) AS [CurrencyRankingQuery]
			WHERE CurrencyRank=1

--Problem 15
SELECT COUNT(MountainCount) AS Count FROM
		(SELECT C.CountryCode,MC.MountainId,COUNT(*) AS [MountainCount] FROM Countries AS c
			LEFT JOIN MountainsCountries AS mc ON c.CountryCode=mc.CountryCode
			WHERE MountainId IS NULL
			GROUP BY C.CountryCode,MountainId) AS [MountainCountQUERY]
	

SELECT * FROM Countries AS c
	LEFT JOIN MountainsCountries AS mc ON c.CountryCode=mc.CountryCode
	
