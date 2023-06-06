-- User B
-- No tiene acceso a canalId ni a checksum
SELECT canalId, nombre, tipoEntidadId, enabled, createdAt, updatedAt, computer, username, checksum FROM canales;

SELECT nombre, tipoEntidadId, enabled, createdAt, updatedAt, computer, username FROM canales;

EXEC SP_getCanales -- La restricción no afecta a los SPs.


-- User B pertenece a viajesReader por lo que no tiene acceso a viajeId, recPasoId, createdAt, updatedAt, computer, username y checksum
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

-- Tampoco puede filtrar por las filas a las que no tiene acceso, aunque no aparezcan en el output.
SELECT [localId]
      ,[camionId]
      ,[plantaOrigenId]
      ,[plantaDestinoId]
      ,[fechaInicio]
      ,[choferId]
      ,[enabled]
  FROM [dbo].[viajesRecoleccion]
  WHERE createdAt > '2022-01-01'

-- viajesReader también tiene una restricción sobre la tabla de pasosRecolección, por lo que UserB no puede leerla.
SELECT * FROM pasosRecoleccion;