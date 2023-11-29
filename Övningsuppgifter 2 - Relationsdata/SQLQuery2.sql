--------------------------------------------
-- SELECT * INTO newTable FROM oldTable;
--------------------------------------------

USE everyloop;

-- Med tabellerna från schema “company”, svara på följande frågor:
--   1. Företagets totala produktkatalog består av 77 unika produkter. Om vi kollar bland våra ordrar, hur stor andel av dessa produkter har vi någon gång leverarat till London?
-- SELECT COUNT(DISTINCT(company.order_details.ProductId))
-- AS [Unika ordrar]
-- FROM company.orders
-- JOIN company.order_details ON company.orders.Id = company.order_details.OrderId
-- WHERE company.orders.ShipCity = 'London';

SELECT COUNT(DISTINCT company.order_details.ProductId) * 100.0 / (
    SELECT COUNT(DISTINCT company.order_details.ProductId)
    FROM company.orders
    JOIN company.order_details ON company.orders.Id = company.order_details.OrderId
) AS Percentage
FROM company.orders
JOIN company.order_details ON company.orders.Id = company.order_details.OrderId
WHERE ShipCity LIKE 'London'

--   2. Till vilken stad har vi levererat flest unika produkter?
SELECT company.orders.ShipCity, COUNT(DISTINCT company.order_details.ProductId) AS [UnikProdukt]
FROM company.orders
JOIN company.order_details ON company.orders.Id = company.order_details.OrderId
GROUP BY ShipCity
ORDER BY [UnikProdukt] DESC

--   3. Av de produkter som inte längre finns I vårat sortiment, hur mycket har vi sålt för totalt till Tyskland?
-- SELECT SUM(company.products.UnitPrice)
-- FROM company.orders
-- JOIN company.order_details ON company.orders.Id = company.order_details.OrderId
-- JOIN company.products ON company.products.Id = company.order_details.ProductId
-- WHERE company.products.Discontinued = 1 AND company.orders.ShipCity = 'Germany'

SELECT SUM(company.products.Unitprice)
FROM company.orders
JOIN company.order_details ON company.orders.Id = company.order_details.OrderId
JOIN company.products ON company.products.Id = company.order_details.ProductId
WHERE Discontinued = 1 AND ShipCountry LIKE 'Germany'

-- SELECT company.products.ProductName, SUM(company.products.unitprice)
-- FROM company.orders
-- JOIN company.order_details ON company.orders.Id = company.order_details.OrderId
-- JOIN company.products ON company.order_details.ProductId = company.products.Id
-- WHERE Discontinued = 1 AND ShipCountry LIKE 'Germany'
-- GROUP BY company.products.ProductName

--   4. För vilken produktkategori har vi högst lagervärde?
SELECT SUM(company.products.UnitPrice * company.products.UnitsInStock) AS Value, company.categories.CategoryName
FROM company.products
JOIN company.categories ON company.categories.Id = company.products.CategoryId
GROUP BY company.categories.CategoryName
ORDER BY Value DESC

-- SELECT DISTINCT company.categories.CategoryName, SUM(company.products.UnitPrice * products.unitsInstock) AS [Value]
-- FROM company.products
-- JOIN company.categories ON company.products.CategoryId = company.categories.Id
-- GROUP BY company.categories.CategoryName
-- ORDER BY Value DESC

--   5. Från vilken leverantör har vi sålt flest produkter totalt under sommaren 2013?
SELECT DISTINCT TOP 1 company.suppliers.CompanyName, SUM(company.order_details.Quantity) AS Quantity
FROM company.orders
JOIN company.order_details ON company.orders.Id = company.order_details.OrderId
JOIN company.products ON company.order_details.ProductId = company.products.Id
JOIN company.suppliers ON company.products.SupplierId = company.suppliers.Id
WHERE company.orders.OrderDate > '2013-06-01' AND company.orders.OrderDate < '2013-08-31'
GROUP BY company.suppliers.CompanyName, company.products.ProductName
ORDER BY Quantity DESC

-- SELECT DISTINCT company.suppliers.CompanyName, SUM(company.order_details.Quantity) AS OrderQuantity
-- FROM company.orders
-- JOIN company.order_details ON company.orders.Id = company.order_details.OrderId
-- JOIN company.products ON company.order_details.ProductId = company.products.Id
-- JOIN company.suppliers ON company.products.SupplierId = company.suppliers.Id
-- WHERE company.orders.OrderDate > '2013-06-01' AND company.orders.OrderDate < '2013-08-31'
-- GROUP BY company.suppliers.CompanyName
-- ORDER BY OrderQuantity DESC

