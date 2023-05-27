-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 21/05/2023
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

INSERT INTO @viajes VALUES (11), (12);

EXEC SP_registrarFacturaRecoleccionD2 @viajes;
Go

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;
