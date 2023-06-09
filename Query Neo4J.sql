-- Links, local a planta
SELECT locales.nombre localidad, plantas.nombre planta, SUM(dpl.cantidad) cantidades FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON dpl.viajeId = vr.viajeId
INNER JOIN locales ON vr.localId = locales.localId
INNER JOIN plantas ON plantas.plantaId = dpl.plantaId
GROUP BY locales.nombre, plantas.nombre
ORDER BY locales.nombre, plantas.nombre

-- linksprod, Recolector a productor
SELECT r.nombre recolector, p.nombre productor, SUM(dpl.cantidad) totalRecogido FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON vr.viajeId = dpl.viajeId
INNER JOIN camiones ON camiones.camionId = vr.camionId
INNER JOIN recolectores r ON r.recolectorId = camiones.recolectorId
INNER JOIN plantas ON plantas.plantaId = dpl.plantaId
INNER JOIN locales ON locales.localId = vr.localId
INNER JOIN productores p ON p.productorId = locales.productorId
GROUP BY r.nombre, p.nombre
ORDER BY r.nombre, p.nombre

-- recoplanta de recolector a planta
SELECT r.nombre recolector, plantas.nombre planta, SUM(dpl.cantidad) FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON vr.viajeId = dpl.viajeId
INNER JOIN camiones ON camiones.camionId = vr.camionId
INNER JOIN recolectores r ON r.recolectorId = camiones.recolectorId
INNER JOIN plantas ON plantas.plantaId = dpl.plantaId
GROUP BY r.nombre, plantas.nombre
ORDER BY r.nombre, plantas.nombre

-- prodplanta de productor a planta
SELECT p.nombre, plantas.nombre, SUM(dpl.cantidad) FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON vr.viajeId = dpl.viajeId
INNER JOIN locales ON locales.localId = vr.localId
INNER JOIN productores p ON p.productorId = locales.productorId
INNER JOIN plantas ON plantas.plantaId = dpl.plantaId
GROUP BY p.nombre, plantas.nombre
ORDER BY p.nombre, plantas.nombre