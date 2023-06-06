SELECT locales.nombre, plantas.nombre, totales.cantidades, totales.viaje FROM 
(SELECT totalLocales.localId As localidad, totalLocales.cantidad as cantidades, viajesRecoleccion.viajeId as viaje, viajesRecoleccion.plantaDestinoId as planta
FROM viajesRecoleccion
INNER JOIN 
(SELECT locales.localId as localId, (desechosViajes.cantidad) as cantidad 
FROM locales
INNER JOIN viajesRecoleccion ON locales.localId = viajesRecoleccion.localId
INNER JOIN plantas ON viajesRecoleccion.plantaDestinoId = plantas.plantaId
INNER JOIN 
(SELECT SUM(cantidad) as cantidad, viajeId FROM desechosPlantasLogs GROUP BY viajeId) desechosViajes ON desechosViajes.viajeId = viajesRecoleccion.viajeId
) totalLocales ON totalLocales.localId = viajesRecoleccion.localId) totales
INNER JOIN locales ON totales.localidad = locales.localId
INNER JOIN plantas ON plantas.plantaId = totales.planta
ORDER BY locales.nombre


SELECT locales.nombre, plantas.nombre, totales.cantidades, totales.viaje FROM 
(SELECT vr.localId localidad, dpl.plantaId planta, SUM(dpl.cantidad) cantidades, vr.viajeId viaje FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON dpl.viajeId = vr.viajeId
GROUP BY vr.localId, dpl.plantaId) totales
INNER JOIN locales ON totales.localidad = locales.localId
INNER JOIN plantas ON plantas.plantaId = totales.planta
ORDER BY locales.nombre



select viajeId, recPasoId, localid, plantadestinoid, fechaInicio from viajesRecoleccion
select viajeId, locales.nombre, plantas.nombre, fechaInicio from viajesRecoleccion
INNEr join locales on locales.localId = viajesRecoleccion.localId
inner join plantas on plantas.plantaId = viajesRecoleccion.plantaDestinoId
select nombre from locales
select nombre from plantas

SELECT viajeId, SUM(cantidad) FROM desechosPlantasLogs GROUP BY viajeId ORDER BY viajeId



select nombre from recolectores
select nombre from productores

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
ORDER BY recolectores.nombre

