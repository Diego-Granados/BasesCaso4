-- Hier D
-- El rol de viajesAdmin permite el select de las columnas de viajesRecoleccion.
-- Al usuario HierD, se le negó el permiso de SELECT de viajesRecolección.
-- El nivel superior del rol lo permite y el securable del usuario lo niega

SELECT * FROM viajesRecoleccion;

-- El Deny de Select toma precedencia.