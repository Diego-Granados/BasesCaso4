-----------------------------------------------------------
-- Autor: Diego Granados
-- Fecha: 05/20/2023
-- Descripcion: En este script se insertan valores en la bitácora del sistema
-----------------------------------------------------------

INSERT INTO [dbo].[levels] ([descripcion], [enabled])
VALUES ('Information', 1),
('Warning', 1),
('Error', 1);

INSERT INTO [dbo].[sources] ([nombre], [enabled])
VALUES ('Recolección', 1),
('Venta', 1),
('Producción', 1),
('Contrato', 1),
('Sistema', 1),
('Base de datos', 1);

INSERT INTO [dbo].[eventTypes] ([nombre], [enabled])
VALUES ('Insert', 1),
('Update', 1),
('Delete', 1),
('Select', 1);


INSERT INTO objectTypes (objectName, createdAt, computer, username, checksum) VALUES
('Desecho', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Contacto', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Contrato Prod', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Contrato Reco', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Contrato Conta', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Factura', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Item Producto', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Item Ganancia', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Item Reco', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Item Conta', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Viaje', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT'))

/* 13 Objetos */

DROP TABLE IF EXISTS #objectTypeQuantities;
CREATE TABLE #objectTypeQuantities (
	objectTypeId TINYINT IDENTITY(1,1) NOT NULL,
	cantidad INT NULL
);

INSERT INTO #objectTypeQuantities (cantidad) VALUES
((SELECT COUNT(direccionId) FROM direcciones)),
((SELECT COUNT(ciudadId) FROM ciudades)),
((SELECT COUNT(estadoId) FROM estados)),
((SELECT COUNT(paisId) FROM paises)),
((SELECT COUNT(regionId) FROM regiones)),
((SELECT COUNT(localId) FROM locales)),
((SELECT COUNT(productorId) FROM productores)),
((SELECT COUNT(recolectorId) FROM recolectores)),
((SELECT COUNT(participanteId) FROM participantes)),
((SELECT COUNT(recipienteId) FROM recipientes)),
((SELECT COUNT(productoId) FROM productos)),
((SELECT COUNT(loteId) FROM lotesProduccionLogs)),
((SELECT COUNT(desechoId) FROM desechos)),
((SELECT COUNT(contactoId) FROM contactos)),
((SELECT COUNT(prodContratoId) FROM contratosProduccion)),
((SELECT COUNT(recContratoId) FROM contratosRecoleccion)),
((SELECT COUNT(contaContratoId) FROM contratosEmpContaminantes)),
((SELECT COUNT(facturaId) FROM facturas)),
((SELECT COUNT(itemProdId) FROM itemsProductos)),
((SELECT COUNT(itemGanaId) FROM itemsGanancias)),
((SELECT COUNT(itemRecId) FROM itemsRecoleccion)),
((SELECT COUNT(itemContId) FROM itemsContaminantes)),
((SELECT COUNT(viajeId) FROM viajesRecoleccion))

-- select * from objectTypes;
DECLARE @contador INT;
SET @contador = 1
WHILE @contador <= 1000
BEGIN

DECLARE @objectTypeId TINYINT;
SET @objectTypeId = CEILING(RAND()*23)

INSERT INTO [dbo].[eventLogs] ([posttime], [username], [checksum], [descripcion], [referenceId1], [referenceId2], [value1], [values2], [ubicacion], [levelId], [eventTypeId], [objectTypeId], [sourceId], [enabled], [computer])
VALUES 
(DATEADD(minute, FLOOR(1 + RAND()*518400), '2022-01-01 00:00:00'), N'JohnDoe', 0x0123456789ABCDEF, 'Some Description', FLOOR(1 + RAND() * (SELECT cantidad FROM #objectTypeQuantities WHERE objectTypeId = @objectTypeId)), FLOOR(1 + RAND() * (SELECT cantidad FROM #objectTypeQuantities WHERE objectTypeId = @objectTypeId)), N'Value 1', N'Value 2', geography::Point(1.234, 5.678, 4326), CEILING(RAND()*3), CEILING(RAND()*4), @objectTypeId, CEILING(RAND()*6), 1, 'ComputerName');

SET @contador = @contador + 1

END

-- select * from eventLogs ORDER BY posttime