-------------------------------------------------------------------------------------------------
-- Använd dig av tabellerna från schema “music”, och utgå från:
--   declare @playlist varchar(max) = 'Heavy Metal Classic’;
-- Skriv sedan en select-sats som tar ut alla låtar från den lista som angivits i @playlist efter följande exempel:
--   Genre 	        Artist 	        Album 	        Track 	    Length  Size 	    Composer
--   Heavy Metal 	Iron Maiden 	Killers 	    Killers 	05:00 	6.9 MiB 	Steve Harris
--   Heavy Metal 	Iron Maiden 	Killers 	    Wrathchild  02:54 	4.0 MiB 	Steve Harris
--   Metal          Black Sabbath 	Black Sabbath 	N.I.B 	    06:08 	11.5 MiB 	-
-- ... Resten av låtarna
-- DECLARE @playlist VARCHAR(max) = 'Heavy Metal Classic';

-- SELECT *
-- FROM music.playlists
-- JOIN music.playlist_track ON music.playlist_track.PlaylistId = music.playlists.PlaylistId
-- JOIN music.tracks ON music.playlist_track.TrackId = music.tracks.TrackId
-- JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
-- JOIN music.genres ON music.tracks.GenreId = music.genres.GenreId
-- WHERE music.playlists.Name LIKE @playlist

DECLARE @playlist VARCHAR(max) = 'Heavy Metal Classic';

SELECT music.genres.Name AS Genre,
        music.artists.Name AS Artist,
        music.albums.Title AS Album,
        music.tracks.Name AS Track,
        FORMAT(music.tracks.Milliseconds / (1000 * 60) % 60, '00') +
        FORMAT(music.tracks.Milliseconds / (1000) % 60, ':00') AS Length,
        FORMAT(music.tracks.Bytes / 1048576.0, '0.0 MiB') AS Size,
        music.tracks.Composer
FROM music.playlists
JOIN music.playlist_track ON music.playlists.PlaylistId = music.playlist_track.PlaylistId
JOIN music.tracks ON music.playlist_track.TrackId = music.tracks.TrackId
JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
JOIN music.artists ON music.artists.ArtistId = music.albums.ArtistId
JOIN music.genres ON music.tracks.GenreId = music.genres.GenreId
WHERE playlists.Name LIKE @playlist

-- INSERT INTO music.playlist_tabell(
--     Genre,
--     Artist,
--     Album,
--     Track,
--     Length,
--     Size,
--     Composer
-- )
-- VALUES(
--     music.genres.Name,
--     music.artists.Name,
--     music.albums.Title,
--     music.tracks.Name,
--     FORMAT(music.tracks.Milliseconds / (1000 * 60) % 60, '00') +
--     FORMAT(music.tracks.Milliseconds / (1000) % 60, ':00'),
--     FORMAT(music.tracks.Bytes / 1048576.0, '0.0 MiB'),
--     music.tracks.Composer
-- )
-- FROM music.playlists
-- JOIN music.playlist_track ON music.playlists.PlaylistId = music.playlist_track.PlaylistId
-- JOIN music.tracks ON music.playlist_track.TrackId = music.tracks.TrackId
-- JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
-- JOIN music.artists ON music.artists.ArtistId = music.albums.ArtistId
-- JOIN music.genres ON music.tracks.GenreId = music.genres.GenreId
-- WHERE playlists.Name LIKE @playlist

-- Med tabellerna från schema “music”, svara på följande frågor:
--      1. Av alla audiospår, vilken artist har längst total speltid?
SELECT TOP 1 music.artists.Name, SUM(music.tracks.milliseconds) AS Time
FROM music.playlists
JOIN music.playlist_track ON music.playlists.PlaylistId = music.playlist_track.PlaylistId
JOIN music.tracks ON music.playlist_track.TrackId = music.tracks.TrackId
JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
JOIN music.artists ON music.artists.ArtistId = music.albums.ArtistId
JOIN music.genres ON music.tracks.GenreId = music.genres.GenreId
GROUP BY music.artists.Name
ORDER BY Time DESC

