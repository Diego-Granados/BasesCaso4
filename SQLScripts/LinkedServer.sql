USE [master]
GO

/****** Object:  LinkedServer [PREDATOR\MSSQLSERVER01]    Script Date: 5/26/2023 7:17:31 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'PREDATOR\MSSQLSERVER01', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'PREDATOR\MSSQLSERVER01',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'PREDATOR\MSSQLSERVER01',@useself=N'False',@locallogin=N'NT SERVICE\SQLSERVERAGENT',@rmtuser=N'sa',@rmtpassword='Twinsociety235'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'PREDATOR\MSSQLSERVER01', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


