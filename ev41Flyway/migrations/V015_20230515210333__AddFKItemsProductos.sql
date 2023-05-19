-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 05/15/2023
-- Descripcion: En este script se agrega un FK en itemsProductos a lotesProduccionLogs
-----------------------------------------------------------

ALTER TABLE itemsProductos
ADD CONSTRAINT FK_itemsProductos_lotesProduccionLogs FOREIGN KEY (loteId)
REFERENCES lotesProduccionLogs (loteId)
ON DELETE NO ACTION
ON UPDATE NO ACTION

GO