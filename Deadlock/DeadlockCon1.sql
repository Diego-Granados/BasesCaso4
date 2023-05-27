-----------------------------------------------------------
-- Autor: Diego Granados
-- Fecha: 05/04/2023
-- Descripcion: En este script se realizan pruebas del problema deadlock
-----------------------------------------------------------

UPDATE saldosDistribucion
SET montoSaldo = 600
WHERE localId = 1
UPDATE saldosDistribucion
SET montoSaldo = 10000
WHERE localId = 2

-- Prueba de error de unrepeatable read
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (9), (10);

EXEC SP_registrarFacturaRecoleccionD1 @viajes;
GO

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;
