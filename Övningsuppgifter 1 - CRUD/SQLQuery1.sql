--------------------------------------------
-- "Uppdatera (kopia på) tabell":
-- SELECT * INTO newTable FROM oldTable;

-- SELECT * FROM tableName;
--------------------------------------------

USE everyloop;

-- 1
-- Ta ut data (select) från tabellen GameOfThrones på sådant sätt att ni får ut en kolumn 
-- ’Title’ med titeln samt en kolumn ’Episode’ som visar episoder och säsonger i 
-- formatet ”S01E01”, ”S01E02”, osv. Tips: kolla upp funktionen format()

SELECT
     Title,
	CASE
		WHEN EpisodeInSeason < 10
		THEN FORMAT(Season, 'S0#') + FORMAT(EpisodeInSeason, 'E0#')
		ELSE FORMAT(Season, 'S0#') + FORMAT(EpisodeInSeason, 'E##')
	END AS Episode
FROM dbo.GameOfThrones;

-- 2
-- Uppdatera (kopia på) tabellen user och sätt username för alla användare så den blir de 
-- 2 första bokstäverna i förnamnet, och de 2 första i efternamnet (istället för 3+3 som det är i orginalet). 
-- Hela användarnamnet ska vara i små bokstäver.

SELECT * INTO dbo.Users2 FROM dbo.Users;
UPDATE dbo.Users2 SET Username = LOWER(SUBSTRING(FirstName, 1, 2) + SUBSTRING(LastName, 1, 2));

SELECT * FROM dbo.Users;
SELECT * FROM dbo.Users2;

-- 3
-- Uppdatera (kopia på) tabellen airports så att alla null-värden i kolumnerna Time och DST byts ut mot ’-’

SELECT * INTO dbo.Airports2 FROM dbo.Airports;

UPDATE dbo.Airports2 SET Time = '-' WHERE Time IS NULL;
UPDATE dbo.Airports2 SET DST = '-' WHERE DST IS NULL;

SELECT Time, DST FROM dbo.Airports;
SELECT Time, DST FROM dbo.Airports2;

-- 4
-- Ta bort de rader från (kopia på) tabellen Elements där 
-- ”Name” är någon av följande: 'Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium', samt alla rader där 
-- ”Name” börjar på någon av bokstäverna d, k, m, o, eller u.

SELECT * INTO dbo.Elements2 FROM dbo.Elements;

DELETE FROM dbo.Elements2
WHERE Name IN ('Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium')
	OR Name LIKE 'd%'
	OR Name LIKE 'k%'
	OR Name LIKE 'm%'
	OR Name LIKE 'o%'
	OR Name LIKE 'u%';

SELECT * FROM dbo.Elements;
SELECT * FROM dbo.Elements2;

-- 5
-- Skapa en ny tabell med alla rader från tabellen Elements. 
-- Den nya tabellen ska innehålla ”Symbol” och ”Name” från orginalet, samt en tredje kolumn med värdet 
-- ’Yes’ för de rader där ”Name” börjar med bokstäverna i ”Symbol”, och 
-- ’No’ för de rader där de inte gör det.

SELECT Symbol, Name INTO dbo.Elements3 FROM dbo.Elements;

ALTER TABLE dbo.Elements3
ADD Initials nvarchar(3);

UPDATE dbo.Elements3 SET Initials =
     CASE
          WHEN Name LIKE CONCAT(Symbol, '%')
          THEN 'Yes'
          ELSE 'No'
     END;

SELECT * FROM dbo.Elements3;

-- 6
-- Kopiera tabellen Colors till Colors2, men skippa kolumnen ”Code”.
-- Gör sedan en select från Colors2 som ger samma resultat som du skulle fått från select * from Colors;
-- (Dvs, återskapa den saknade kolumnen från RGBvärdena i resultatet).

SELECT * INTO dbo.Colors2 FROM dbo.Colors;

ALTER TABLE dbo.Colors2
DROP COLUMN Code;

SELECT * FROM dbo.Colors;
SELECT Name,
     '#' + FORMAT(Red, 'X2') + FORMAT(Green, 'X2') + FORMAT(Blue, 'X2') AS Code,
     Red,
     Green,
     Blue
FROM dbo.Colors2;

-- 7
-- Kopiera kolumnerna ”Integer” och ”String” från tabellen ”Types” till en ny tabell. 
-- Gör sedan en select från den nya tabellen som ger samma resultat som du skulle fått från select * from types;

SELECT Integer, String INTO dbo.Types2 FROM dbo.Types;

SELECT * FROM dbo.Types;
SELECT Integer,
     CAST(Integer AS FLOAT) / 100.0 AS Float,
     String,
     FORMAT(Integer, '2019-01-0# ') + FORMAT(Integer, '09:0#') + ':00.0000000' AS DateTime,
     CASE
          WHEN Integer % 2 = 0
          THEN 0
          ELSE 1
     END AS Bool
FROM dbo.Types2;

-- Vissa uppgifter ovan kan kräva att ni använder funktioner vi inte gått igenom ännu. 
-- Kolla dokumentationen för SQL Server, och se om ni kan hitta lämpliga funktioner där. 
-- Vi kommer gå igenom de vanligaste inbyggda funktionerna vid nästa tillfälle.
-- Spara era queries och ta med vid nästa tillfälle, så går vi igenom uppgifterna och ser om vi kan lösa dem tillsammans.
