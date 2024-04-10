USE NewWeather
GO

/*
 * DROP PROC dbo.usp_MergeCurrentWeather
 */

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].usp_MergeCurrentWeather') )
BEGIN
    DROP PROC dbo.usp_MergeCurrentWeather
    PRINT '<<< DROPPED PROC dbo.usp_MergeCurrentWeather IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
GO

CREATE PROC dbo.usp_MergeCurrentWeather
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
    BEGIN TRY
        MERGE dbo.CurrentWeather AS t 

        USING dbo.CurrentWeather_Stage AS s 
            ON s.postalcode = t.postalcode

        WHEN MATCHED THEN 

        UPDATE SET lastupdated_epoch = s.lastupdated_epoch,
                   lastupdated = s.lastupdated,
                   tempcelsius = s.temp_c,
                   tempfahrenheit = s.temp_c,
                   isday = s.is_day,
                   currentconditions = s.current_conditions,
                   wind_kph = s.wind_kph,
                   wind_mph = s.wind_mph,
                   wind_degree = s.wind_degree,
                   wind_direction = s.wind_dir, 
                   barometricpressure_mb = s.pressure_mb,
                   barometricpressure_in = s.pressure_in,
                   precipitation_mm = s.precip_mm,
                   precipitation_in = s.precip_in,
                   current_humidity = s.humidity,
                   current_cloud = s.cloud,
                   currentfeelslike_celsius = s.feelslike_c,
                   currentfeelslike_fahrenheit = s.feelslike_f,
                   currentvisibility_km = s.vis_km,
                   currentvisibility_miles = vis_miles,
                   currentuvfactor = s.uv,
                   currentgusts_mph = s.gust_mph,
                   currentgusts_kph = s.gust_kph

        WHEN NOT MATCHED THEN 

        INSERT (postalcode,
                lastupdated_epoch,
                lastupdated,
                createddate,
                tempcelsius,
                tempfahrenheit,
                isday,
                currentconditions,
                wind_mph,
                wind_kph,
                wind_degree,
                wind_direction,
                barometricpressure_mb,
                barometricpressure_in,
                precipitation_mm,
                precipitation_in,
                current_humidity,
                current_cloud,
                currentfeelslike_celsius,
                currentfeelslike_fahrenheit,
                currentvisibility_km,
                currentvisibility_miles,
                currentuvfactor,
                currentgusts_mph,
                currentgusts_kph
                )
        VALUES (PostalCode,
                lastupdated_epoch,
                lastupdated,
                getdate(),
                temp_c,
                temp_f,
                is_day,
                current_conditions,
                wind_mph,
                wind_kph,
                wind_degree,
                wind_dir,
                pressure_mb,
                pressure_in,
                precip_mm,
                precip_in,
                humidity,
                cloud,
                feelslike_c,
                feelslike_f,
                vis_km,
                vis_miles,
                uv,
                gust_mph,
                gust_kph
        );


    END TRY
    BEGIN CATCH
        SELECT 'CurrentWeather' AS TableName,
               ERROR_NUMBER() AS ErrorNumber,
               ERROR_MESSAGE() AS ErrorMessage
    END CATCH;

END
GO

IF EXISTS (SELECT 1
           FROM sys.procedures
           WHERE object_id = OBJECT_ID('[dbo].usp_MergeCurrentWeather') )
BEGIN
    PRINT '<<< CREATED PROC dbo.usp_MergeCurrentWeather IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.usp_MergeCurrentWeather IN ' + db_name() + ' ON ' + @@servername + '  >>>'
GO
