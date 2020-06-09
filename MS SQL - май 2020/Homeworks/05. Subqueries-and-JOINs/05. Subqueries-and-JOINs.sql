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
	
