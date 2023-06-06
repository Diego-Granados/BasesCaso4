-- executorLogin tiene roles de denydatareader, denydatawriter y db_executor
-- Fue asignado a ev41
-- No puede hacer selects pero si ejecutar SPs.

SELECT * FROM productos

EXEC SP_getProductos