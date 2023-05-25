-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 21/04/2023
-- Descripcion: En este script se realizan pruebas del problema Dirty Read
-----------------------------------------------------------

-- Prueba de error de Dirty read
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (14);

EXEC SP_registrarFacturaRecoleccionLU2 @viajes;
GO

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;

-- Prueba con stored procedure arreglado
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (16);

EXEC SP_registrarFacturaRecoleccionLU2Fix @viajes;
GO

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;

UPDATE saldosDistribucion
SET montoSaldo = 600
WHERE localId = 1