-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 21/05/2023
-- Descripcion: En este script se realizan pruebas del problema deadlock
-----------------------------------------------------------

-- Prueba de error de unrepeatable read
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (7), (8);

EXEC SP_registrarFacturaRecoleccionD2 @viajes;
Go

select * from facturas;
select * from itemsFactura;
select * from itemsRecoleccion;
select * from saldosDistribucion;
select * from viajesRecoleccion;
