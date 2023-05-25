

IF OBJECT_ID ('VW_contratoDesechosLogs', 'view') IS NOT NULL
   DROP VIEW [dbo].VW_contratoDesechosLogs ;
GO
CREATE VIEW VW_contratoDesechosLogs
WITH SCHEMABINDING
AS
SELECT dsp.desechoId AS desecho, vr.fechaInicio AS fechaInicio, dsp.viajeId AS viaje, vr.recPasoId AS paso, pr.recHorarioId AS horario, hr.recContratoId AS contratoRec, rpp.prodContratoId AS contratoProd 
FROM [dbo].desechosPlantasLogs dsp
INNER JOIN [dbo].viajesRecoleccion vr ON vr.viajeId = dsp.viajeId 
INNER JOIN [dbo].pasosRecoleccion pr ON pr.recPasoId = vr.recPasoId
INNER JOIN [dbo].horariosRecoleccion hr ON hr.recHorarioId = pr.recHorarioId
INNER JOIN [dbo].contratosRecoleccion cr ON cr.recContratoId = hr.recContratoId
INNER JOIN [dbo].recoleccionesPorProduccion rpp ON rpp.recContratoId = cr.recContratoId
INNER JOIN [dbo].contratosProduccion cp ON cp.prodContratoId = rpp.prodContratoId
GO

ALTER TABLE viajesRecoleccion
DROP COLUMN fechaInicio