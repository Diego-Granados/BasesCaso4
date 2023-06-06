-- HierB
-- Tiene el rol de db_owner y de viajesReader.

-- El rol de viajesReader niega el select sobre pasosRecoleccion
-- Al usuario de HierB se le asignó específicamente que pueda hacer select desde un securable.

SELECT * FROM pasosRecoleccion;

SELECT * FROM viajesRecoleccion;

-- Los denies del rol de viajesReader toman precedencia sobre los grants de db_owner y los permisos del securable.

