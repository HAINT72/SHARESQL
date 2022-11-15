-- show advanced options
EXEC sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO
-- enable xp_cmdshell
EXEC sp_configure 'xp_cmdshell', 1
GO
RECONFIGURE
GO
-- hide advanced options
EXEC sp_configure 'show advanced options', 0
GO
RECONFIGURE
GO
--------------------------
DECLARE @sql nvarchar(4000) = ''
SET @sql = N'bcp "Select * From [DESKTOP-U30OAKD].[ManagerStudent].[dbo].Student Where Sex = 1" queryout "D:\Solution\SQL\SQLExtra\ExportExcel\Export.xls" -w -T -S DESKTOP-U30OAKD -U sa -P 123456'
print @sql
exec master..xp_cmdshell @sql


---------------export xlsx use ACE.OLEDB.12.0
INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=D:\Solution\SQL\SQLExtra\ExportExcel\ExportExcelC2.xlsx;', 'SELECT * FROM [Sheet1$]')
SELECT * FROM [DESKTOP-U30OAKD].[ManagerStudent].[dbo].Student where Name = N'Dương Quốc Hiệp'
