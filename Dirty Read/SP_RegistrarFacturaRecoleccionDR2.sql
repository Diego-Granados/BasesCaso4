-----------------------------------------------------------
-- Autor: Diego Granados
-- Fecha: 4/23/2023
-- Descripción: Este Stored procedure inserta una factura con base en los viajes que se mandan por TVP.
-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 5/23/2023
-- Descripción: Este Stored Procedure se adaptó para mostrar el problema del dirty read.
-----------------------------------------------------------

DROP PROCEDURE IF EXISTS  [dbo].[SP_registrarFacturaRecoleccionDR2];
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
CREATE PROCEDURE [dbo].[SP_registrarFacturaRecoleccionDR2]
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

	
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1;
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		-- T2 empieza su ejecución

		/*
		T2 lee el saldo que actualizó T1. Calcula los descuentos de los viajes
		con base en este saldo, que es 116. Como son dos viajes del mismo local, a cada uno 
		le corresponde 83. 
		*/
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
		END));
	
		SELECT saldoId, montoSaldo FROM saldosDistribucion;

		/*
		Cuando llega aquí, T2 no puede escribir porque T1 tiene el lock sobre
		saldosDistribución, por lo que espera. Después de que T1 haga rollback,
		T2 hace el update. Sin embargo, originalmente había leído que solo podía usar $116.
		No obstante, ahora en el saldo hay 1450 porque T1 hizo rollback, por lo que de esos 1450 solo gasta 116.
		El saldo queda en 1334. Aquí ocurre el Dirty read, ya que en realidad T2 debió de
		haber tenido $1450 disponibles al inicio.
		*/
		WITH sumSaldo (descuentoTotal, localId) AS (
			SELECT SUM(#viajesSelect.descuento) descuentoTotal,
			viajesRecoleccion.localId localId FROM #viajesSelect
			INNER JOIN viajesRecoleccion
			ON viajesRecoleccion.viajeId = #viajesSelect.viaje
			INNER JOIN saldosDistribucion
			ON saldosDistribucion.localId = viajesRecoleccion.localId
			GROUP BY viajesRecoleccion.localId
		)
		UPDATE saldosDistribucion
		SET montoSaldo = montoSaldo - sumSaldo.descuentoTotal
		FROM sumSaldo INNER JOIN saldosDistribucion
		ON saldosDistribucion.localId = sumSaldo.localId

		SELECT saldoId, montoSaldo FROM saldosDistribucion;

		IF (SELECT COUNT(*) FROM @viajes v) != (SELECT COUNT(viaje) FROM #viajesSelect) BEGIN
			RAISERROR ('VIAJES NO EXISTEN', 16, 1)
		END

		IF (SELECT COUNT(*) FROM itemsRecoleccion INNER JOIN @viajes v ON itemsRecoleccion.viajeId = v.viajeId) != 0 BEGIN
			RAISERROR('YA HAY VIAJES PAGADOS EN LOS VIAJES INGRESADOS', 16, 1)
		END;

		INSERT INTO [dbo].[itemsRecoleccion] ([productorId], [montoTotal], [recolectorId], [montoRec], [montoTrato], 
		[montoComisionEV],[viajeId],[fechaFactura], [descuentoSaldo], [montoAPagar], [enabled], [createdAt], [computer],[username],[checksum])
		SELECT productor,total, recolector, montoRecoleccion, montoTratamiento, comision, viaje, '2023-04-24 00:00:00', descuento, montoAPagar, 1, '2023-04-24 10:00:00', 'ComputerName', 'Username', 0x0123456789ABCDEF
		FROM #viajesSelect;

		INSERT INTO [dbo].[facturas] (enabled, [createdAt], computer, username, checksum, facturaStatusId, [descripcion], [fecha], fechaMax)
VALUES (1, '2023-04-25 12:00:00', 'PC01', 'JohnDoe', 0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF, 1, 'Factura de recoleccion ', '2023-04-25 12:00:00', NULL);

		SET @facturaId = SCOPE_IDENTITY();

		INSERT INTO [dbo].[itemsFactura] (facturaId, itemId, tipoItemId, enabled, [createdAt], updatedAt, computer, username, checksum)
		SELECT @facturaId, itemsRecoleccion.itemRecId, 1, 1, '2023-04-25 12:00:00', NULL, 'PC01', 'JohnDoe', 0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
		FROM itemsRecoleccion
		INNER JOIN @viajes v ON v.viajeId = itemsRecoleccion.viajeId
		
		
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