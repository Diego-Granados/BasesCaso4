-----------------------------------------------------------
-- Autor: Diego Granados
-- Fecha: 4/23/2023
-- Descripcion: Este Stored procedure inserta una factura con base en los productos vendidos que se mandan por TVP.
-----------------------------------------------------------

DROP PROCEDURE IF EXISTS  [dbo].[SP_registrarFacturaProductos];
GO
DROP TYPE IF EXISTS productosTabla;
GO

CREATE TYPE productosTabla
	AS TABLE
		(cantidad INT, precio MONEY, loteId INT, canalId INT);
GO

-- Este stored procedure recibe los viajes de recolecci�n que se van a pagar en un table valued parameter.
CREATE PROCEDURE [dbo].[SP_registrarFacturaProductos]
	@productosVenta [dbo].productosTabla READONLY
AS 
BEGIN
	
	SET NOCOUNT ON -- no retorne metadatos
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- declaracion de otras variables

	DECLARE @facturaId BIGINT
	DECLARE @fecha DATETIME
	-- operaciones de select que no tengan que ser bloqueadas
	
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001
		
		SET @fecha = GETDATE();
		INSERT INTO [dbo].[itemsProductos] ([canalId], [loteId], [cantidadProductos], [montoTotal], [monedaId], [fecha], [precioProductoId], [enabled], [createdAt], [computer], [username], [checksum])
		SELECT pv.canalId, pv.loteId, pv.cantidad, pv.precio, 1, @fecha, pPC.precioProductoId, 1,  @fecha, 'Computer1', 'User1', 0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
		FROM @productosVenta pv
		INNER JOIN lotesProduccionLogs lpl ON lpl.loteId = pv.loteId
		INNER JOIN preciosProductosContrato pPC On pPC.prodContratoId = lpl.prodContratoId AND pPC.productoId = lpl.productoId;

		INSERT INTO [dbo].[facturas] (enabled, [createdAt], computer, username, checksum, facturaStatusId, [descripcion], [fecha], fechaMax)
VALUES (1, @fecha, 'PC01', 'JohnDoe', 0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF, 1, 'Factura de recoleccion ', @fecha, NULL);

		SET @facturaId = SCOPE_IDENTITY();

		INSERT INTO [dbo].[itemsFactura] (facturaId, itemId, tipoItemId, enabled, [createdAt], updatedAt, computer, username, checksum)
		SELECT @facturaId, itemsProductos.itemProdId, 3, 1, @fecha, NULL, 'PC01', 'JohnDoe', 0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
		FROM itemsProductos
		INNER JOIN @productosVenta pv ON pv.canalId = itemsProductos.canalId AND pv.loteId = itemsProductos.loteId AND pv.cantidad = itemsProductos.[cantidadProductos] AND pv.precio = itemsProductos.montoTotal
		INNER JOIN facturas ON facturas.facturaId = @facturaId and itemsProductos.fecha = facturas.fecha
		
		
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
END
RETURN 0
GO