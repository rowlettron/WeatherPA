USE NewWeather;
GO

/*
 * DROP PROC dbo.usp_CopyLocationToStage
 */
IF EXISTS (
        SELECT *
        FROM sys.procedures
        WHERE object_id = OBJECT_ID('[dbo].usp_CopyLocationToStage')
        )
BEGIN
    DROP PROC dbo.usp_CopyLocationToStage

    PRINT '<<< DROPPED PROC dbo.usp_CopyLocationToStage IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
GO

CREATE PROC dbo.usp_CopyLocationToStage
AS
/*****************************************************************************
*  Object Type:	    Stored Procedure
*  Function:
*  Created By:
*  Create Date:
*  Input:
*  Output:
*  Maintenance Log:
*  Date          Modified By             Description
*  ----------    --------------------    -------------------------------------
******************************************************************************/
BEGIN
    SET NOCOUNT ON;

    DECLARE @cmd VARCHAR(8000),
        @location VARCHAR(255),
        @filename VARCHAR(255),
        @bulk_cmd VARCHAR(MAX),
        @TableName VARCHAR(130),
        @DBName VARCHAR(130)

    DROP TABLE IF EXISTS #files;
        CREATE TABLE #files (filename VARCHAR(255) NULL);

    SELECT @location = 'C:\Source\GitHub\WeatherPA\Location',
           @TableName = 'Location_Stage',
           @DBName = db_name();

    TRUNCATE TABLE dbo.Location_Stage;
    
    SELECT @cmd = 'dir /B ' + @location + '\*.csv';

    INSERT INTO #files (filename)
    EXEC xp_cmdshell @cmd;

    DELETE
    FROM #files
    WHERE filename IS NULL;

    WHILE (1 = 1)
    BEGIN
        SELECT TOP 1 @filename = filename
        FROM #files;

        IF @@rowcount = 0
            BREAK;

        DELETE
        FROM #files
        WHERE filename = @filename;

        PRINT @filename

        SELECT @bulk_cmd = 'BULK INSERT ' + @DBName + '.dbo.' + @TableName + '
        FROM ''' + @location + '\' + @filename + '''
        WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = '''+CHAR(10)+''')'


        print @bulk_cmd;

        BEGIN TRY
            -- print @bulk_cmd;

            EXEC (@bulk_cmd);
        END TRY
        BEGIN CATCH
            SELECT 'Location_Stage' as TableName,
                ERROR_NUMBER() as ErrorNumber,
                ERROR_MESSAGE() as ErrorMessage 
        END CATCH
        END;

    UPDATE dbo.Location_Stage 
    SET localtime = substring(localtime, 1, (len(localtime) - 1))

SET NOCOUNT OFF;       
END

GO

IF EXISTS (
        SELECT *
        FROM sys.procedures
        WHERE object_id = OBJECT_ID('[dbo].usp_CopyLocationToStage')
        )
BEGIN
    PRINT '<<< CREATED PROC dbo.usp_CopyLocationToStage IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.usp_CopyLocationToStage IN ' + db_name() + ' ON ' + @@servername + '  >>>'
GO


