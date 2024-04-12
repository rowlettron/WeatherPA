USE NewWeather
GO

/*
 * DROP PROC dbo.usp_MergeForecast
 */

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].usp_MergeForecast') )
BEGIN
    DROP PROC dbo.usp_MergeForecast
    PRINT '<<< DROPPED PROC dbo.usp_MergeForecast IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
GO

CREATE PROC dbo.usp_MergeForecast
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
        MERGE dbo.Forecast AS t 
        USING dbo.Forecast_Stage AS s 
            ON s.postalcode = t.postalcode
            AND s.time_epoch = t.time_epoch 


        WHEN MATCHED THEN

        UPDATE SET time = s.time,
                temp_c = s.temp_c,
                temp_f = s.temp_f,
                is_day = s.is_day,
                wind_mph = s.wind_mph,
                wind_kph = s.wind_kph,
                wind_degree = s.wind_degree,
                wind_dir = s.wind_dir,
                pressure_mb = s.pressure_mb,
                pressure_in = s.pressure_in,
                precip_mm = s.precip_mm,
                precip_in = s.precip_in,
                snow_cm = s.snow_cm,
                humidity = s.humidity,
                cloud = s.cloud,
                feelslike_c = s.feelslike_c,
                feelslike_f = s.feelslike_f,
                windchill_c = s.windchill_c,
                windchill_f = s.windchill_f,
                heatindex_c = s.heatindex_c,
                heatindex_f = s.heatindex_f,
                dewpoint_c = s.dewpoint_c,
                dewpoint_f = s.dewpoint_f,
                will_it_rain = s.will_it_rain,
                chance_of_rain = s.chance_of_rain,
                will_it_snow = s.will_it_snow,
                chance_of_snow = s.chance_of_snow,
                vis_km = s.vis_km,
                vis_miles = s.vis_miles,
                gust_mph = s.gust_mph,
                gust_kph = s.gust_kph,
                uv = s.uv,
                conditions = s.conditions,
                icon = s.icon,
                code = s.code, 
                sunrise = s.sunrise,
                sunset = s.sunset,
                moonrise = s.moonrise,
                moonset = s.moonset,
                moon_phase = s.moon_phase,
                moon_illumination = s.moon_illumination,
                is_moon_up = s.is_moon_up,
                is_sun_up = s.is_sun_up

        WHEN NOT MATCHED THEN 

        INSERT(postalcode,
            time_epoch,
            time,
            temp_c,
            temp_f,
            is_day,
            wind_mph,
            wind_kph,
            wind_degree,
            wind_dir,
            pressure_mb, 
            pressure_in,
            precip_mm,
            precip_in,
            snow_cm,
            humidity,
            cloud,
            feelslike_c,
            feelslike_f, 
            windchill_f,
            windchill_c,
            heatindex_c,
            heatindex_f,
            dewpoint_c,
            dewpoint_f,
            will_it_rain,
            chance_of_rain,
            will_it_snow,
            chance_of_snow,
            vis_km,
            vis_miles,
            gust_mph,
            gust_kph,
            uv, 
            conditions,
            icon,
            code,
            sunrise,
            sunset,
            moonrise, 
            moonset,
            moon_phase,
            moon_illumination,
            is_moon_up,
            is_sun_up)
        VALUES (s.postalcode,
            s.time_epoch,
            s.time,
            s.temp_c,
            s.temp_f,
            is_day,
            s.wind_mph,
            s.wind_kph,
            s.wind_degree,
            s.wind_dir,
            s.pressure_mb, 
            s.pressure_in,
            s.precip_mm,
            s.precip_in,
            s.snow_cm,
            s.humidity,
            s.cloud,
            s.feelslike_c,
            s.feelslike_f, 
            s.windchill_f,
            s.windchill_c,
            s.heatindex_c,
            s.heatindex_f,
            s.dewpoint_c,
            s.dewpoint_f,
            s.will_it_rain,
            s.chance_of_rain,
            s.will_it_snow,
            s.chance_of_snow,
            s.vis_km,
            s.vis_miles,
            s.gust_mph,
            s.gust_kph,
            s.uv, 
            s.conditions,
            s.icon,
            s.code,
            s.sunrise,
            s.sunset,
            s.moonrise, 
            s.moonset,
            s.moon_phase,
            s.moon_illumination,
            s.is_moon_up,
            s.is_sun_up);
    END TRY
    BEGIN CATCH
        SELECT 'Location Merge' AS TableName,
               ERROR_NUMBER() AS ErrorNumber,
               ERROR_MESSAGE() AS ErrorMessage
    END CATCH;
END 
GO

IF EXISTS (SELECT 1
           FROM sys.procedures
           WHERE object_id = OBJECT_ID('[dbo].usp_MergeForecast') )
BEGIN
    PRINT '<<< CREATED PROC dbo.usp_MergeForecast IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.usp_MergeForecast IN ' + db_name() + ' ON ' + @@servername + '  >>>'
GO