--      2. Vad är den genomsnittliga speltiden på den artistens låtar?
-- SELECT TOP 1 music.artists.Name,
--     FORMAT(AVG(music.tracks.milliseconds) / (1000 * 60) % 60, '00') +
--     FORMAT(AVG(music.tracks.milliseconds) / 1000 % 60, ':00') AS Time,
--     AVG(music.tracks.Milliseconds) AS Milliseconds
-- FROM music.playlists
-- JOIN music.playlist_track ON music.playlists.PlaylistId = music.playlist_track.PlaylistId
-- JOIN music.tracks ON music.playlist_track.TrackId = music.tracks.TrackId
-- JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
-- JOIN music.artists ON music.artists.ArtistId = music.albums.ArtistId
-- JOIN music.genres ON music.tracks.GenreId = music.genres.GenreId
-- WHERE music.artists.Name = 'Lost'
-- GROUP BY music.artists.Name
-- ORDER BY Time DESC

SELECT TOP 1 music.artists.Name,
    SUM(music.tracks.milliseconds) AS [Time],
    FORMAT(AVG(music.tracks.Milliseconds) / (1000 * 60) % 60, '00') +
    FORMAT(AVG(music.tracks.Milliseconds) / 1000 % 60, ':00') AS Length
FROM music.playlists
JOIN music.playlist_track ON music.playlists.PlaylistId = music.playlist_track.PlaylistId
JOIN music.tracks ON music.playlist_track.TrackId = music.tracks.TrackId
JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
JOIN music.artists ON music.artists.ArtistId = music.albums.ArtistId
JOIN music.genres ON music.tracks.GenreId = music.genres.GenreId
JOIN music.media_types ON music.tracks.MediaTypeId = music.media_types.MediaTypeId
WHERE NOT music.media_types.MediaTypeId = 3
GROUP BY music.artists.Name
ORDER BY [Time] DESC

--      3. Vad är den sammanlagda filstorleken för all video?
-- SELECT FORMAT(SUM(music.tracks.Bytes / 1073741824.0), '0.0 GiB') AS Size, COUNT(*) AS Files
-- FROM music.tracks
-- JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
-- JOIN music.artists ON music.artists.ArtistId = music.albums.ArtistId
-- JOIN music.genres ON music.tracks.GenreId = music.genres.GenreId
-- JOIN music.media_types ON music.tracks.MediaTypeId = music.media_types.MediaTypeId
-- WHERE music.media_types.MediaTypeId = 3

SELECT FORMAT(SUM(music.tracks.Bytes / 1073741824.0), '0.0 GiB') AS Size, COUNT(*) AS Files
FROM music.tracks
WHERE music.tracks.MediaTypeId = 3

--      4. Vilket är det högsta antal artister som finns på en enskild spellista?
SELECT music.playlists.PlaylistId, music.playlists.Name, COUNT(DISTINCT(music.artists.ArtistId)) AS Artists
FROM music.playlists
JOIN music.playlist_track ON music.playlists.PlaylistId = music.playlist_track.PlaylistId
JOIN music.tracks ON music.playlist_track.TrackId = music.tracks.TrackId
JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
JOIN music.artists ON music.artists.ArtistId = music.albums.ArtistId
JOIN music.genres ON music.tracks.GenreId = music.genres.GenreId
GROUP BY music.playlists.PlaylistId, music.playlists.Name
ORDER BY Artists DESC

SELECT * FROM music.playlists

--      5. Vilket är det genomsnittliga antalet artister per spellista?
SELECT music.playlists.PlaylistId, music.playlists.Name,
        SUM(COUNT(DISTINCT(music.artists.Name))) / 14 AS Average
FROM music.playlists
JOIN music.playlist_track ON music.playlists.PlaylistId = music.playlist_track.PlaylistId
JOIN music.tracks ON music.playlist_track.TrackId = music.tracks.TrackId
JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
JOIN music.artists ON music.artists.ArtistId = music.albums.ArtistId
JOIN music.genres ON music.tracks.GenreId = music.genres.GenreId
GROUP BY music.playlists.PlaylistId, music.playlists.Name
ORDER BY Average DESC
----------------------
SELECT music.playlists.PlaylistId, music.playlists.Name,
        COUNT(DISTINCT(music.artists.Name)) AS Average
FROM music.playlists
JOIN music.playlist_track ON music.playlists.PlaylistId = music.playlist_track.PlaylistId
JOIN music.tracks ON music.playlist_track.TrackId = music.tracks.TrackId
JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
JOIN music.artists ON music.artists.ArtistId = music.albums.ArtistId
JOIN music.genres ON music.tracks.GenreId = music.genres.GenreId
GROUP BY music.playlists.PlaylistId, music.playlists.Name
ORDER BY Average DESC

select avg(visit_count) from (
  select count(user_id) as visit_count
  from table
   group by user_id) a