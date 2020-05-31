CREATE DATABASE [Online STORE]

USE [Online STORE]

CREATE TABLE Cities
(
CityID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL
)

CREATE TABLE Customers
(
CustomerID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
Birthday DATE,
CityID INT NOT NULL FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE Orders
(
OrderID INT PRIMARY KEY IDENTITY,
CustomerID INT NOT NULL FOREIGN KEY REFERENCES Customers(Customerid)
)

CREATE TABLE ItemTypes
(
ItemTypeID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL
)

CREATE TABLE Items
(
ItemID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
ItemTypeID INT NOT NULL FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE OrderItems
(
OrderID INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
ItemID INT NOT NULL FOREIGN KEY REFERENCES Items(ItemID)
PRIMARY KEY(OrderID,ItemID)
)