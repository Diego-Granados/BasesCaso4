-----------------------------------------------------------
-- Autor: Diego Granados
-- Fecha: 05/04/2023
-- Descripcion: En este script se ejecuta el stored procedure SP_registrarFacturaRecoleccion
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
