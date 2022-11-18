--Code tham khảo
--DATE: 07/10/2021

--IF @iMSLOAICV IS NULL
	--	SET @iMSLOAICV = 0	

	--IF @iMSCQ IS NULL
	--	SET @iMSCQ = 0
	
	--IF @iMSGIAIDOAN IS NULL
	--	SET @iMSGIAIDOAN = 0

--CREATE PROC USP_XoaCongvan 
--	@stMSCV NVARCHAR(20) =''
--AS
--BEGIN
--	IF ((SELECT MSCVGIAOVIEC FROM dbo.tGiaoViec WHERE MSCVGIAOVIEC = @stMSCV)>0)
--		DELETE FROM dbo.tGiaoViec WHERE MSCVGIAOVIEC = @stMSCV
--	DELETE FROM dbo.tCongVan WHERE MSCV = @stMSCV
--END
--GO

--alter PROC USP_TaotSoCVDen --tSoCV phải có dữ liệu mới nhất
--AS
--BEGIN
--	IF (EXISTS(select * from INFORMATION_SCHEMA.TABLES where table_name='tSoCVDen'))
--		DROP TABLE tSoCVDen
--	SELECT * INTO tSoCVDen FROM UVW_SoCVDen
--END
--go

--alter PROC USP_TaotSoCVDi --tSoCV phải có dữ liệu mới nhất
--AS
--BEGIN
--	IF (EXISTS(select * from INFORMATION_SCHEMA.TABLES where table_name='tSoCVDi'))
--		DROP TABLE tSoCVDi
--	SELECT * INTO tSoCVDi FROM UVW_SoCVDi
--END
--GO

--alter PROC USP_TaotSoCV -- Input: UVW_SoCV; Output: tSoCVDi và tSoCVDen
--AS
--BEGIN
--	IF (EXISTS(select * from INFORMATION_SCHEMA.TABLES where table_name='tSoCV'))
--		DROP TABLE tSoCV
--	SELECT * INTO tSoCV FROM dbo.tSoCVDen 
--	INSERT INTO tSoCV SELECT * FROM dbo.tSoCVDi
--END
--GO

---- Tạo View
--CREATE VIEW UVW_SoCV
--AS SELECT *, MSCV AS [COL0], SOCV AS [COL1], dbo.fConvertToUnsign(NOIDUNG) AS [COL2] FROM tCongVan WHERE PHEDUYET =1 OR LEFT(MSCV,1)='F'
--GO
--CREATE VIEW UVW_SoCVDen
--AS SELECT *, MSCV AS [COL0], SOCV AS [COL1], dbo.fConvertToUnsign(NOIDUNG) AS [COL2] FROM tCongVan WHERE LEFT(MSCV,1)='F'
--GO
--CREATE VIEW UVW_SoCVDi
--AS SELECT *, MSCV AS [COL0], SOCV AS [COL1], dbo.fConvertToUnsign(NOIDUNG) AS [COL2] FROM tCongVan WHERE PHEDUYET =1 AND LEFT(MSCV,1)='T'
--GO

-- ***** CHẠY LỆNH BCP CỦA MS.DOS *****

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




