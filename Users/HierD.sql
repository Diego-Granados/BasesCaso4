-- Hier D
-- El rol de viajesAdmin permite el select de las columnas de viajesRecoleccion.
-- Al usuario HierD, se le neg� el permiso de SELECT de viajesRecolecci�n.
-- El nivel superior del rol lo permite y el securable del usuario lo niega

SELECT * FROM viajesRecoleccion;

-- El Deny de Select toma precedencia.