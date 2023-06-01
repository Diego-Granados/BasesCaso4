-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 04/22/2023
-- Descripcion: En este script se genera un llenado aleatorio para la base de datos para el query que usa al menos 4 joins
-----------------------------------------------------------

IF OBJECT_ID(N'tempdb..#objectTypeQuantities') IS NOT NULL
BEGIN
DROP TABLE #objectTypeQuantities
END
GO

CREATE TABLE #objectTypeQuantities (
	objectTypeId TINYINT IDENTITY(1,1) NOT NULL,
	cantidad INT NULL
);

INSERT INTO #objectTypeQuantities (cantidad) VALUES
((SELECT COUNT(direccionId) FROM direcciones)),
((SELECT COUNT(ciudadId) FROM ciudades)),
((SELECT COUNT(estadoId) FROM estados)),
((SELECT COUNT(paisId) FROM paises)),
((SELECT COUNT(regionId) FROM regiones)),
((SELECT COUNT(localId) FROM locales)),
((SELECT COUNT(productorId) FROM productores)),
((SELECT COUNT(recolectorId) FROM recolectores)),
((SELECT COUNT(participanteId) FROM participantes)),
((SELECT COUNT(recipienteId) FROM recipientes)),
((SELECT COUNT(productoId) FROM productos)),
((SELECT COUNT(loteId) FROM lotesProduccionLogs))


DECLARE @computer VARCHAR(20), @username VARCHAR(20), @checksum VARBINARY(150);

DECLARE @contador int;

DECLARE @productosContador INT, @productosMax INT, @objectTypeId TINYINT;
DECLARE @minObjects TINYINT, @maxObjects TINYINT, @geographicObjects TINYINT;
DECLARE @max INT;

SET @minObjects = 7
SET @maxObjects = 10
SET @geographicObjects = 5
SET @computer = 'computer1'
SET @username = 'user1'
SET @checksum = 1234

SET @contador = 1

SET @productosMax = (SELECT COUNT(*) from productos)

WHILE @contador <= 1000
BEGIN
INSERT INTO [dbo].[contratosProduccion]
           ([fechaInicio]
           ,[fechaFin]
           ,[enabled]
           ,[periodicidad]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum]
           ,[contEstadoId])
     VALUES
           (DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,1
           ,FLOOR(1 + RAND()*8) * 7
           ,GETDATE()
           ,@computer
           ,@username
           ,@checksum
           ,(SELECT TOP 1 contEstadoId FROM estadosContratos ORDER BY NEWID()))
