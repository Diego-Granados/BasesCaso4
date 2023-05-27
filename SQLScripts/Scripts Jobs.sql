

/* Job 1 */
DECLARE @ExecStatements NVARCHAR(MAX);

SELECT @ExecStatements = STRING_AGG('EXEC sp_recompile ''' + O.name + '''; EXEC ' + O.name + ';', CHAR(13))
FROM sys.sql_modules M 
INNER JOIN sys.objects O ON M.object_id = O.object_id 
WHERE O.type = 'P';

EXEC sp_executesql @ExecStatements;

select * from master.dbo.sysservers

/* Job 2 */
INSERT INTO [PREDATOR\MSSQLSERVER01].[evlogs].dbo.[eventLogs] ([posttime], [username], [checksum], [descripcion], [referenceId1], [referenceId2], [value1], [values2], [levelId], [eventTypeId], [objectTypeId], [sourceId], [enabled], [computer])
SELECT [posttime], [username], [checksum], [descripcion], [referenceId1], [referenceId2], [value1], [values2], [levelId], [eventTypeId], [objectTypeId], [sourceId], [enabled], [computer] FROM eventLogs

DELETE FROM eventLogs
WHERE eventLogId>0

select * from eventLogs