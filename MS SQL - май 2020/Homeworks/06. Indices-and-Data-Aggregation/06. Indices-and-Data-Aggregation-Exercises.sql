--Problem 1
SELECT COUNT(Id) AS [Count] FROM WizzardDeposits

--Problem 2
SELECT MAX(MagicWandSize) AS LongestMagicWand from WizzardDeposits

--Problem 3
SELECT DepositGroup,MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits
	GROUP BY DepositGroup

--Problem 4
SELECT TOP(2) DepositGroup FROM WizzardDeposits
	GROUP BY DepositGroup
	ORDER BY AVG(MagicWandSize)

--Problem 5
SELECT DepositGroup,SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
	GROUP BY DepositGroup

--Problem 6
SELECT DepositGroup,SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
	WHERE MagicWandCreator='Ollivander family'
	GROUP BY DepositGroup

--Problem 7
SELECT DepositGroup,SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
	WHERE MagicWandCreator='Ollivander family'
	GROUP BY DepositGroup
	HAVING SUM(DepositAmount)<150000
	ORDER BY TotalSum DESC

--Problem 8
SELECT DepositGroup,MagicWandCreator,MIN(DepositCharge) AS MinDepositCharge FROM WizzardDeposits
	GROUP BY DepositGroup,MagicWandCreator
	ORDER BY MagicWandCreator,DepositGroup

--Problem 9
	