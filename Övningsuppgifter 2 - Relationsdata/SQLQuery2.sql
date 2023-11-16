--------------------------------------------
-- SELECT * INTO newTable FROM oldTable;
--------------------------------------------

USE everyloop;

-- Med tabellerna från schema “company”, svara på följande frågor:
--   1. Företagets totala produktkatalog består av 77 unika produkter. Om vi kollar bland våra ordrar, hur stor andel av dessa produkter har vi någon gång leverarat till London?
--   2. Till vilken stad har vi levererat flest unika produkter?
--   3. Av de produkter som inte längre finns I vårat sortiment, hur mycket har vi sålt för totalt till Tyskland?
--   4. För vilken produktkategori har vi högst lagervärde?
--   5. Från vilken leverantör har vi sålt flest produkter totalt under sommaren 2013?


-- Använd dig av tabellerna från schema “music”, och utgå från:
--   declare @playlist varchar(max) = 'Heavy Metal Classic’;
-- Skriv sedan en select-sats som tar ut alla låtar från den lista som angivits i @playlist efter följande exempel:
--   Genre 	     Artist 	     Album 	     Track 	     Length    Size 	Composer
--   Heavy Metal 	Iron Maiden 	Killers 	     Killers 	     05:00 	6.9 MiB 	Steve Harris
--   Heavy Metal 	Iron Maiden 	Killers 	     Wrathchild 	02:54 	4.0 MiB 	Steve Harris
--   Metal          Black Sabbath 	Black Sabbath 	N.I.B 	     06:08 	11.5 MiB 	-
-- ... Resten av låtarna


-- Med tabellerna från schema “music”, svara på följande frågor:
--      1. Av alla audiospår, vilken artist har längst total speltid?
--      2. Vad är den genomsnittliga speltiden på den artistens låtar?
--      3. Vad är den sammanlagda filstorleken för all video?
--      4. Vilket är det högsta antal artister som finns på en enskild spellista?5. Vilket är det genomsnittliga antalet artister per spellista?
