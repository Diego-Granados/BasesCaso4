-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 08/05/2023
-- Descripcion: Este Stored procedure obtiene los canales
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS  [dbo].[SP_getCanalesEncrypted];
GO

CREATE PROCEDURE [dbo].[SP_getCanalesEncrypted]
AS 
BEGIN
	SET NOCOUNT ON -- no retorne metadatos
	SELECT canalId, nombre FROM canales

END
RETURN 0
GO

EXEC [SP_getCanalesEncrypted]
GO

/* Métodos para revisar si el stored procedure está encriptado */ 
SELECT O.name, M.definition, O.type_desc, O.type 
FROM sys.sql_modules M 
INNER JOIN sys.objects O ON M.object_id=O.object_id 
WHERE O.type IN ('P');
GO

sp_HelpText SP_getCanales;
GO
sp_HelpText SP_getCanalesEncrypted;
GO

ALTER PROCEDURE [dbo].[SP_getCanalesEncrypted]
WITH ENCRYPTION
AS 
BEGIN
	SET NOCOUNT ON -- no retorne metadatos
	SELECT canalId, nombre FROM canales

END
RETURN 0
GO

EXEC [SP_getCanales]
GO

EXEC [SP_getCanalesEncrypted]
GO

