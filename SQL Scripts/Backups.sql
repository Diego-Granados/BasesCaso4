-- Backups

-- SELECT en el momento del full backup
SELECT * FROM lotesProduccionLogs

DECLARE @contador TINYINT, @max TINYINT;
SET @contador = 1
SET @max = 10
WHILE @contador <= @max
BEGIN

INSERT INTO [dbo].[lotesProduccionLogs]
           ([productoId]
           ,[plantaId]
           ,[cantidad]
           ,[prodContratoId]
           ,[costoProduccion]
           ,[monedaId]
           ,[fecha]
           ,[enabled]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum])
     VALUES
           ((SELECT TOP 1 productoId FROM productos ORDER BY NEWID())
           ,(SELECT TOP 1 plantaId FROM plantas ORDER BY NEWID())
           ,FLOOR(1 + RAND() * 10000)
           ,(SELECT TOP 1 prodContratoId FROM contratosProduccion ORDER BY NEWID())
           ,FLOOR(1 + RAND() * 10000)
           ,(SELECT TOP 1 monedaId FROM monedas ORDER BY NEWID())
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,1
           ,GETDATE()
		   ,'computer1'
		   ,'user1'
		   ,1234)
SET @contador = @contador + 1

END

-- SELECT para el backup incremental
SELECT * FROM lotesProduccionLogs