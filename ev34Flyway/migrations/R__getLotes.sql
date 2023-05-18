-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 08/05/2023
-- Descripcion: Este Stored procedure obtiene los canales
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS  [dbo].[SP_getLotes];
GO

CREATE PROCEDURE [dbo].[SP_getLotes]
AS 
BEGIN
	SET NOCOUNT ON; -- no retorne metadatos

	WITH productosVendidos (loteId, cantidadVendida) AS 
	(	
		SELECT lpl.loteId, COALESCE(sum(cantidadProductos), 0) cantidadVendida FROM lotesProduccionLogs lpl LEFT JOIN itemsProductos on lpl.loteId = itemsProductos.loteID
		GROUP BY lpl.loteId
	)
	SELECT lpl.loteId, lpl.fecha, nombres.nombreBase productoNombre, lpl.prodContratoId, lpl.plantaId, lpl.cantidad - productosVendidos.cantidadVendida cantidad, 
	lpl.costoProduccion / costoMonedas.conversion AS costoProduccion,
	preciosProductosContrato.precio / precioMonedas.conversion  AS precio
	FROM lotesProduccionLogs lpl
	INNER JOIN productosVendidos ON productosVendidos.loteId = lpl.loteId
	INNER JOIN productos ON lpl.productoId = productos.productoId
	INNER JOIN preciosProductosContrato ON lpl.prodContratoId = preciosProductosContrato.prodContratoId AND lpl.productoId = preciosProductosContrato.productoId
	INNER JOIN tiposDeCambio costoMonedas ON lpl.monedaId = costoMonedas.monedaCambioId
	INNER JOIN tiposDeCambio precioMonedas ON preciosProductosContrato.monedaId = precioMonedas.monedaCambioId
	INNER JOIN nombres ON nombres.nombreId = productos.nombreId
	ORDER BY precio, lpl.fecha;

END
RETURN 0
GO

/*
SELECT lpl.loteId, COALESCE(sum(cantidadProductos), 0) FROM lotesProduccionLogs lpl LEFT JOIN itemsPRoductos on lpl.loteId = itemsProductos.loteID
GROUP BY itemsProductos.loteId, lpl.loteId
ORDER BY lpl.loteID

SELECT loteId, sum(cantidadProductos) FROM itemsProductos GROUP BY loteId
ORDER BY loteID

SELECT loteId, cantidad from lotesProduccionLogs

SELECT * FROM preciosProductosContrato ORDER BY prodContratoId, productoId

Go

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
           ,FLOOR(1 + RAND() * 5000)
           ,1
           ,DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00')
           ,1
           ,GETDATE()
		   ,'computer'
		   ,'user1'
		   ,1234)
GO

SELECT * FROM preciosProductosContrato WHERE prodContratoId = 268
*/