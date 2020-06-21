CREATE DATABASE TripService

CREATE TABLE Cities
(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(20) NOT NULL,
CountryCode NVARCHAR(2) NOT NULL 
)

CREATE TABLE Hotels(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(30) NOT NULL,
CityId INT NOT NULL REFERENCES Cities(Id),
EmployeeCount INT NOT NULL,
BaseRate DECIMAL(10,2)
)

CREATE TABLE Rooms(
Id INT PRIMARY KEY IDENTITY,
Price DECIMAL(10,2) NOT NULL,
Type NVARCHAR(20) NOT NULL,
Beds INT NOT NULL,
HotelId INT NOT NULL REFERENCES Hotels(Id)
)

CREATE TABLE Trips(
Id INT PRIMARY KEY IDENTITY,
RoomId INT NOT NULL REFERENCES Rooms(Id),
BookDate DATETIME2 NOT NULL ,
ArrivalDate DATETIME2 NOT NULL ,
ReturnDate DATETIME2 NOT NULL ,
CancelDate DATETIME2
 CHECK(BookDate < ArrivalDate),
    CHECK(ArrivalDate < ReturnDate)
)

CREATE TABLE Accounts(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(50) NOT NULL,
MiddleName NVARCHAR(20),
LastName NVARCHAR(50) NOT NULL,
CityId INT NOT NULL REFERENCES Cities(Id),
BirthDate DATETIME2 NOT NULL,
Email VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE AccountsTrips(
AccountId INT NOT NULL REFERENCES Accounts(Id),
TripId INT NOT NULL REFERENCES Trips(Id),
PRIMARY KEY(AccountId,TripId),
Luggage INT NOT NULL CHECK (Luggage>=0)
)

ALTER TABLE Trips
ADD CONSTRAINT CHK_Arrivaldate_ReturnDate CHECK (ArrivalDate<ReturnDate)
ALTER TABLE Trips
ADD CONSTRAINT CHK_Bookdate_ArrivalDate CHECK (BookDate<ArrivalDate)







INSERT INTO Accounts(FirstName,MiddleName,LastName,CityId,BirthDate,Email)
VALUES
('John','Smith','Smith',34,'1975-07-21','j_smith@gmail.com'),
('Gosho',NULL,'Petrov',11,'1978-05-16','g_petrov@gmail.com'),
('Ivan','Petrovich','Pavlov',59,'1849-09-26','i_pavlov@softuni.bg'),
('Friedrich','Wilhelm','Nietzsche',2,'1844-10-15','f_nietzsche@softuni.bg')

INSERT INTO Trips (RoomId,BookDate,ArrivalDate,ReturnDate,CancelDate)
VALUES
(101,'2015-04-12','2015-04-14','2015-04-20','2015-02-02'),
(102,'2015-07-07','2015-07-15','2015-07-22','2015-04-29'),
(103,'2013-07-17','2013-07-23','2013-07-24',NULL),
(104,'2012-03-17','2012-03-31','2012-04-01','2012-01-10'),
(109,'2017-08-07','2017-08-28','2017-08-29',NULl)


--Problem 3
UPDATE Rooms
SET Price+=Price*0.14
WHERE HotelId IN(5,7,9)

--Problem 4
DELETE FROM AccountsTrips
	WHERE AccountId=47
DELETE FROM Accounts
	WHERE Id=47

--Problem 5
select FirstName,LastName,FORMAT(BirthDate,'MM-dd-yyyy'),c.Name AS [Hometown],Email from Accounts AS a
JOIN Cities AS c ON a.CityId=c.Id
where Email LIKE 'e%'
ORDER BY Hometown

--Problem 6
SELECT C.Name,COUNT(*) AS [Hotels] FROM Cities AS c
JOIN Hotels AS h ON h.CityId=c.Id
GROUP BY c.Name
ORDER BY Hotels DESC,c.Name


--Problem 7
SELECT at.AccountId,A.FirstName+' '+a.LastName, max(DATEDIFF(DAY,ArrivalDate,ReturnDate)) AS [LongestTrip],min(DATEDIFF(DAY,ArrivalDate,ReturnDate)) AS [ShortestTrip]  FROM Trips AS t
JOIN AccountsTrips AS at ON T.Id=at.TripId
JOIN Accounts AS a ON at.AccountId=a.Id
WHERE A.MiddleName IS NULL AND T.CancelDate IS  NULL
GROUP BY at.AccountId,A.FirstName+' '+a.LastName
ORDER BY  LongestTrip DESC,ShortestTrip,at.AccountId

--Problem 8
SELECT TOP(10) C.ID,C.Name,C.CountryCode ,COUNT(C.Name) AS [Accounts] FROM Cities AS c
JOIN Accounts AS a ON c.Id=a.CityId
GROUP BY C.ID,C.Name,C.CountryCode 
ORDER BY Accounts DESC

--Problem 9
SELECT a.Id,a.Email,c.Name,COUNT(C.Name) AS [Trips] FROM Accounts AS a
JOIN Cities AS c ON a.CityId=C.Id
JOIN AccountsTrips AS at ON a.Id=at.AccountId
JOIN Trips AS t ON at.TripId=t.Id
JOIN Rooms AS r ON t.RoomId=r.Id
JOIN Hotels AS h ON r.HotelId=h.Id
WHERE h.CityId=a.CityId
GROUP BY a.Id,a.Email,c.Name
ORDER BY Trips DESC,a.Id

--Problem 10
SELECT		t.ID,CASE
    WHEN MiddleName IS NOT NULL THEN FirstName + ' ' + MiddleName + ' ' + LastName
    ELSE FirstName + ' ' + LastName 
	END AS [Full Name],
			C.Name AS [FROM],
			C2.Name AS [To],
			CASE 
				WHEN T.CancelDate IS NOT NULL THEN 'Canceled'
				ELSE CONVERT(VARCHAR(11),DATEDIFF(DAY,t.ArrivalDate,t.ReturnDate))+' days' 
				END AS [Duration]
			FROM Trips AS t
JOIN AccountsTrips AS at ON T.Id=at.TripId
JOIN Accounts AS a ON at.AccountId=a.Id
JOIN Cities AS c ON a.CityId=c.ID
JOIN Rooms AS r ON t.RoomId=r.Id
JOIN Hotels AS h ON r.HotelId=h.Id
JOIN Cities AS c2 ON H.CityId=C2.Id
ORDER BY [Full Name],T.Id


--Problem 11
GO
CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATETIME2, @People INT)
RETURNS TABLE
AS
    RETURN
        (SELECT TOP(1)
            CONCAT( 'Room', ' ', r.Id, ': ', r.Type, ' (', r.Beds, ') - $',
                (h.BaseRate + r.Price) * @people) AS [Output]
        FROM Trips AS t
        JOIN Rooms AS r ON r.Id = t.RoomId
        JOIN Hotels AS h ON h.Id = r.HotelId
        WHERE @HotelId = h.Id AND r.Beds >= @People
            AND (ArrivalDate > @date OR ReturnDate < @date OR CancelDate < @Date)
        ORDER BY (h.BaseRate + r.Price) * @people DESC)


