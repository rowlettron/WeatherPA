USE NewWeather
GO

/*
 * DROP PROC dbo.usp_MergeLocation
 */

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].usp_MergeLocation') )
BEGIN
    DROP PROC dbo.usp_MergeLocation
    PRINT '<<< DROPPED PROC dbo.usp_MergeLocation IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
GO

CREATE PROC dbo.usp_MergeLocation
AS

/*************************************************************************************************
 *  Object Type:               Stored Procedure
 *  Function:
 *  Created By:
 *  Create Date:
 *  Maintenance Log:
 *  Date          Modified By             Description
 *  ----------    --------------------    ---------------------------------------------------------
 **************************************************************************************************/
BEGIN
    MERGE dbo.Location AS t 
    USING dbo.Location_Stage AS S 
        ON s.postalcode = t.postalcode 

    WHEN MATCHED THEN 

    UPDATE SET city = s.city,
               state = s.state,
               country = s.country,
               latitude = s.latitude,
               longitude = s.longitude,
               timezone = s.timezone,
               localtime_epoch = s.localtime_epoch,
               local_time = s.localtime,
               modifydate = getdate()

    WHEN NOT MATCHED THEN 
    INSERT (postalcode,
            city,
            state,
            country,
            latitude,
            longitude,
            timezone,
            localtime_epoch,
            local_time)
    VALUES (s.postalcode,
            s.city,
            s.state,
            s.country,
            s.latitude,
            s.longitude,
            s.timezone,
            s.localtime_epoch,
            cast(s.localtime as datetime) )
            
    ;
            
END
GO

IF EXISTS (SELECT 1
           FROM sys.procedures
           WHERE object_id = OBJECT_ID('[dbo].usp_MergeLocation') )
BEGIN
    PRINT '<<< CREATED PROC dbo.usp_MergeLocation IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.usp_MergeLocation IN ' + db_name() + ' ON ' + @@servername + '  >>>'
GO