SET @objectTypeId = FLOOR(1 + RAND()*@geographicObjects)
SET @productosContador = 1
WHILE @productosContador <= @productosMax
BEGIN
INSERT INTO [dbo].[preciosProductosContrato]
           ([prodContratoId]
           ,[productoId]
           ,[precio]
           ,[areaEfectoId]
           ,[objectTypeId]
           ,[fechaInicio]
           ,[fechaFin]
           ,[monedaId]
           ,[enabled]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum])
     VALUES
           (@contador
           ,@productosContador
           ,10 + 5 * FLOOR(RAND() * 12)
           ,FLOOR(1 + RAND() * (SELECT cantidad FROM #objectTypeQuantities WHERE objectTypeId = @objectTypeId))
           ,@objectTypeId
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,1
           ,1
           ,GETDATE()
		   ,@computer
		   ,@username
		   ,@checksum)

SET @productosContador = @productosContador + 1
END


SET @contador = @contador + 1
END

SET @contador = 0
SET @max = 10

WHILE @contador < @max
BEGIN
	SET @objectTypeId = FLOOR(1 + RAND()*@geographicObjects)

	INSERT INTO [dbo].[contratosRecoleccion]
			   ([productorId]
			   ,[enabled]
			   ,[recStartDate]
			   ,[recEndDate]
			   ,[contEstadoId]
			   ,[areaEfectoId]
			   ,[objectTypeId]
			   ,[createdAt]
			   ,[computer]
			   ,[username]
			   ,[checksum]
			   )
		 VALUES
			   ((SELECT TOP 1 productorId FROM productores ORDER BY NEWID())
			   ,1
			   ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
			   ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
			   ,(SELECT TOP 1 contEstadoId FROM estadosContratos ORDER BY NEWID())
			   ,FLOOR(1 + RAND() * (SELECT cantidad FROM #objectTypeQuantities WHERE objectTypeId = @objectTypeId))
			   ,@objectTypeId
			   ,getDate()
			   ,@computer
			   ,@username
			   ,@checksum
			   )
	SET @contador = @contador + 1
END


SET @contador = 0

WHILE @contador < 1000
BEGIN
INSERT INTO [dbo].[recoleccionesPorProduccion]
           ([prodContratoId]
           ,[recContratoId]
           ,[enabled]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum])
     VALUES
           ((SELECT TOP 1 prodContratoId from contratosProduccion ORDER BY NEWID())
           ,(SELECT TOP 1 recContratoId from contratosRecoleccion ORDER BY NEWID())
           ,1
           ,GETDATE()
		   ,@computer
		   ,@username
		   ,@checksum)
SET @contador = @contador + 1
END

SET @contador = 0

WHILE @contador < 1000
BEGIN
INSERT INTO [dbo].[horariosRecoleccion]
           ([recContratoId]
           ,[recPeriodicidad]
           ,[recStartDate]
           ,[recEndDate]
           ,[contEstadoId]
           ,[enabled]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum])
     VALUES
           ((SELECT TOP 1 recContratoId from contratosRecoleccion ORDER BY NEWID())
           ,FLOOR(1 + RAND()*8) * 7
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,(SELECT TOP 1 contEstadoId FROM estadosContratos ORDER BY NEWID())
           ,1
           ,GETDATE()
		   ,@computer
		   ,@username
		   ,@checksum)
SET @contador = @contador + 1
END

SET @contador = 0

WHILE @contador < 1000
BEGIN
INSERT INTO [dbo].[pasosRecoleccion]
           ([plantaIdOrigen]
           ,[dia]
           ,[horaRecogerEV]
           ,[horaEntregarEV]
           ,[recHorarioId]
           ,[hora]
           ,[plantaIdDestino]
           ,[enabled]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum])
     VALUES
           ((SELECT TOP 1 plantaId FROM plantas ORDER BY NEWID())
           ,FLOOR(1 + RAND() * 56)
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,(SELECT TOP 1 recHorarioId from horariosRecoleccion ORDER BY NEWID())
           ,DATEADD(second, FLOOR(1 + RAND()*86400), '00:00:00')
           ,(SELECT TOP 1 plantaId FROM plantas ORDER BY NEWID())
           ,1
           ,GETDATE()
		   ,@computer
		   ,@username
		   ,@checksum)
SET @contador = @contador + 1
END

SET @contador = 0

WHILE @contador < 1000
BEGIN
INSERT INTO [dbo].[viajesRecoleccion]
           ([recPasoId]
           ,[localId]
           ,[camionId]
           ,[plantaOrigenId]
           ,[plantaDestinoId]
           ,[fechaInicio]
           ,[choferId]
           ,[enabled]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum])
     VALUES
           ((SELECT TOP 1 recPasoId FROM pasosRecoleccion ORDER BY NEWID())
           ,(SELECT TOP 1 localId FROM locales ORDER BY NEWID())
           ,(SELECT TOP 1 camionId FROM camiones ORDER BY NEWID())
           ,(SELECT TOP 1 plantaId FROM plantas ORDER BY NEWID())
           ,(SELECT TOP 1 plantaId FROM plantas ORDER BY NEWID())
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,(SELECT TOP 1 contactoId FROM contactos ORDER BY NEWID())
           ,1
           ,GETDATE()
		   ,@computer
		   ,@username
		   ,@checksum)
SET @contador = @contador + 1
END

SET @contador = 0

WHILE @contador < 1000
BEGIN
INSERT INTO [dbo].[desechosPlantasLogs]
           ([plantaId]
           ,[desechoId]
           ,[cantidad]
           ,[fecha]
           ,[viajeId]
           ,[costoTrato]
           ,[enabled]
           ,[costoTratoId]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum])
     VALUES
           ((SELECT TOP 1 plantaId FROM plantas ORDER BY NEWID())
           ,(SELECT TOP 1 desechoId FROM desechos ORDER BY NEWID())
           ,FLOOR(1 + RAND()*100000)
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,(SELECT TOP 1 viajeId from viajesRecoleccion ORDER BY NEWID())
           ,FLOOR(1 + RAND()*10000)
           ,1
           ,(SELECT TOP 1 costoTratoId FROM costosTratamiento ORDER BY NEWID())
           ,getDate()
		   ,@computer
		   ,@username
		   ,@checksum)
SET @contador = @contador + 1
END

-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 04/23/2023
-- Descripcion: En este script se genera un llenado aleatorio para la base de datos para el query que se va a optimizar
-----------------------------------------------------------


SET @contador = 1
SET @max = 1000

