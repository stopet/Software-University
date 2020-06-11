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