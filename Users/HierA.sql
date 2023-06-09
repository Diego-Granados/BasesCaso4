-- Usuario HierA: Tiene rol de viajesReader
-- Un nivel superior niega acceso y un nivel inferior lo permite
-- Rol de viajesReader niega acceso a pasosRecolección. Desde el usuario en la db, se permite el acceso por select
-- Como el rol ya niega el acceso, no importa que se le haya permitido desde la tabla aún cuando el que dio permiso fue dbo.
-- Sigue sin poder acceder.

SELECT * FROM pasosRecoleccion;


