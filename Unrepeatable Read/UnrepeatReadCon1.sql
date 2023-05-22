-----------------------------------------------------------
-- Autor: Diego Granados
-- Fecha: 05/04/2023
-- Descripcion: En este script se ejecuta el stored procedure SP_registrarFacturaRecoleccion
-----------------------------------------------------------

-- Prueba de error de unrepeatable read
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (1), (2);

EXEC SP_registrarFacturaRecoleccionUR1 @viajes;
GO

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;

-- Prueba con stored procedure arreglado
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (1), (2);

EXEC SP_registrarFacturaRecoleccionURFix1 @viajes;
GO

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;

UPDATE saldosDistribucion
SET montoSaldo = 600
WHERE localId = 1