-------------------------------------------
-- Övningsuppgifter 3 – Aggregering av data
-------------------------------------------
-- Nu när vi lärt oss grunderna i hur man plockar ut data ur tabeller med hjälp av SQL så ska vi kolla på 
-- hur vi får ut sådan information som inte står i klartext, men som vi kan räkna ut och sammanställa på olika vis.

USE everyloop;

-- 1. Ta ut (select) en rad för varje (unik) period i tabellen ”Elements” med följande kolumner:
--    ”period”,
--    ”from” med lägsta atomnumret i perioden,
--    ”to” med högsta atomnumret i perioden,
--    ”average isotopes” med genomsnittligt antal isotoper visat med 2 decimaler,
--    ”symbols” med en kommaseparerad lista av alla ämnen i perioden.

-- SELECT *
-- FROM Elements

SELECT DISTINCT Period,
    MIN(Number) AS [From],
    MAX(Number) AS [To],
    -- FORMAT(AVG(Stableisotopes * 1.0), '0.00') AS [Average],
    FORMAT(COALESCE(AVG(Stableisotopes * 1.0), 0), '0.00') AS [Average isotopes],
    STRING_AGG(Symbol, ',') AS [Symbols]
FROM Elements
GROUP BY Period

-- 2. För varje stad som har 2 eller fler kunder i tabellen Customers,
--    ta ut (select) följande kolumner: ”Region”, ”Country”, ”City”, samt ”Customers” som anger hur många kunder som finns i staden.

-- SELECT *
-- FROM company.customers
-- WHERE City LIKE 'London'

SELECT Region, Country, City, COUNT(*) AS [Customers]
FROM company.customers
GROUP BY Region, Country, City
HAVING COUNT(*) >= 2
ORDER BY Customers DESC

-- 3. Skapa en varchar-variabel och skriv en select-sats som sätter värdet: 
--    ”Säsong 1 sändes från april till juni 2011. Totalt sändes 10 avsnitt, som i genomsnitt sågs av 2.5 miljoner människor i USA.”,
--    följt av radbyte/char(13),
--    följt av ”Säsong 2 sändes …” osv.
--    När du sedan skriver (print) variabeln till messages ska du alltså få en rad för varje säsong enligt ovan,
--    med data sammanställt från tabellen GameOfThrones.
--    Tips: Ange ’sv’ som tredje parameter i format() för svenska månader.

-- SELECT *
-- FROM GameOfThrones

DECLARE @print AS VARCHAR(MAX) = ''

SELECT @print +=
    'Säsong ' +
    CAST([Season] AS varchar) +
    ' sändes från ' +
    CAST(FORMAT(MIN([Original air date]), 'MMMM', 'sv') AS VARCHAR) +
    ' till ' +
    CAST(FORMAT(MAX([Original air date]), 'y', 'sv') AS VARCHAR) +
    '. Totalt sändes ' +
    CAST(COUNT(*) AS VARCHAR) +
    ' avsnitt, som i genomsnitt sågs av ' +
    CAST(FORMAT(AVG([U.S. viewers(millions)]), '0.0') AS VARCHAR) +
    ' miljoner människor i USA.' +
    CHAR(13) + CHAR(10) -- <-Gör en ny rad
FROM GameOfThrones
GROUP BY Season

PRINT @print

-- 4. Ta ut (select) alla användare i tabellen ”Users” så du får tre kolumner:
--    ”Namn” som har fulla namnet;
--    ”Ålder” som visar hur många år personen är idag (ex. ’45 år’);
--    ”Kön” som visar om det är en man eller kvinna.
--    Sortera raderna efter för- och efternamn.

-- SELECT *
-- FROM Users

SELECT CONCAT([FirstName], ' ', [LastName]) AS [Namn],
    DATEDIFF(YEAR, FORMAT(CAST(SUBSTRING(CONCAT('19', [ID]), 1, 8) AS INT), '####-##-##'), GETDATE()) AS [Ålder],
    CASE 
        WHEN CAST(SUBSTRING([ID], 10, 1) AS INT) % 2 = 0
        THEN 'Kvinna'
        ELSE 'Man'
    END AS [Kön]
FROM Users
ORDER BY [FirstName] ASC, [LastName] ASC

-- 5. Ta ut en lista över regioner i tabellen ”Countries” där det för varje region framgår 
--    regionens namn,
--    antal länder i regionen,
--    totalt antal invånare,
--    total area,
--    befolkningstätheten med 2 decimaler,
--    samt spädbarnsdödligheten per 100.000 födslar avrundat till heltal.

-- SELECT *
-- FROM Countries
-- WHERE Region LIKE 'BALTICS'

SELECT DISTINCT [Region] AS [Region namn],
    COUNT(*) AS [Antal länder],
    SUM(CONVERT(BIGINT, [Population])) AS [Totalt antal invånare],
    SUM([Area (sq# mi#)]) AS [Total area],
    FORMAT(SUM(CAST(REPLACE([Pop# Density (per sq# mi#)], ',', '.') AS FLOAT)), '0.00') AS [Befolkningstäthet],
    ROUND(SUM(CAST(REPLACE([Infant mortality (per 1000 births)], ',', '.') AS FLOAT) * 100), 0) AS [Spädbarnsdödligheten per 100.000]
FROM Countries
GROUP BY Region

-- 6. Från tabellen ”Airports”, gruppera per land och ta ut kolumner som visar:
--    land,
--    antal flygplatser (IATA-koder),
--    antal som saknar ICAO-kod,
--    samt hur många procent av flygplatserna i varje land som saknar ICAO-kod.

-- SELECT *
-- FROM Airports

-- Lösning med STRING_SPLIT
SELECT DISTINCT TRIM(VALUE) AS [Land],
    COUNT([IATA]) AS [Antal flygplatser],
    COUNT(CASE WHEN [ICAO] IS NULL THEN 1 END) AS [Saknar ICAO-kod],
    -- CAST(ROUND(COUNT(CASE WHEN [ICAO] IS NULL THEN 1 END) * 100 / COUNT(IATA), 0) AS VARCHAR) + '%' AS [Saknar ICAO-kod (%)],
    FORMAT(ROUND(COUNT(CASE WHEN [ICAO] IS NULL THEN 1 END) * 100.0 / COUNT(IATA), 2), '0.00') + '%' AS [Saknar ICAO-kod (%)]
FROM Airports
CROSS APPLY STRING_SPLIT([Location served], ',')
GROUP BY VALUE
ORDER BY [Antal flygplatser] DESC

-- Lösning med JOIN
-- SELECT 
--     Countries.Country,
--     COUNT(Airports.IATA) AS NumberOfAirports,
--     COUNT(CASE WHEN Airports.ICAO IS NULL THEN 1 END) AS MissingICAO,
--     ROUND(COUNT(CASE WHEN Airports.ICAO IS NULL THEN 1 END) * 100 / COUNT(Airports.IATA), 2) AS [NoICAOIn%]
-- FROM dbo.Airports
-- JOIN dbo.Countries ON Airports.[Location served] LIKE '%' + Countries.Country + '%'
-- GROUP BY Countries.Country
-- ORDER BY NumberOfAirports DESC, [NoICAOIn%] DESC
