

SELECT canalId, nombre, tipoEntidadId, enabled, createdAt, updatedAt, computer, username, checksum FROM canales;

SELECT nombre, tipoEntidadId, enabled, createdAt, updatedAt, computer, username FROM canales;

EXEC SP_getCanales

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


SELECT [localId]
      ,[camionId]
      ,[plantaOrigenId]
      ,[plantaDestinoId]
      ,[fechaInicio]
      ,[choferId]
      ,[enabled]
  FROM [dbo].[viajesRecoleccion]

SELECT [localId]
      ,[camionId]
      ,[plantaOrigenId]
      ,[plantaDestinoId]
      ,[fechaInicio]
      ,[choferId]
      ,[enabled]
  FROM [dbo].[viajesRecoleccion]
  WHERE createdAt > '2022-01-01'


SELECT * FROM pasosRecoleccion;