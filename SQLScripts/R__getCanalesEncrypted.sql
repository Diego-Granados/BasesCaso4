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


		/* La tabla de saldosDistribucion puede causar que haya un lost update y un dirty read. Puede ocurrir un lost update cuando se intenta 
		registrar la factura de dos viajes diferentes, en diferentes transacciones, que van al mismo local. Puede ser que la T1 actualice 
		el saldo de ese local con base en el descuento de ese viaje, y que T2 haga lo mismo con base en su viaje. Como el montoSaldo en T2 no se 
		ha actualizado, el monto que quedó luego de T1 no va aparecer, entonces se pierde el update de T1. Por otro lado, es posible que también se
		cree una inconsistencia en los datos e incluso el saldo dé negativo. En este stored procedure se lee el monto que se puede obtener del descuento antes,
		en el SELECT de la línea 48. Esto puede causar que dos transacciones lean el mismo valor de saldo disponible en ese momento, por lo que cada una
		va a sacar el descuento con base en ese monto. No obstante, cuando se actualice aquí, las dos transacciones van a restarle al saldo sus descuentos, 
		y dependiendo de la cantidad del saldo, es posible que no alcance para los dos. Por ejemplo, T1 y T2 registran viajes para el local 1, por lo que
		usan el mismo saldo. Supongamos que el saldo es de 1500. Si el viaje de T1 cuesta 700 y el de T2 1000, entonces con base en el monto que leyeron, sí
		pueden tener ese descuento. A la hora de actualizar el saldo, se terminaría realizando 1500 - 700 - 1000 = -200, por lo que el saldo quedaría negativo
		y se crearía una inconsistencia. */