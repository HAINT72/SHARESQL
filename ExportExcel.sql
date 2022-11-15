-- show advanced options
EXEC master.dbo.sp_configure 'show advanced options', 1
RECONFIGURE WITH OVERRIDE
EXEC master.dbo.sp_configure 'xp_cmdshell', 1
RECONFIGURE WITH OVERRIDE
--SELECT @@SERVERNAME
DECLARE @sql nvarchar(4000)
SET @sql = 'bcp "SELECT MSCV, SOCV, NGAYCV, NOIDUNG FROM dbo.tCongVan" queryout "D:\ExportData.xls" -w -S "HAINT\SQLEXPRESS" -U sa -P nth12345 -d "QLHS_HP"'
exec master..xp_cmdshell @sql
GO
-- hide xp_cmdshell
EXEC master.dbo.sp_configure 'xp_cmdshell', 0
RECONFIGURE WITH OVERRIDE
EXEC master.dbo.sp_configure 'show advanced options', 0
RECONFIGURE WITH OVERRIDE


