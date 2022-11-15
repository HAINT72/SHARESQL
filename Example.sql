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

-- Tạo Function