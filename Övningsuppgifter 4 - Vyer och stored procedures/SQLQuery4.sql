---------------------------------------------------
-- Övningsuppgifter 4 – Vyer och stored procedures
---------------------------------------------------
USE everyloop;
-- 1. Kopiera hela tabellen Users till en ny tabell. Skapa sedan en vy med kolumnerna 
-- ID, Firstname, Lastname, Phone som listar alla kvinnliga användare från den nya tabellen. 
-- Om man lägger till nya användare i vyn så ska det bara gå om personnummret indikerar att det är en kvinna.
SELECT * INTO Users2 FROM Users;
GO;

CREATE VIEW vFemaleUsers AS
SELECT ID, FirstName, LastName, Phone
FROM Users2
WHERE CAST(SUBSTRING([ID], 10, 1) AS INT) % 2 = 0;
GO;

INSERT INTO vFemaleUsers(ID, FirstName, LastName, Phone)
VALUES ('500603-4218', 'Test2', '2Test2Namn', '000-1234567');
GO;

-- 2. Skapa en tabell ”ActiveUsers” med all data från ”Users”. 
-- Skapa en tabell ”DeletedUsers” med samma struktur men utan några rader. 
-- Skapa sedan en stored procedure ”DeleteUser” som tar ett username som argument. 
-- När man exekverar SP:n så ska de rader som matchar username i ”ActiveUsers” flyttas över till ”DeletedUsers”. 
-- SP:n ska returnera hur många rader som flyttats.
SELECT * INTO ActiveUsers FROM Users;
SELECT * INTO DeletedUsers FROM Users;
TRUNCATE TABLE DeletedUsers;

GO;

CREATE OR ALTER PROCEDURE spDeleteUser @UserName NVARCHAR(MAX)
AS
INSERT INTO DeletedUsers SELECT * FROM ActiveUsers WHERE UserName = @UserName;
DELETE FROM ActiveUsers WHERE UserName = @UserName;
PRINT @@ROWCOUNT;

EXEC spDeleteUser @UserName = 'ullalv';

SELECT * FROM ActiveUsers;
SELECT * FROM DeletedUsers;
GO;

-- 3. Skapa en SP som tar ett startdatum och ett slutdatum som parameterar och visar (select) 
-- en kolumn med datum och en kolumn med veckodag för alla dagar mellan (inklusive) start- och slutdatumet.
CREATE OR ALTER PROCEDURE spDaysBetween
@StartDate DATE,
@EndDate DATE
AS
WHILE (@StartDate < @EndDate)
BEGIN
    SELECT FORMAT(@startdate, 'dd/MM') AS [Datum],
        DATENAME(WEEKDAY, @startdate) AS [Veckodag];
    SET @StartDate = DATEADD(day, 1, @StartDate);
    PRINT @StartDate;
END

EXEC spDaysBetween @StartDate = '2020-01-01', @EndDate = '2020-01-31'

-- 4. Antag att vi har en fabrik med 4 produktionslinjer där vi då och då kollar av hur många 
-- enheter som producerats sedan senaste avcheckning och lagrar en timestamp, vilken linje och hur många produkter. 
-- Skapa en ny tabell med testdata för att simulera att vi samlat in sådan data under 10 års tid. 
-- Tabellen ska innehålla 1 miljon rader med kolumnerna 
-- ”timestamp” som är random datum och tid i spannet 10 år tillbaks och nu; 
-- ”line” som är ett random värde ’A’, ’B’, ’C’ eller ’D’; 
-- samt ”count” som är ett random värde 1-5.
CREATE TABLE Factory(
    [Timestamp] DATETIME2 NOT NULL,
    [Line] CHAR NOT NULL,
    [Count] INT NOT NULL,
    CHECK([Line] LIKE '[A-D]'),
    CHECK([Count] >= 1 AND [Count] <= 5)
);

DECLARE @i INT = 0;
DECLARE @RandomDate DATETIME;
DECLARE @StartDate DATETIME = DATEADD(YEAR, -10, GETDATE());
DECLARE @EndDate DATETIME = GETDATE();

WHILE @i < 1000
BEGIN
    SET @RandomDate = DATEADD(SECOND, CAST(RAND() * DATEDIFF(SECOND, @StartDate, @EndDate) AS INT), @StartDate);
	SET @i += 1;
	
	INSERT INTO Factory ([Timestamp], [Line], [Count])
	VALUES (@RandomDate,
            CHAR(FLOOR(RAND() * 4) + 65),
            CAST((RAND() * 5) + 1 AS INT));
END

-- TRUNCATE TABLE Factory;

SELECT TOP 100 * FROM Factory ORDER BY [Timestamp];

-- 5. Skriv en SP som tar en linje, en starttid, en stoptid, och ett intervall (antal minuter) som inparametrar. 
-- SP:n arbetar med tabellen vi skapade i uppgift (d), och ska visa en tabell med 
-- antal producerade enheter på en given linje, per intervall. 
-- Dvs, om vi skickar in linje A, starttid ’2015-02-01 10:00’, stopptid ’2015-02-01 12:00’ och intervallet 30 (minuter), 
-- så vill vi ha ut 4 rader som visar summan av producerade enheter på linjen per 30 minuter, med start- och stop-tid på varje intervall.
-- Exempel output:
-- Start 				End 				Units
-- 2015-02-01 10:00 	2015-02-01 10:30 	6
-- 2015-02-01 10:30 	2015-02-01 11:00 	3
-- 2015-02-01 11:00 	2015-02-01 11:30 	0
-- 2015-02-01 11:30 	2015-02-01 12:00 	5


-- 6. Skapa en funktion som tar ett personnummer (varchar) som inparameter och kontrollerar så att det är korrekt formaterat, 
-- samt om kontrollsiffran stämmer. Funktionen ska returnera 1 om det är ett riktigt personnummer, annars 0.

