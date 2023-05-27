-----------------------------------------------------------
-- Autor: Diego Granados
-- Fecha: 25/05/2023
-- Descripcion: En este script se realizan pruebas del problema Lost Update
-----------------------------------------------------------

-- Prueba de error de Lost Update
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (14);

EXEC SP_registrarFacturaRecoleccionLU2 @viajes;
GO

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;

UPDATE saldosDistribucion
SET montoSaldo = 3000
WHERE localId = 1

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

