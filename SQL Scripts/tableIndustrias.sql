-----------------------------------------------------------
-- Autor: Daniel Granados
-- Fecha: 6/3/2023
-- Descripción: Crea la tabla de industrias
-----------------------------------------------------------

CREATE TABLE [dbo].[industrias](
	[industriaId] tinyint IDENTITY(1,1) NOT NULL,
	[nombreId] [int] NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_industrias] PRIMARY KEY CLUSTERED 
(
	[industriaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[industrias]  WITH CHECK ADD  CONSTRAINT [FK_industrias_nombres] FOREIGN KEY([nombreId])
REFERENCES [dbo].[nombres] ([nombreId])
GO

ALTER TABLE [dbo].[industrias] CHECK CONSTRAINT [FK_industrias_nombres]
GO


ALTER TABLE productores
ADD industriaId tinyint NULL

ALTER TABLE productores
ADD CONSTRAINT FK_productores_industrias FOREIGN KEY (industriaId)
REFERENCES industrias (industriaId)
ON DELETE NO ACTION
ON UPDATE NO ACTION


INSERT INTO [dbo].[nombres]
           ([nombreBase]
           ,[idiomaId]
           ,[enabled])
     VALUES
           ('Alimentos'
           ,2
           ,1),
		   ('Tecnología'
           ,2
           ,1),
		   ('Manufactura'
           ,2
           ,1),
		   ('E-Commerce'
           ,2
           ,1)
GO

INSERT INTO [dbo].[industrias]
           ([nombreId]
           ,[enabled])
     VALUES
           (124
           ,1),
		   (125
           ,1),
		   (126
           ,1),
		   (127
           ,1)
GO


UPDATE [dbo].[productores]
   SET [industriaId] = 1
 WHERE productorId IN (1,4)


UPDATE [dbo].[productores]
   SET [industriaId] = 2
 WHERE productorId IN (3,5)

 UPDATE [dbo].[productores]
   SET [industriaId] = 3
 WHERE productorId IN (6)
 
 UPDATE [dbo].[productores]
   SET [industriaId] = 4
 WHERE productorId IN (2)