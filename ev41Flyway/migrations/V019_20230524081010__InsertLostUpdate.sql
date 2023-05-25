-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 5/21/2023
-- Descripción: Este Stored procedure inserta viajes para la prueba del Lost Update
-----------------------------------------------------------

-- viaje 13 = 1
INSERT INTO [dbo].[viajesRecoleccion] ([recPasoId], [localId], [camionId], [plantaOrigenId], [plantaDestinoId], [fechaInicio], [choferId], [enabled], [createdAt], [updatedAt], [computer], [username], [checksum])
VALUES (1, 1, 1, 1, 2, '2023-05-04 09:00:00', NULL, 1, '2023-05-04 09:00:00', NULL, 'ComputerName', 'Username', 0x0123456789ABCDEF);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 2, 30, '2023-05-04 10:00:00', 13, 120.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 1, 40, '2023-05-04 10:00:00', 13, 100.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

-- viaje 14 = 2
INSERT INTO [dbo].[viajesRecoleccion] ([recPasoId], [localId], [camionId], [plantaOrigenId], [plantaDestinoId], [fechaInicio], [choferId], [enabled], [createdAt], [updatedAt], [computer], [username], [checksum])
VALUES (1, 1, 1, 1, 2, '2023-05-04 09:00:00', NULL, 1, '2023-05-04 09:00:00', NULL, 'ComputerName', 'Username', 0x0123456789ABCDEF);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 3, 25.5, '2023-05-04 10:00:00', 14, 50.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 4, 40.5, '2023-05-04 10:00:00', 14, 100.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

-- viaje 15 = 3
INSERT INTO [dbo].[viajesRecoleccion] ([recPasoId], [localId], [camionId], [plantaOrigenId], [plantaDestinoId], [fechaInicio], [choferId], [enabled], [createdAt], [updatedAt], [computer], [username], [checksum])
VALUES (1, 1, 1, 1, 2, '2023-05-11 09:00:00', NULL, 1, '2023-05-11 09:00:00', NULL, 'ComputerName', 'Username', 0x0123456789ABCDEF);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 2, 30, '2023-05-04 10:00:00', 15, 120.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 1, 40, '2023-05-04 10:00:00', 15, 100.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

-- viaje 16 = 4
INSERT INTO [dbo].[viajesRecoleccion] ([recPasoId], [localId], [camionId], [plantaOrigenId], [plantaDestinoId], [fechaInicio], [choferId], [enabled], [createdAt], [updatedAt], [computer], [username], [checksum])
VALUES (1, 1, 1, 1, 2, '2023-05-19 09:00:00', NULL, 1, '2023-05-19 09:00:00', NULL, 'ComputerName', 'Username', 0x0123456789ABCDEF);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 3, 25.5, '2023-05-04 10:00:00', 16, 50.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);

INSERT INTO [dbo].[desechosPlantasLogs] ([plantaId], [desechoId], [cantidad], [fecha], [viajeId], [costoTrato], [enabled], [costoTratoId], [createdAt], [computer], [username], [checksum])
VALUES (1, 4, 40.5, '2023-05-04 10:00:00', 16, 100.00, 1, 1, '2023-05-04 10:00:00', 'PC123', 'JohnDoe', 0x12AB34CD5678EF90123456AB789CDEF012345678);
