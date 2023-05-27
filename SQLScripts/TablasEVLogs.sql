CREATE TABLE [dbo].[eventLogs](
	[eventLogId] [int] IDENTITY(1,1) NOT NULL,
	[posttime] [datetime] NOT NULL,
	[username] [nchar](20) NOT NULL,
	[checksum] [varbinary](150) NOT NULL,
	[descripcion] [nchar](250) NOT NULL,
	[referenceId1] [bigint] NOT NULL,
	[referenceId2] [bigint] NOT NULL,
	[value1] [nchar](60) NOT NULL,
	[values2] [nchar](60) NOT NULL,
	[levelId] [tinyint] NOT NULL,
	[eventTypeId] [int] NOT NULL,
	[objectTypeId] [tinyint] NOT NULL,
	[sourceId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[computer] [varchar](20) NOT NULL,
 CONSTRAINT [PK_eventLogs] PRIMARY KEY CLUSTERED 
(
	[eventLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) 
GO

CREATE TABLE [dbo].[sources](
	[sourceId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nchar](20) NOT NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_sources] PRIMARY KEY CLUSTERED 
(
	[sourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[levels](
	[levelId] [tinyint] IDENTITY(1,1) NOT NULL,
	[descripcion] [nchar](25) NOT NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_levels] PRIMARY KEY CLUSTERED 
(
	[levelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[eventTypes](
	[eventTypeId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nchar](20) NOT NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_eventTypes] PRIMARY KEY CLUSTERED 
(
	[eventTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[objectTypes](
	[objectTypeId] [tinyint] IDENTITY(1,1) NOT NULL,
	[objectName] [nchar](15) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
	[computer] [varchar](20) NOT NULL,
	[username] [varchar](20) NOT NULL,
	[checksum] [varbinary](150) NOT NULL,
 CONSTRAINT [PK_objectTypes] PRIMARY KEY CLUSTERED 
(
	[objectTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[eventLogs]  WITH CHECK ADD  CONSTRAINT [FK_eventLogs_eventTypes] FOREIGN KEY([eventTypeId])
REFERENCES [dbo].[eventTypes] ([eventTypeId])
GO
ALTER TABLE [dbo].[eventLogs] CHECK CONSTRAINT [FK_eventLogs_eventTypes]
GO
ALTER TABLE [dbo].[eventLogs]  WITH CHECK ADD  CONSTRAINT [FK_eventLogs_levels] FOREIGN KEY([levelId])
REFERENCES [dbo].[levels] ([levelId])
GO
ALTER TABLE [dbo].[eventLogs] CHECK CONSTRAINT [FK_eventLogs_levels]
GO
ALTER TABLE [dbo].[eventLogs]  WITH CHECK ADD  CONSTRAINT [FK_eventLogs_objectTypes] FOREIGN KEY([objectTypeId])
REFERENCES [dbo].[objectTypes] ([objectTypeId])
GO
ALTER TABLE [dbo].[eventLogs] CHECK CONSTRAINT [FK_eventLogs_objectTypes]
GO
ALTER TABLE [dbo].[eventLogs]  WITH CHECK ADD  CONSTRAINT [FK_eventLogs_sources] FOREIGN KEY([sourceId])
REFERENCES [dbo].[sources] ([sourceId])
GO
ALTER TABLE [dbo].[eventLogs] CHECK CONSTRAINT [FK_eventLogs_sources]
GO

INSERT INTO [dbo].[levels] ([descripcion], [enabled])
VALUES ('Information', 1),
('Warning', 1),
('Error', 1);

INSERT INTO [dbo].[sources] ([nombre], [enabled])
VALUES ('Recolección', 1),
('Venta', 1),
('Producción', 1),
('Contrato', 1),
('Sistema', 1),
('Base de datos', 1);

INSERT INTO [dbo].[eventTypes] ([nombre], [enabled])
VALUES ('Insert', 1),
('Update', 1),
('Delete', 1),
('Select', 1);

INSERT INTO objectTypes (objectName, createdAt, computer, username, checksum) VALUES
('Dirección', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Ciudad', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Estado', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('País', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Región', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Local', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Productor', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Recolector', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Participante', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Recipiente', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Producto', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Lote', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Desecho', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Contacto', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Contrato Prod', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Contrato Reco', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Contrato Conta', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Factura', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Item Producto', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Item Ganancia', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Item Reco', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Item Conta', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT')),
('Viaje', GETDATE(), 'computer1', 'user1', HASHBYTES('SHA2_256', 'SQL SERVER INSERT'))