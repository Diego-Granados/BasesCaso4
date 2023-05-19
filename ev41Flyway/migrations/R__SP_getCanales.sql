-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 08/05/2023
-- Descripcion: Este Stored procedure obtiene los canales
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS  [dbo].[SP_getCanales];
GO

CREATE PROCEDURE [dbo].[SP_getCanales]
AS 
BEGIN
	SET NOCOUNT ON -- no retorne metadatos
	SELECT canalId, nombre FROM canales

END
RETURN 0
GO