
DROP VIEW IF EXISTS recoleccionesResiduos
GO

CREATE VIEW recoleccionesResiduos AS 
SELECT
	traduccionesPorIdioma.traduccion AS PaisRegion,
	industryNames.nombreBase AS Industria,
	tiposNames.nombreBase AS TipoDesecho,
	dpl.cantidad Cantidad,
	dpl.costoTrato CostoTrato,
	vr.viajeId,
	dpl.costoTrato + cr.comisionEv AS MontoTotal,
	cr.comisionEV Ganancia,
	dpl.fecha FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON dpl.viajeId = vr.viajeId
INNER JOIN pasosRecoleccion pr ON vr.recPasoId = pr.recPasoId
INNER JOIN costosPasoRecoleccion cr ON cr.recPasoId = pr.recPasoId
INNER JOIN desechos ON dpl.desechoId = desechos.desechoId
INNER JOIN tiposDesechos ON tiposDesechos.desTipoId = desechos.desTipoId
INNER JOIN locales ON locales.localId = vr.localId
INNER JOIN productores ON locales.productorId = productores.productorId
INNER JOIN industrias ON industrias.industriaId = productores.industriaId
INNER JOIN direcciones ON locales.direccionId = direcciones.direccionId
INNER JOIN ciudades ON ciudades.ciudadId = direcciones.ciudadId
INNER JOIN estados ON estados.estadoId = ciudades.estadoId
INNER JOIN paises ON paises.paisId = estados.paisId
INNER JOIN tiposDeCambio ON cr.monedaId = tiposDeCambio.monedaCambioId
INNER JOIN nombres paisesNames ON paisesNames.nombreId = paises.nombreId
INNER JOIN nombres industryNames ON industryNames.nombreId = industrias.nombreId
INNER JOIN nombres tiposNames ON tiposNames.nombreId = tiposDesechos.nombreId
INNER JOIN traduccionesPorIdioma ON traduccionesPorIdioma.nombreId = paisesNames.nombreId AND traduccionesPorIdioma.idiomaId = 2
UNION
SELECT
	traduccionesPorIdioma.traduccion AS PaisRegion,
	industryNames.nombreBase AS Industria,
	tiposNames.nombreBase AS TipoDesecho,
	dpl.cantidad Cantidad,
	dpl.costoTrato CostoTrato,
	vr.viajeId,
	dpl.costoTrato + cr.comisionEv AS MontoTotal,
	cr.comisionEV Ganancia,
	dpl.fecha FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON dpl.viajeId = vr.viajeId
INNER JOIN pasosRecoleccion pr ON vr.recPasoId = pr.recPasoId
INNER JOIN costosPasoRecoleccion cr ON cr.recPasoId = pr.recPasoId
INNER JOIN desechos ON dpl.desechoId = desechos.desechoId
INNER JOIN tiposDesechos ON tiposDesechos.desTipoId = desechos.desTipoId
INNER JOIN locales ON locales.localId = vr.localId
INNER JOIN productores ON locales.productorId = productores.productorId
INNER JOIN industrias ON industrias.industriaId = productores.industriaId
INNER JOIN direcciones ON locales.direccionId = direcciones.direccionId
INNER JOIN ciudades ON ciudades.ciudadId = direcciones.ciudadId
INNER JOIN estados ON estados.estadoId = ciudades.estadoId
INNER JOIN paises ON paises.paisId = estados.paisId
INNER JOIN nombres industryNames ON industryNames.nombreId = industrias.nombreId
INNER JOIN nombres tiposNames ON tiposNames.nombreId = tiposDesechos.nombreId
INNER JOIN elementosPorRegion ON elementosPorRegion.paisId = paises.paisId
	OR estados.estadoId = elementosPorRegion.estadoId 
	OR ciudades.ciudadId = elementosPorRegion.ciudadId
	OR elementosPorRegion.direccionId = direcciones.direccionId
INNER JOIN regiones ON elementosPorRegion.regionId = regiones.regionId
INNER JOIN nombres regionNames ON regionNames.nombreId = regiones.nombreId
INNER JOIN traduccionesPorIdioma ON traduccionesPorIdioma.nombreId = regionNames.nombreId AND traduccionesPorIdioma.idiomaId = 2
GO

SELECT * FROM recoleccionesResiduos
SELECT * FROM desechosPlantasLogs

SELECT *, nombres.nombreBase FROM Regiones INNER JOIN nombres ON nombres.nombreId = regiones.nombreId

SELECT PaisRegion, industria, tipoDesecho, SUM(costoTrato), SUM(montoTotal), SUM(ganancia) gananciaNeta FROM recoleccionesResiduos GROUP BY PaisRegion, industria, tipoDesecho, ganancia
ORDER BY gananciaNeta DESC, paisRegion, industria, tipoDesecho

SELECT PaisRegion, industria, tipoDesecho, SUM(costoTrato), SUM(montoTotal), SUM(ganancia) gananciaNeta
FROM recoleccionesResiduos
WHERE fecha BETWEEN '2023-05-07' AND '2023-05-20'
GROUP BY PaisRegion, industria, tipoDesecho, ganancia
ORDER BY gananciaNeta DESC, paisRegion, industria, tipoDesecho

SELECT * FROM itemsRecoleccion

SELECT
	* FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON dpl.viajeId = vr.viajeId
