-----------------------------------------------------------
-- Autor: Diego Granados
-- Fecha: 25/05/2023
-- Descripcion: En este script se realizan pruebas del problema Lost Update
-----------------------------------------------------------

-- Prueba de error de Lost Update
DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (13);

EXEC SP_registrarFacturaRecoleccionLU1 @viajes;
GO

select * from facturas;
select * from itemsFactura;
select itemRecId, montoTotal, montoRec, montoTrato, montoComisionEV, viajeId, descuentoSaldo, montoAPagar from itemsRecoleccion;
select saldoId, localId, montoSaldo from saldosDistribucion;
select * from viajesRecoleccion;

delete itemsRecoleccion where viajeid = 13
-- Prueba con stored procedure arreglado

UPDATE saldosDistribucion
SET montoSaldo = 3000
WHERE localId = 1

DECLARE @viajes AS viajesTabla;

INSERT INTO @viajes VALUES (15);

EXEC SP_registrarFacturaRecoleccionLU1Fix @viajes;
GO

select * from facturas;
select * from itemsFactura;
select itemRecId, montoTotal, montoRec, montoTrato, montoComisionEV, viajeId, descuentoSaldo, montoAPagar from itemsRecoleccion;
select saldoId, localId, montoSaldo from saldosDistribucion;
select * from viajesRecoleccion;


