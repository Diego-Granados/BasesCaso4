
SELECT locales.nombre localidad, plantas.nombre planta, SUM(dpl.cantidad) cantidades FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON dpl.viajeId = vr.viajeId
INNER JOIN locales ON vr.localId = locales.localId
INNER JOIN plantas ON plantas.plantaId = dpl.plantaId
GROUP BY locales.nombre, plantas.nombre
ORDER BY locales.nombre, plantas.nombre


select recolectores.nombre as recolector, productores.nombre as productor, totalesRecolectores.cantidadRecogida as cantidad
FROM (select recolectores.recolectorId as recolector, productores.productorId as productor, SUM(desechosViajes.cantidad) as cantidadRecogida
FROM viajesRecoleccion
INNER JOIN (SELECT SUM(cantidad) as cantidad, viajeId FROM desechosPlantasLogs GROUP BY viajeId) desechosViajes ON desechosViajes.viajeId = viajesRecoleccion.viajeId
INNER JOIN camiones ON viajesRecoleccion.camionId = camiones.camionId
INNER JOIN recolectores ON recolectores.recolectorId = camiones.recolectorId
INNER JOIN locales ON locales.localId = viajesRecoleccion.localId
INNER JOIN productores ON productores.productorId = locales.productorId
GROUP BY recolectores.recolectorId, productores.productorId) totalesRecolectores
INNER JOIN recolectores ON recolectores.recolectorId = totalesRecolectores.recolector
INNER JOIN productores ON productores.productorId = totalesRecolectores.productor
ORDER BY recolectores.nombre, productores.nombre

SELECT r.nombre recolector, p.nombre productor, SUM(dpl.cantidad) totalRecogido FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON vr.viajeId = dpl.viajeId
INNER JOIN camiones ON camiones.camionId = vr.camionId
INNER JOIN recolectores r ON r.recolectorId = camiones.recolectorId
INNER JOIN plantas ON plantas.plantaId = dpl.plantaId
INNER JOIN locales ON locales.localId = vr.localId
INNER JOIN productores p ON p.productorId = locales.productorId
GROUP BY r.nombre, p.nombre
ORDER BY r.nombre, p.nombre

-- de recolector a planta
SELECT r.nombre recolector, plantas.nombre planta, SUM(dpl.cantidad) FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON vr.viajeId = dpl.viajeId
INNER JOIN camiones ON camiones.camionId = vr.camionId
INNER JOIN recolectores r ON r.recolectorId = camiones.recolectorId
INNER JOIN plantas ON plantas.plantaId = dpl.plantaId
GROUP BY r.nombre, plantas.nombre
ORDER BY r.nombre, plantas.nombre

-- de productor a planta
SELECT p.nombre, plantas.nombre, SUM(dpl.cantidad) FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON vr.viajeId = dpl.viajeId
INNER JOIN locales ON locales.localId = vr.localId
INNER JOIN productores p ON p.productorId = locales.productorId
INNER JOIN plantas ON plantas.plantaId = dpl.plantaId
GROUP BY p.nombre, plantas.nombre
ORDER BY p.nombre, plantas.nombre