INNER JOIN pasosRecoleccion pr ON vr.recPasoId = pr.recPasoId
INNER JOIN costosPasoRecoleccion cr ON cr.recPasoId = pr.recPasoId
INNER JOIN desechos ON dpl.desechoId = desechos.desechoId
INNER JOIN tiposDesechos ON tiposDesechos.desTipoId = desechos.desTipoId
INNER JOIN locales ON locales.localId = vr.localId
INNER JOIN productores ON locales.productorId = productores.productorId
INNER JOIN industrias ON industrias.industriaId = productores.industriaId
INNER JOIN direcciones ON locales.direccionId = direcciones.direccionId
INNER JOIN ciudades ON ciudades.ciudadId = direcciones.ciudadId
INNER JOIN estados ON estados.estadoId = ciudades.estadoId
INNER JOIN paises ON paises.paisId = estados.paisId
INNER JOIN tiposDeCambio ON cr.monedaId = tiposDeCambio.monedaCambioId
INNER JOIN nombres paisesNames ON paisesNames.nombreId = paises.nombreId
INNER JOIN nombres industryNames ON industryNames.nombreId = industrias.nombreId
INNER JOIN nombres tiposNames ON tiposNames.nombreId = tiposDesechos.nombreId

SELECT
	traduccionesPorIdioma.traduccion AS PaisRegion,
	industryNames.nombreBase AS Industria,
	tiposNames.nombreBase AS TipoDesecho,
	dpl.cantidad Cantidad,
	dpl.costoTrato CostoTrato,
	vr.viajeId,
	dpl.costoTrato + cr.comisionEv AS MontoTotal,
	cr.comisionEV Ganancia,
	dpl.fecha FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON dpl.viajeId = vr.viajeId
INNER JOIN pasosRecoleccion pr ON vr.recPasoId = pr.recPasoId
INNER JOIN costosPasoRecoleccion cr ON cr.recPasoId = pr.recPasoId
INNER JOIN desechos ON dpl.desechoId = desechos.desechoId
INNER JOIN tiposDesechos ON tiposDesechos.desTipoId = desechos.desTipoId
INNER JOIN locales ON locales.localId = vr.localId
INNER JOIN productores ON locales.productorId = productores.productorId
INNER JOIN industrias ON industrias.industriaId = productores.industriaId
INNER JOIN direcciones ON locales.direccionId = direcciones.direccionId
INNER JOIN ciudades ON ciudades.ciudadId = direcciones.ciudadId
INNER JOIN estados ON estados.estadoId = ciudades.estadoId
INNER JOIN paises ON paises.paisId = estados.paisId
INNER JOIN tiposDeCambio ON cr.monedaId = tiposDeCambio.monedaCambioId
INNER JOIN nombres paisesNames ON paisesNames.nombreId = paises.nombreId
INNER JOIN nombres industryNames ON industryNames.nombreId = industrias.nombreId
INNER JOIN nombres tiposNames ON tiposNames.nombreId = tiposDesechos.nombreId
INNER JOIN traduccionesPorIdioma ON traduccionesPorIdioma.nombreId = paisesNames.nombreId AND traduccionesPorIdioma.idiomaId = 2

SELECT * FROM traduccionesPorIdioma

SELECT
	traduccionesPorIdioma.traduccion AS PaisRegion,
	industryNames.nombreBase AS Industria,
	tiposNames.nombreBase AS TipoDesecho,
	dpl.cantidad Cantidad,
	dpl.costoTrato CostoTrato,
	vr.viajeId,
	dpl.costoTrato + cr.comisionEv AS MontoTotal,
	cr.comisionEV Ganancia,
	dpl.fecha FROM desechosPlantasLogs dpl
INNER JOIN viajesRecoleccion vr ON dpl.viajeId = vr.viajeId
INNER JOIN pasosRecoleccion pr ON vr.recPasoId = pr.recPasoId
INNER JOIN costosPasoRecoleccion cr ON cr.recPasoId = pr.recPasoId
INNER JOIN desechos ON dpl.desechoId = desechos.desechoId
INNER JOIN tiposDesechos ON tiposDesechos.desTipoId = desechos.desTipoId
INNER JOIN locales ON locales.localId = vr.localId
INNER JOIN productores ON locales.productorId = productores.productorId
INNER JOIN industrias ON industrias.industriaId = productores.industriaId
INNER JOIN direcciones ON locales.direccionId = direcciones.direccionId
INNER JOIN ciudades ON ciudades.ciudadId = direcciones.ciudadId
INNER JOIN estados ON estados.estadoId = ciudades.estadoId
INNER JOIN paises ON paises.paisId = estados.paisId
INNER JOIN nombres industryNames ON industryNames.nombreId = industrias.nombreId
INNER JOIN nombres tiposNames ON tiposNames.nombreId = tiposDesechos.nombreId
INNER JOIN elementosPorRegion ON elementosPorRegion.paisId = paises.paisId
	OR estados.estadoId = elementosPorRegion.estadoId 
	OR ciudades.ciudadId = elementosPorRegion.ciudadId
	OR elementosPorRegion.direccionId = direcciones.direccionId
INNER JOIN regiones ON elementosPorRegion.regionId = regiones.regionId
INNER JOIN nombres regionNames ON regionNames.nombreId = regiones.nombreId
INNER JOIN traduccionesPorIdioma ON traduccionesPorIdioma.nombreId = regionNames.nombreId AND traduccionesPorIdioma.idiomaId = 2

SELECT * FROM regiones