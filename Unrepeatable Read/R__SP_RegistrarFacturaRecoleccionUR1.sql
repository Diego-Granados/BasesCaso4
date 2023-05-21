-----------------------------------------------------------
-- Autor: Diego Granados
-- Fecha: 4/23/2023
-- Descripción: Este Stored procedure inserta una factura con base en los viajes que se mandan por TVP.
-----------------------------------------------------------

DROP PROCEDURE IF EXISTS  [dbo].[SP_registrarFacturaRecoleccionUR1];
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
CREATE PROCEDURE [dbo].[SP_registrarFacturaRecoleccionUR1]
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
		descuento MONEY, 
		montoAPagar MONEY
	)

	
		/* La tabla de saldosDistribucion puede causar que haya un lost update y un dirty read. Puede ocurrir un lost update cuando se intenta 
		registrar la factura de dos viajes diferentes, en diferentes transacciones, que van al mismo local. Puede ser que la T1 actualice 
		el saldo de ese local con base en el descuento de ese viaje, y que T2 haga lo mismo con base en su viaje. Como el montoSaldo en T2 no se 
		ha actualizado, el monto que quedó luego de T1 no va aparecer, entonces se pierde el update de T1. Por otro lado, es posible que también se
		cree una inconsistencia en los datos e incluso el saldo dé negativo. En este stored procedure se lee el monto que se puede obtener del descuento antes,
		en el SELECT de la línea 48. Esto puede causar que dos transacciones lean el mismo valor de saldo disponible en ese momento, por lo que cada una
		va a sacar el descuento con base en ese monto. No obstante, cuando se actualice aquí, las dos transacciones van a restarle al saldo sus descuentos, 
		y dependiendo de la cantidad del saldo, es posible que no alcance para los dos. Por ejemplo, T1 y T2 registran viajes para el local 1, por lo que
		usan el mismo saldo. Supongamos que el saldo es de 1500. Si el viaje de T1 cuesta 700 y el de T2 1000, entonces con base en el monto que leyeron, sí
		pueden tener ese descuento. A la hora de actualizar el saldo, se terminaría realizando 1500 - 700 - 1000 = -200, por lo que el saldo quedaría negativo
		y se crearía una inconsistencia. */


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
	-- se lee el valor de saldo 600. El costo de T1 es 725. Puede gastar todo el saldo, entonces lo agarra todo
	INSERT INTO #viajesSelect (productor,total, recolector, montoRecoleccion, montoTratamiento, comision, viaje, descuento, montoAPagar) 
	(SELECT locales.productorId, ((sumasDesechosViajes.cantidadDesechoRecogido * costosPasoRecoleccion.costoRec / cantidadEsperada) / tCC.conversion + sumasDesechosViajes.costosTratos / tCT.conversion + costosPasoRecoleccion.comisionEV / tCC.conversion), camiones.recolectorId, (sumasDesechosViajes.cantidadDesechoRecogido * costosPasoRecoleccion.costoRec / cantidadEsperada) / tCC.conversion,sumasDesechosViajes.costosTratos / tCT.conversion, 
	costosPasoRecoleccion.comisionEV / tCC.conversion, viajesRecoleccion.viajeId, 
	(CASE 
		WHEN ((sumasDesechosViajes.cantidadDesechoRecogido * costosPasoRecoleccion.costoRec / cantidadEsperada) / tCC.conversion + sumasDesechosViajes.costosTratos / tCT.conversion + costosPasoRecoleccion.comisionEV / tCC.conversion) > (saldosDistribucion.montoSaldo / vc.localesCount) / tcs.conversion THEN (saldosDistribucion.montoSaldo / vc.localesCount) / tCS.conversion
		ELSE ((sumasDesechosViajes.cantidadDesechoRecogido * costosPasoRecoleccion.costoRec / cantidadEsperada) / tCC.conversion + sumasDesechosViajes.costosTratos / tCT.conversion + costosPasoRecoleccion.comisionEV / tCC.conversion)
	END ),((sumasDesechosViajes.cantidadDesechoRecogido * costosPasoRecoleccion.costoRec / cantidadEsperada) / tCC.conversion + sumasDesechosViajes.costosTratos / tCT.conversion + costosPasoRecoleccion.comisionEV / tCC.conversion) - (CASE 
		WHEN ((sumasDesechosViajes.cantidadDesechoRecogido * costosPasoRecoleccion.costoRec / cantidadEsperada) / tCC.conversion + sumasDesechosViajes.costosTratos / tCT.conversion + costosPasoRecoleccion.comisionEV / tCC.conversion) > (saldosDistribucion.montoSaldo / vc.localesCount) / tcs.conversion THEN (saldosDistribucion.montoSaldo / vc.localesCount) / tCS.conversion
		ELSE ((sumasDesechosViajes.cantidadDesechoRecogido * costosPasoRecoleccion.costoRec / cantidadEsperada) / tCC.conversion + sumasDesechosViajes.costosTratos / tCT.conversion + costosPasoRecoleccion.comisionEV / tCC.conversion)
	END )
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
	viajesRecoleccion.viajeId as sumaViajeId FROM desechosPlantasLogs 
	INNER JOIN viajesRecoleccion ON viajesRecoleccion.viajeId = desechosPlantasLogs.viajeId INNER JOIN costosTratamiento ON 
	desechosPlantasLogs.costoTratoId = costosTratamiento.costoTratoId GROUP BY desechosPlantasLogs.viajeId, costosTratamiento.monedaId,  viajesRecoleccion.viajeId) AS sumasDesechosViajes 
	ON sumasDesechosViajes.sumaViajeId = viajesRecoleccion.viajeId
	INNER JOIN 
	(SELECT SUM(desechosPorPaso.maxEsperado) AS cantidadEsperada, desechosPorPaso.recPasoId as sumaPasoId FROM desechosPorPaso 
	INNER JOIN viajesRecoleccion ON viajesRecoleccion.recPasoId = desechosPorPaso.recPasoId GROUP BY desechosPorPaso.recPasoId) AS sumasDesechosPasos ON viajesRecoleccion.recPasoId = sumasDesechosPasos.sumaPasoId
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

	SELECT 'Primer read', saldoId, montoSaldo FROM saldosDistribucion;
	waitfor delay '00:00:15'
	-- Por razones del planificador, la transacción T1 espera a que T2 termine

	--T2 termina y T1 empieza su transacción.
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001
		IF (SELECT COUNT(*) FROM @viajes v) != (SELECT COUNT(viaje) FROM #viajesSelect) BEGIN
			RAISERROR ('VIAJES NO EXISTEN', 16, 1)
		END 
		
		INSERT INTO [dbo].[itemsRecoleccion] ([productorId], [montoTotal], [recolectorId], [montoRec], [montoTrato], 
		[montoComisionEV],[viajeId],[fechaFactura], [descuentoSaldo], [montoAPagar], [enabled], [createdAt], [computer],[username],[checksum])
		SELECT productor,total, recolector, montoRecoleccion, montoTratamiento, comision, viaje, '2023-04-24 00:00:00', descuento, montoAPagar, 1, '2023-04-24 10:00:00', 'ComputerName', 'Username', 0x0123456789ABCDEF
		FROM #viajesSelect;
		
		SELECT 'Segundo read', saldoId, montoSaldo FROM saldosDistribucion;

		WITH sumSaldo (descuentoTotal, localId) AS (
			SELECT SUM(#viajesSelect.descuento) descuentoTotal, viajesRecoleccion.localId localId FROM #viajesSelect
			INNER JOIN viajesRecoleccion ON viajesRecoleccion.viajeId = #viajesSelect.viaje
			INNER JOIN saldosDistribucion ON saldosDistribucion.localId = viajesRecoleccion.localId
			GROUP BY viajesRecoleccion.localId
		)
		UPDATE saldosDistribucion
		SET montoSaldo = montoSaldo - sumSaldo.descuentoTotal
		FROM sumSaldo INNER JOIN saldosDistribucion ON saldosDistribucion.localId = sumSaldo.localId
		-- T1 vuelve a leer montoSaldo, pero esta vez montoSaldo está en 0 porque ya se había gastado todo
		-- Aquí ocurre el unrepeatable read problem. Se lee montoSaldo dos veces y se obtienen resultados distintos.
		-- Resta el valor inicial que leyó al inicio y escribe el resultado. El montoSaldo queda en -600
		SELECT 'Tercer read', saldoId, montoSaldo FROM saldosDistribucion;


		INSERT INTO [dbo].[facturas] (enabled, [createdAt], computer, username, checksum, facturaStatusId, [descripcion], [fecha], fechaMax)
VALUES (1, '2023-04-25 12:00:00', 'PC01', 'JohnDoe', 0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF, 1, 'Factura de recoleccion ', '2023-04-25 12:00:00', NULL);

		SET @facturaId = SCOPE_IDENTITY();

		INSERT INTO [dbo].[itemsFactura] (facturaId, itemId, tipoItemId, enabled, [createdAt], updatedAt, computer, username, checksum)
		SELECT @facturaId, itemsRecoleccion.itemRecId, 1, 1, '2023-04-25 12:00:00', NULL, 'PC01', 'JohnDoe', 0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
		FROM itemsRecoleccion
		INNER JOIN @viajes v ON v.viajeId = itemsRecoleccion.viajeId
		
		-- T1 termina su ejecución
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