-- llenar actoresContratoProd
WHILE @contador <= @max
BEGIN
SET @objectTypeId = FLOOR(@minObjects + RAND()*(@maxObjects - @minObjects))
INSERT INTO [dbo].[actoresContratoProd]
           ([prodContratoId]
           ,[objectTypeId]
           ,[genericId]
           ,[enabled]
           ,[createdAt]
           ,[computer]
		   ,[username]
           ,[checksum])
     VALUES
           ((SELECT TOP 1 prodContratoId FROM contratosProduccion ORDER BY NEWID())
           ,@objectTypeId
           ,FLOOR(1 + RAND() * (SELECT cantidad FROM #objectTypeQuantities WHERE objectTypeId = @objectTypeId))
           ,1
           ,GETDATE()
           ,@computer
           ,@username
           ,@checksum)

INSERT INTO [dbo].[porcentajesActores]
           ([actorId]
           ,[porcentaje]
           ,[productoId]
           ,[monedaId]
           ,[fechaInicio]
           ,[fechaFin]
           ,[enabled]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum])
     VALUES
           (@contador
           ,100*RAND()
           ,(SELECT TOP 1 productoId from productos ORDER BY NEWID())
           ,(SELECT TOP 1 monedaId from monedas ORDER BY NEWID())
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,1
           ,GETDATE()
           ,@computer
           ,@username
           ,@checksum)
SET @contador = @contador + 1
END

-- SELECT * FROM actoresContratoProd ORDER BY actorId
-- SELECT * FROM porcentajesActores
-- SELECT * FROM actoresContratoProd ORDER BY actorId


SET @contador = 1
SET @max = 2000
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
		   ,@computer
		   ,@username
		   ,@checksum)
SET @contador = @contador + 1

END

SET @contador = 1
SET @max = 10000
WHILE @contador <= @max
BEGIN

INSERT INTO [dbo].[itemsProductos]
           ([canalId]
           ,[loteId]
           ,[cantidadProductos]
           ,[montoTotal]
           ,[monedaId]
           ,[fecha]
           ,[precioProductoId]
           ,[enabled]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum])
     VALUES
           ((SELECT TOP 1 canalId FROM canales ORDER BY NEWID())
           ,(SELECT TOP 1 loteId FROM lotesProduccionLogs ORDER BY NEWID())
           ,FLOOR(1 + rand()*10000)
           ,FLOOR(1 + rand()*1000)
           ,(SELECT TOP 1 monedaId FROM monedas ORDER BY NEWID())
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,(SELECT TOP 1 precioProductoId FROM preciosProductosContrato ORDER BY NEWID())
           ,1
           ,GETDATE()
		   ,@computer
		   ,@username
		   ,@checksum)

SET @contador = @contador + 1

END
GO

DECLARE @computer VARCHAR(20), @username VARCHAR(20), @checksum VARBINARY(150);
DECLARE @max INT
DECLARE @contador int;

SET @computer = 'computer1'
SET @username = 'user1'
SET @checksum = 1234

DECLARE @itemsFactura int, @contItems int, @maxItems int;
SET @contador = 1
SET @max = 1000
SET @maxItems = (SELECT COUNT(itemProdId) FROM itemsProductos)

SET @itemsFactura = FLOOR(@maxItems/@max)

WHILE @contador <= @max
BEGIN
SET @contItems = 1

INSERT INTO [dbo].[facturas]
           ([enabled]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum]
           ,[facturaStatusId]
           ,[descripcion]
		   ,[fecha])
     VALUES
           (1
           ,GETDATE()
		   ,@computer
		   ,@username
		   ,@checksum
           ,(SELECT TOP 1 facturaStatusId FROM facturaStatuses ORDER BY NEWID())
           ,'Venta de productos'
		   ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00'))

WHILE @contItems <= @itemsFactura AND (@contador - 1) * @itemsFactura + @contItems <= @maxItems
BEGIN

INSERT INTO [dbo].[itemsFactura]
           ([facturaId]
           ,[itemId]
           ,[tipoItemId]
           ,[enabled]
           ,[createdAt]
           ,[computer]
           ,[username]
           ,[checksum])
     VALUES
           (@contador
           ,(@contador - 1) * @itemsFactura + @contItems
           ,3
           ,1
           ,GETDATE()
		   ,@computer
		   ,@username
		   ,@checksum)
	SET @contItems = @contItems + 1
END
SET @contador = @contador + 1
END


GO

UPDATE lotesProduccionLogs
SET cantidad = cantidad + productosVendidos.cantidadVendida
FROM (SELECT lpl.loteId, COALESCE(sum(cantidadProductos), 0) cantidadVendida FROM lotesProduccionLogs lpl
LEFT JOIN itemsProductos on lpl.loteId = itemsProductos.loteID	GROUP BY lpl.loteId) productosVendidos
INNER JOIN lotesProduccionLogs ON productosVendidos.loteId = lotesProduccionLogs.loteId

SELECT lpl.loteId, COALESCE(sum(cantidadProductos), 0) cantidadVendida FROM lotesProduccionLogs lpl
LEFT JOIN itemsProductos on lpl.loteId = itemsProductos.loteID	GROUP BY lpl.loteId ORDER BY lpl.loteId
-- SELECT * FROM lotesProduccionLogs WHERE cantidad = 0
-- SELECT * FROM facturas

-- SELECT * FROM itemsFactura
