SELECT productoId, nombreBase FROM productos INNER JOIN nombres ON nombres.nombreId = productos.nombreId;

SELECT FROM lotesProduccionLogs

SELECT prodContratoId, precio, objectTypeId, areaEfectoId FROM contratosProduccion INNER JOIN preciosProductosContrato
INNER JOIN preciosProductosContrato ON contratosproduccion.prodContratoId = preciosProductosContrato.prodContratoId
INNER JOIN productos ON preciosProductosContrato.productoId = productos.productoId
WHERE productos.productoId = 1

SELECT lpl.loteId, lpl.productoId, lpl.prodContratoId, lpl.plantaId, lpl.cantidad - SUM(itemsProductos.cantidadProductos), lpl.costoProduccion, lpl.monedaId  FROM lotesProduccionLogs lpl
INNER JOIN preciosProductosContrato ON lpl.prodContratoId = preciosProductosContrato.prodContratoId
INNER JOIN productos ON lpl.productoId = productos.productoId
LEFT JOIN itemsProductos ON itemsProductos.loteId = lpl.loteId
GROUP BY itemsProductos.cantidadProductos, lpl.loteId, lpl.productoId, lpl.cantidad, lpl.prodContratoId, lpl.plantaId, lpl.costoProduccion, lpl.monedaId
GO


WITH sumItemsP (loteId, prodVendidos) AS (
	SELECT loteId AS loteId, sum(cantidadProductos) prodVendidos FROM itemsProductos GROUP BY loteId
)
SELECT sumItemsP.*, lpl.cantidad FROM lotesProduccionLogs lpl INNER JOIN sumItemsP ON lpl.loteID = sumItemsP.loteId
ORDER BY loteId


SELECT itemsProductos.*, lotesProduccionLogs.cantidad FROM itemsProductos INNER JOIN lotesProduccionLogs ON lotesProduccionLogs.loteId = itemsProductos.loteId
GROUP BY itemsProductos.loteId

SELECT canalId, nombre FROM canales