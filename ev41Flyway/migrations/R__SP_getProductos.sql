-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 08/05/2023
-- Descripcion: Este Stored procedure obtiene los productos
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS  [dbo].[SP_getProductos];
GO

CREATE PROCEDURE [dbo].[SP_getProductos]
AS 
BEGIN
	SET NOCOUNT ON -- no retorne metadatos
	SELECT productoId, nombreBase FROM productos INNER JOIN nombres ON nombres.nombreId = productos.nombreId;

END
RETURN 0
GO
