
-- El rol de viajesReader niega el select sobre pasosRecoleccion
-- Como el usuario HierC es un sysadmin, tiene acceso a todas las opciones y no es restringido por el rol de viajesReader

SELECT * FROM pasosRecoleccion;

SELECT * FROM viajesRecoleccion;