--Problem 12
GO
CREATE  PROCEDURE usp_SwitchRoom
    -- Add the parameters for the stored procedure here
    @TripID int,
    @TargetRoomID int
AS
BEGIN
    DECLARE @HotelID int, @HotelID2 int
    select @HotelID = HotelID from trips t
    join rooms r on r.id = t.roomid
    join hotels h on h.id = r.hotelid
    where t.id = @TripID
 
    select @HotelID2 = hotelID from rooms
    where id = @TargetRoomID
    DECLARE @TripAccounts int, @BedsCounts int
    SELECT @TripAccounts = COUNT(*) from AccountsTrips
    where tripID = @TripID
 
    SELECT @BedsCounts =  Beds from rooms
    where id = @TargetRoomID
   
    IF @HotelID != @HotelID2
    BEGIN
         THROW 51000, 'Target room is in another hotel!',1
    END
    ELSE
    BEGIN
        IF @TripAccounts > @BedsCounts
        BEGIN
          THROW 51001, 'Not enough beds in target room!',1
        END
        else
        BEGIN
        update trips set roomID = @TargetRoomID where id = @TripID
        END
    END
END

GO


	--11
CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @hotelBaseRate DECIMAL(18,2)
    SET @hotelBaseRate = (SELECT Hotels.BaseRate FROM Hotels WHERE Hotels.Id = @HotelId)
 
    DECLARE @roomId INT
    SET @roomId = (SELECT TOP(1) tempDB.roomId
                    FROM(
                    SELECT Rooms.Id AS roomId, Price, [Type], Beds, ArrivalDate, ReturnDate, CancelDate
                    FROM Rooms
                    JOIN Hotels ON Hotels.Id = Rooms.HotelId
                    JOIN Trips ON Trips.RoomId = Rooms.Id
                    WHERE Hotels.Id = @HotelId AND Rooms.Beds >= @People ) as tempDB
                    WHERE NOT EXISTS (SELECT tempDBTwo.roomId
                                FROM(
                                SELECT RoomsTwo.Id AS roomId, Price, [Type], Beds, ArrivalDate, ReturnDate, CancelDate
                                FROM Rooms as RoomsTwo
                                JOIN Hotels AS HotelsTwo ON HotelsTwo.Id = RoomsTwo.HotelId
                                JOIN Trips AS TripsTwo ON TripsTwo.RoomId = RoomsTwo.Id
                                WHERE HotelsTwo.Id = @HotelId AND RoomsTwo.Beds >= @People ) as tempDBTwo
                                WHERE (CancelDate IS NULL AND @Date > ArrivalDate AND @Date < ReturnDate))
                    ORDER BY tempDB.Price DESC)
 
    IF(@roomId IS NULL) RETURN 'No rooms available'
 
    DECLARE @highestPrice DECIMAL(18,2)
    SET @highestPrice = (SELECT Rooms.Price FROM Rooms WHERE Rooms.Id = @roomId)
 
    DECLARE @roomType NVARCHAR(200);
    SET @roomType = (SELECT Rooms.[Type] FROM Rooms WHERE Rooms.Id = @roomId);
 
    DECLARE @roomBeds INT
    SET @roomBeds = (SELECT Rooms.Beds FROM Rooms WHERE Rooms.Id = @roomId)
 
    DECLARE @totalPrice DECIMAL(18,2)  
    SET @totalPrice = (@hotelBaseRate + @highestPrice) * @People
    RETURN FORMATMESSAGE('Room %i: %s (%i beds) - $%s', @roomId, @roomType, @roomBeds, CONVERT(NVARCHAR(100),@totalPrice))
