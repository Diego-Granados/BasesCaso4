-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 21/05/2023
-- Descripcion: En este script se realizan pruebas del problema Dirty Read
-----------------------------------------------------------

-- Prueba de error de Dirty read
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (100), (5);

EXEC SP_registrarFacturaRecoleccionDR1 @viajes;
GO

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;

-- Prueba con stored procedure arreglado
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (100), (5);

EXEC SP_registrarFacturaRecoleccionDR1Fix @viajes;
GO

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;

UPDATE saldosDistribucion
SET montoSaldo = 600
WHERE localId = 1