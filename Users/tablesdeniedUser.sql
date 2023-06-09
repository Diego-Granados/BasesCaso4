-- tablesdenied tiene roles de denydatareader y denydatawriter
-- Fue asignado a ev410
-- Fue dado permiso de execute en SPs.

-- No puede leer directamente
SELECT * FROM productos

-- Puede ejecutar SPs para leer
EXEC SP_getProductos