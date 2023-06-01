-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 22/05/2023
-- Descripcion: En este script se ejecuta el stored procedure SP_registrarFacturaRecoleccion
-- para demostrar el problema del unrepeatable read. Conexión 2.
-----------------------------------------------------------


UPDATE saldosDistribucion
SET montoSaldo = 600
WHERE localId = 1
UPDATE saldosDistribucion
SET montoSaldo = 10000
WHERE localId = 2

-- Prueba de error de unrepeatable read
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (3), (4);

EXEC SP_registrarFacturaRecoleccionUR2 @viajes;
Go

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;

-- Prueba con stored procedure arreglado
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (3), (4);

EXEC SP_registrarFacturaRecoleccionURFix2 @viajes;
Go

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;
