-- User A
-- No tiene restricciones de columnas en canales.

SELECT canalId, nombre, tipoEntidadId, enabled, createdAt, updatedAt, computer, username, checksum FROM canales;

SELECT nombre, tipoEntidadId, enabled, createdAt, updatedAt, computer, username FROM canales;

-- User A pertenece a viajesAdmin, por lo que tiene acceso de select a toda la tabla, por el control
SELECT [viajeId]
      ,[recPasoId]
      ,[localId]
      ,[camionId]
      ,[plantaOrigenId]
      ,[plantaDestinoId]
      ,[fechaInicio]
      ,[choferId]
      ,[enabled]
      ,[createdAt]
      ,[updatedAt]
      ,[computer]
      ,[username]
      ,[checksum]
  FROM [dbo].[viajesRecoleccion]



