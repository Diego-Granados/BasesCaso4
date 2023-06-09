-----------------------------------------------------------
-- Autor: Diego Granados
-- Fecha: 4/23/2023
-- Descripción: Este Stored procedure inserta una factura con base en los viajes que se mandan por TVP.
-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 5/23/2023
-- Descripción: Este Stored Procedure se adaptó para mostrar el problema del unrepeatable read arreglado.
-----------------------------------------------------------

DROP PROCEDURE IF EXISTS  [dbo].[SP_registrarFacturaRecoleccionURFix2];
GO
/*
DROP TYPE IF EXISTS viajesTabla;
GO

CREATE TYPE viajesTabla
	AS TABLE
		(viajeId INT);
GO
*/

-- Este stored procedure recibe los viajes de recolección que se van a pagar en un table valued parameter.
CREATE PROCEDURE [dbo].[SP_registrarFacturaRecoleccionURFix2]
	@viajes [dbo].[viajesTabla] READONLY
AS 
BEGIN
	
	SET NOCOUNT ON -- no retorne metadatos
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- declaracion de otras variables

	DECLARE @facturaId BIGINT
	-- operaciones de select que no tengan que ser bloqueadas
	CREATE TABLE #viajesSelect
	(
		productor INT,
		total MONEY, 
		recolector INT, 
		montoRecoleccion MONEY, 
		montoTratamiento MONEY, 
		comision MONEY, 
		viaje INT,
		localId INT,
		localesCount SMALLINT, 
		conversion MONEY
	)

	/*
		Puede ocurrir el problema del Unrepeatable Read en la tabla de saldosDistribucion. Al hacer el procesamiento grueso de la transacción antes del begin transaction,
		acortamos el tiempo y el procesamiento dentro de la transacción. Sin embargo, el cálculo del descuento por el saldo se hace con base en el monto que 
		haya en el momento donde se hace todo el procesamiento. Si dos transacciones realizan este procesamiento al mismo tiempo, o una inmediatamente después de la otra, 
		van a leer el mismo saldo disponible para ambas. Si este es el caso, cada una puede pensar que puede usar la totalidad del saldo para pagar su recolección.
		Luego al momento de actualizar el saldo, se resta el monto que leen dos veces, por lo que queda una cantidad negativa en el saldo.
		Esto es el problema del unrepeatable read porque la segunda transacción primero lee el valor original, pero cuando hace el update, lee el valor actual del saldo,
		el cual es diferente al valor original que leyó al inicio.
	*/

	-- T1: empieza primero
	-- Ya no se lee el valor de saldo 600 para el local 1. El costo de T1 es 1400 para ese local. Se calcula el total del costo del viaje y otros aspectos, 
	-- como la cantidad de viajes para ese local en esta factura. Todo se guarda en #viajesSelect	
	INSERT INTO #viajesSelect (productor,total, recolector, montoRecoleccion, montoTratamiento, comision, viaje, localId, localesCount, conversion) 
	(SELECT locales.productorId,
	((sumasDesechosViajes.cantidadDesechoRecogido * costosPasoRecoleccion.costoRec / cantidadEsperada) / tCC.conversion + sumasDesechosViajes.costosTratos / tCT.conversion + costosPasoRecoleccion.comisionEV / tCC.conversion),
	camiones.recolectorId,
	(sumasDesechosViajes.cantidadDesechoRecogido * costosPasoRecoleccion.costoRec / cantidadEsperada) / tCC.conversion,sumasDesechosViajes.costosTratos / tCT.conversion, 
	costosPasoRecoleccion.comisionEV / tCC.conversion, viajesRecoleccion.viajeId,
	vc.localId,
	vc.localesCount,
	tCS.conversion
	FROM @viajes v
	INNER JOIN viajesRecoleccion ON viajesRecoleccion.viajeId = v.viajeId   
	INNER JOIN (SELECT localId, COUNT(localId) localesCount FROM @viajes vs INNER JOIN viajesRecoleccion ON viajesRecoleccion.viajeId = vs.viajeId GROUP BY localId) vc ON viajesRecoleccion.localId = vc.localId
	INNER JOIN locales ON locales.localId = viajesRecoleccion.localId
	INNER JOIN camiones ON camiones.camionId = viajesRecoleccion.camionId
	INNER JOIN costosPasoRecoleccion ON viajesRecoleccion.recPasoId = costosPasoRecoleccion.recPasoId
	INNER JOIN saldosDistribucion ON viajesRecoleccion.localId = saldosDistribucion.localId
	INNER JOIN tiposDeCambio tCC ON costosPasoRecoleccion.monedaId = tCC.monedaCambioId
	INNER JOIN tiposDeCambio tCS ON saldosDistribucion.monedaId = tCS.monedaCambioId
	INNER JOIN direcciones ON locales.direccionId = direcciones.direccionId
	INNER JOIN ciudades ON direcciones.ciudadId = ciudades.ciudadId
	INNER JOIN estados ON estados.estadoId = ciudades.estadoId
	INNER JOIN paises ON estados.paisId = paises.paisId
	INNER JOIN 
	(SELECT SUM(desechosPlantasLogs.cantidad) AS cantidadDesechoRecogido, SUM(desechosPlantasLogs.costoTrato) AS costosTratos, costosTratamiento.monedaId AS monedaCosto, 
	v.viajeId as sumaViajeId FROM desechosPlantasLogs 
	INNER JOIN @viajes v ON v.viajeId = desechosPlantasLogs.viajeId INNER JOIN costosTratamiento ON 
	desechosPlantasLogs.costoTratoId = costosTratamiento.costoTratoId GROUP BY desechosPlantasLogs.viajeId, costosTratamiento.monedaId,  v.viajeId) AS sumasDesechosViajes 
	ON sumasDesechosViajes.sumaViajeId = viajesRecoleccion.viajeId
	INNER JOIN 
	(SELECT SUM(desechosPorPaso.maxEsperado) AS cantidadEsperada, desechosPorPaso.recPasoId as sumaPasoId FROM desechosPorPaso 
	GROUP BY desechosPorPaso.recPasoId) AS sumasDesechosPasos ON viajesRecoleccion.recPasoId = sumasDesechosPasos.sumaPasoId
	INNER JOIN tiposDeCambio tCT ON sumasDesechosViajes.monedaCosto = tCT.monedaCambioId
	WHERE costosPasoRecoleccion.areaEfectoId = (CASE 
		WHEN costosPasoRecoleccion.objectTypeId = 1 THEN locales.direccionId
		WHEN costosPasoRecoleccion.objectTypeId = 2 THEN direcciones.ciudadId
		WHEN costosPasoRecoleccion.objectTypeId = 3 THEN ciudades.estadoId
		WHEN costosPasoRecoleccion.objectTypeId = 4 THEN estados.paisId
		ELSE
		CASE 
			WHEN (SELECT direccionId FROM elementosPorRegion WHERE elementosPorRegion.regionId = costosPasoRecoleccion.areaEfectoId AND elementosPorRegion.direccionId = locales.direccionId) IS NOT NULL THEN costosPasoRecoleccion.areaEfectoId
			WHEN (SELECT ciudadId FROM elementosPorRegion WHERE elementosPorRegion.regionId = costosPasoRecoleccion.areaEfectoId AND elementosPorRegion.ciudadId = direcciones.ciudadId) IS NOT NULL THEN costosPasoRecoleccion.areaEfectoId
			WHEN (SELECT estadoId FROM elementosPorRegion WHERE elementosPorRegion.regionId = costosPasoRecoleccion.areaEfectoId AND elementosPorRegion.estadoId = ciudades.estadoId) IS NOT NULL THEN costosPasoRecoleccion.areaEfectoId
			WHEN (SELECT paisId FROM elementosPorRegion WHERE elementosPorRegion.regionId = costosPasoRecoleccion.areaEfectoId AND elementosPorRegion.paisId = estados.paisId) IS NOT NULL THEN costosPasoRecoleccion.areaEfectoId
			ELSE NULL
		END
	END))


	--T2 empieza después de T1.
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ -- El isolation level se pone en Repeatable read, el cual previene el problema del unrepeatable read.
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001
		IF (SELECT COUNT(*) FROM @viajes v) != (SELECT COUNT(viaje) FROM #viajesSelect) BEGIN
			RAISERROR ('VIAJES NO EXISTEN', 16, 1)
		END;

		-- Aquí T2 solicita un update lock sobre saldosDistribución, pero como T1 ya tiene uno,
		-- T2 debe esperar a que T1 termine. Por lo tanto, T2 siempre va a ver el valor actualizado
		-- por T1. Así se previene el problema del unrepeatable read.
		SELECT 'Primer read', saldoId, montoSaldo, GETDATE() FROM saldosDistribucion WITH (UPDLOCK);
		WITH descuentos(viajeId, descuento) AS (
			SELECT #viajesSelect.viaje, (CASE
				WHEN (#viajesSelect.total > (saldosDistribucion.montoSaldo / #viajesSelect.localesCount) / #viajesSelect.conversion)
				THEN (saldosDistribucion.montoSaldo / #viajesSelect.localesCount) / #viajesSelect.conversion
				ELSE (#viajesSelect.total)
			END ) FROM #viajesSelect INNER JOIN saldosDistribucion WITH (UPDLOCK) ON #viajesSelect.localId = saldosDistribucion.localId
		)
		INSERT INTO [dbo].[itemsRecoleccion] ([productorId], [montoTotal], [recolectorId], [montoRec], [montoTrato], 
		[montoComisionEV],[viajeId],[fechaFactura], [descuentoSaldo], [montoAPagar], [enabled], [createdAt], [computer],[username],[checksum])
		SELECT productor, total, recolector, montoRecoleccion, montoTratamiento, comision, viaje, '2023-04-24 00:00:00', descuento, total - descuento, 1, '2023-04-24 10:00:00', 'ComputerName', 'Username', 0x0123456789ABCDEF
		FROM #viajesSelect INNER JOIN descuentos ON #viajesSelect.viaje = descuentos.viajeId;
		
		-- Cuando ya T1 termina, T2 continúa.
		SELECT 'Segundo read', saldoId, montoSaldo, GETDATE() FROM saldosDistribucion WITH (UPDLOCK);
		
		-- Calcula el descuento total usado en los ítemes, porque este se había dividido
		-- en cada viaje para el local.
		-- Actualiza el saldo utilizado
		WITH sumSaldo (descuentoTotal, localId) AS (
			SELECT SUM(itemsRecoleccion.descuentoSaldo) descuentoTotal, #viajesSelect.localId localId FROM #viajesSelect
			INNER JOIN itemsRecoleccion ON itemsRecoleccion.viajeId = #viajesSelect.viaje
			GROUP BY #viajesSelect.localId
		)
		UPDATE saldosDistribucion
		SET montoSaldo = montoSaldo - sumSaldo.descuentoTotal
		FROM sumSaldo INNER JOIN saldosDistribucion ON saldosDistribucion.localId = sumSaldo.localId
		-- T2 escribe el montoSaldo. montoSaldo queda con el valor correcto.
		SELECT 'Tercer read', saldoId, montoSaldo, GETDATE() FROM saldosDistribucion WITH (UPDLOCK);


		INSERT INTO [dbo].[facturas] (enabled, [createdAt], computer, username, checksum, facturaStatusId, [descripcion], [fecha], fechaMax)
VALUES (1, '2023-04-25 12:00:00', 'PC01', 'JohnDoe', 0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF, 1, 'Factura de recoleccion ', '2023-04-25 12:00:00', NULL);

		SET @facturaId = SCOPE_IDENTITY();

		INSERT INTO [dbo].[itemsFactura] (facturaId, itemId, tipoItemId, enabled, [createdAt], updatedAt, computer, username, checksum)
		SELECT @facturaId, itemsRecoleccion.itemRecId, 1, 1, '2023-04-25 12:00:00', NULL, 'PC01', 'JohnDoe', 0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
		FROM itemsRecoleccion
		INNER JOIN @viajes v ON v.viajeId = itemsRecoleccion.viajeId
		
		-- T2 termina su ejecución
		IF @InicieTransaccion=1 BEGIN
			COMMIT
		END
	END TRY
	BEGIN CATCH
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState = ERROR_STATE()
		SET @Message = ERROR_MESSAGE()
		
		IF @InicieTransaccion=1 BEGIN
			ROLLBACK
		END
		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError)
	END CATCH	
	DROP TABLE #viajesSelect
END
RETURN 0
GO