END

--12
CREATE PROCEDURE usp_SwitchRoom(@TripId INT, @TargetRoomId INT)
AS
BEGIN
    DECLARE @hotelId INT;
    SET @hotelId = (SELECT TOP(1) Hotels.Id
    FROM Trips
    JOIN Rooms ON Rooms.Id = Trips.RoomId
    JOIN Hotels ON Hotels.Id = Rooms.HotelId
    WHERE Trips.Id = @TripId)
 
    DECLARE @targetHotelId INT;
    SET @targetHotelId = (SELECT TOP(1) Hotels.Id
    FROM Rooms
    JOIN Hotels ON Hotels.Id = Rooms.HotelId
    WHERE Rooms.Id = @TargetRoomId)
 
    IF(@hotelId != @targetHotelId) THROW 50001, 'Target room is in another hotel!', 1;
 
    DECLARE @accountsCount INT;
    SET @accountsCount = (SELECT COUNT(Accounts.Id)
    FROM AccountsTrips
    JOIN Accounts ON Accounts.Id = AccountsTrips.AccountId
    WHERE AccountsTrips.TripId = @TripId)
 
    DECLARE @newRoomBeds INT;
    SET @newRoomBeds = (SELECT Rooms.Beds
    FROM Rooms
    WHERE Rooms.Id = @TargetRoomId)
 
    IF(@accountsCount > @newRoomBeds) THROW 50002, 'Not enough beds in target room!', 1;
 
    UPDATE Trips
    SET RoomId = @TargetRoomId
    WHERE Trips.Id = @TripId
END