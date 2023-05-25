-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 5/21/2023
-- Descripción: Este Stored procedure inserta viajes para la prueba del Dirty Read
-----------------------------------------------------------

-- viaje 5 = 1
INSERT INTO [dbo].[viajesRecoleccion] ([recPasoId], [localId], [camionId], [plantaOrigenId], [plantaDestinoId], [fechaInicio], [choferId], [enabled], [createdAt], [updatedAt], [computer], [username], [checksum])
VALUES (1, 1, 1, 1, 2, '2023-05-04 09:00:00', NULL, 1, '2023-05-04 09:00:00', NULL, 'ComputerName', 'Username', 0x0123456789ABCDEF);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 2, 30, '2023-05-04 10:00:00', 5, 50.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 1, 40, '2023-05-04 10:00:00', 5, 100.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

-- viaje 6 = 2
INSERT INTO [dbo].[viajesRecoleccion] ([recPasoId], [localId], [camionId], [plantaOrigenId], [plantaDestinoId], [fechaInicio], [choferId], [enabled], [createdAt], [updatedAt], [computer], [username], [checksum])
VALUES (2, 2, 1, 1, 2, '2023-05-04 09:00:00', NULL, 1, '2023-05-04 09:00:00', NULL, 'ComputerName', 'Username', 0x0123456789ABCDEF);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 3, 25.5, '2023-05-04 10:00:00', 6, 50.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 4, 40.5, '2023-05-04 10:00:00', 6, 100.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

-- viaje 7 = 3
INSERT INTO [dbo].[viajesRecoleccion] ([recPasoId], [localId], [camionId], [plantaOrigenId], [plantaDestinoId], [fechaInicio], [choferId], [enabled], [createdAt], [updatedAt], [computer], [username], [checksum])
VALUES (1, 1, 1, 1, 2, '2023-05-11 09:00:00', NULL, 1, '2023-05-11 09:00:00', NULL, 'ComputerName', 'Username', 0x0123456789ABCDEF);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 2, 20, '2023-05-11 10:00:00', 7, 50.00, 1, 1, '2023-05-11 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 1, 18, '2023-05-11 10:00:00', 7, 100.00, 1, 1, '2023-05-11 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

-- viaje 8 = 4
INSERT INTO [dbo].[viajesRecoleccion] ([recPasoId], [localId], [camionId], [plantaOrigenId], [plantaDestinoId], [fechaInicio], [choferId], [enabled], [createdAt], [updatedAt], [computer], [username], [checksum])
VALUES (1, 1, 1, 1, 2, '2023-05-19 09:00:00', NULL, 1, '2023-05-19 09:00:00', NULL, 'ComputerName', 'Username', 0x0123456789ABCDEF);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 2, 25, '2023-05-19 10:00:00', 8, 50.00, 1, 1, '2023-05-19 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 1, 20, '2023-05-19 10:00:00', 8, 100.00, 1, 1, '2023-05-19 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);
