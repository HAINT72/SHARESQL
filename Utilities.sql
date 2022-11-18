/* CÁC PROC VÀ HÀM TIỆN ÍCH (SỬ DỤNG CHUNG) */
USE QLHS_HP
GO

CREATE PROC USP_CopyFileBySQL @stFileSource NVARCHAR(MAX), @stFileDest NVARCHAR(MAX)
AS
BEGIN
	-- Bật chế độ sử dụng lệnh xp_cmdshell
	EXEC master.dbo.sp_configure 'show advanced options', 1
	RECONFIGURE WITH OVERRIDE
	EXEC master.dbo.sp_configure 'xp_cmdshell', 1
	RECONFIGURE WITH OVERRIDE
	--Copy file
	DECLARE @cmd NVARCHAR(4000)
	SET @cmd = N'copy ' + N'"'+ @stFileSource + N'" "' +  @stFileDest + N'"'
	EXEC xp_cmdshell @cmd, no_output
	-- Tắt chế độ sử dụng lệnh xp_cmdshell
	EXEC master.dbo.sp_configure 'xp_cmdshell', 0
	RECONFIGURE WITH OVERRIDE
	EXEC master.dbo.sp_configure 'show advanced options', 0
	RECONFIGURE WITH OVERRIDE
END
GO

CREATE PROC USP_RenameFileBySQL @stPathFileFull NVARCHAR(MAX), @stFileName NVARCHAR(MAX)
AS
BEGIN
	-- Bật chế độ sử dụng lệnh xp_cmdshell
	EXEC master.dbo.sp_configure 'show advanced options', 1
	RECONFIGURE WITH OVERRIDE
	EXEC master.dbo.sp_configure 'xp_cmdshell', 1
	RECONFIGURE WITH OVERRIDE
	--Rename file
	DECLARE @cmd NVARCHAR(4000)
	SET @cmd = N'rename ' + N'"'+ @stPathFileFull + N'" "' +  @stFileName + N'"'
	EXEC xp_cmdshell @cmd, no_output
	-- Tắt chế độ sử dụng lệnh xp_cmdshell
	EXEC master.dbo.sp_configure 'xp_cmdshell', 0
	RECONFIGURE WITH OVERRIDE
	EXEC master.dbo.sp_configure 'show advanced options', 0
	RECONFIGURE WITH OVERRIDE
END
GO

CREATE PROC USP_DeleteFileBySQL @stPathFileFull NVARCHAR(MAX)
AS
BEGIN
	-- Bật chế độ sử dụng lệnh xp_cmdshell
	EXEC master.dbo.sp_configure 'show advanced options', 1
	RECONFIGURE WITH OVERRIDE
	EXEC master.dbo.sp_configure 'xp_cmdshell', 1
	RECONFIGURE WITH OVERRIDE
	--Delete file
	DECLARE @cmd NVARCHAR(4000)
	SET @cmd = N'del /F ' + N'"'+ @stPathFileFull + N'"'
	EXEC xp_cmdshell @cmd, no_output
	-- Tắt chế độ sử dụng lệnh xp_cmdshell
	EXEC master.dbo.sp_configure 'xp_cmdshell', 0
	RECONFIGURE WITH OVERRIDE
	EXEC master.dbo.sp_configure 'show advanced options', 0
	RECONFIGURE WITH OVERRIDE
END
GO

CREATE PROC USP_ExportData
-- Xuất dữ liệu ra file
-- Ví dụ: exec USP_ExportData 'select * from [qlhs_hp].dbo.tCongVan', 'd:\t1.xls', 'sa', 'nth12345'
	@stQueryWithDatabaseName NVARCHAR(MAX), 
	@stPathFileName NVARCHAR(MAX),
	@stUserName NVARCHAR(MAX),
	@stPassword NVARCHAR(MAX)
AS
BEGIN
	-- show advanced options
	EXEC master.dbo.sp_configure 'show advanced options', 1
	RECONFIGURE WITH OVERRIDE
	EXEC master.dbo.sp_configure 'xp_cmdshell', 1
	RECONFIGURE WITH OVERRIDE

	--Export Data
	DECLARE @sql nvarchar(4000)	
	SET @sql = 'bcp "' + @stQueryWithDatabaseName + '" queryout "' + @stPathFileName + '" -w -S "' + @@SERVERNAME + '" -U ' + @stUserName + ' -P ' + @stPassword
	exec master..xp_cmdshell @sql

	-- hide xp_cmdshell
	EXEC master.dbo.sp_configure 'xp_cmdshell', 0
	RECONFIGURE WITH OVERRIDE
	EXEC master.dbo.sp_configure 'show advanced options', 0
	RECONFIGURE WITH OVERRIDE
END
GO

CREATE FUNCTION dbo.fConvertToUnsign (@strInput NVARCHAR(4000)) RETURNS NVARCHAR(4000) AS 
BEGIN 
	
	IF @strInput IS NULL RETURN @strInput 
	
	IF @strInput = '' RETURN @strInput 
	
	DECLARE @RT NVARCHAR(4000) 
	
	DECLARE @SIGN_CHARS NCHAR(136) 
	
	DECLARE @UNSIGN_CHARS NCHAR (136) 
	
	SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) 
	
	SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' 
	
	DECLARE @COUNTER int 
	
	DECLARE @COUNTER1 int 
	
	SET @COUNTER = 1 
	WHILE (@COUNTER <=LEN(@strInput)) 
	BEGIN 
		SET @COUNTER1 = 1 
		
		WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) 
		BEGIN 
			IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) 
			BEGIN 
			IF @COUNTER=1 
				SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) 
			ELSE 
				SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) 
			BREAK 
			END 
			SET @COUNTER1 = @COUNTER1 +1 
		END 
		
		SET @COUNTER = @COUNTER +1 
	END

	RETURN @strInput
END
GO

CREATE FUNCTION dbo.fGetExtFileName(@stFileName NVARCHAR(MAX)) RETURNS NVARCHAR(20) AS 
BEGIN
	SET @stFileName = REVERSE(@stFileName)
	DECLARE @i INT
	SET @i = CHARINDEX('.', @stFileName,  1)
	RETURN REVERSE(LEFT(@stFileName,@i))	  
END
GO