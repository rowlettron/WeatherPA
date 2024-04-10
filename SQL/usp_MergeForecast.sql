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
            AND s.forecast_date = t.forecast_date

        WHEN MATCHED THEN

        UPDATE SET maxtemp_c = s.maxtemp_c,
                maxtemp_f = s.maxtemp_f,
                mintemp_c = s.mintemp_c,
                mintemp_f = s.mintemp_f,
                avgtemp_c = s.avgtemp_c,
                avgtemp_f = s.avgtemp_f,
                maxwind_mph = s.maxwind_mph,
                maxwind_kph = s.maxwind_kph,
                totalprecip_mm = s.totalprecip_mm,
                totalprecip_in = s.totalprecip_in,
                totalsnow_cm = s.totalsnow_cm,
                totalsnow_in = s.totalsnow_in,
                avgvis_km = s.avgvis_km,
                avgvis_miles = s.avgvis_miles,
                avghumidity = s.avghumidity, 
                daily_will_it_rain = s.daily_will_it_rain,
                daily_chance_of_rain = s.daily_chance_of_rain,
                daily_will_it_snow = s.daily_chance_of_snow,
                daily_conditions = s.daily_conditions,
                daily_conditions_icon = s.daily_conditions_icon,
                daily_conditions_code = s.daily_conditions_code,
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
            createddate,
            forecast_date,
            forecast_date_epoch,
            maxtemp_c,
            maxtemp_f,
            mintemp_c,
            mintemp_f,
            avgtemp_c,
            avgtemp_f,
            maxwind_mph,
            maxwind_kph,
            totalprecip_mm,
            totalprecip_in,
            totalsnow_cm,
            totalsnow_in,
            avgvis_km,
            avgvis_miles,
            avghumidity,
            daily_will_it_rain,
            daily_chance_of_rain,
            daily_will_it_snow,
            daily_chance_of_snow,
            daily_conditions,
            daily_conditions_icon,
            daily_conditions_code,
            sunrise,
            sunset,
            moonrise, 
            moonset,
            moon_phase,
            moon_illumination,
            is_moon_up,
            is_sun_up)
        VALUES (s.postalcode,
                s.createddate,
                s.forecast_date,
                s.forecast_date_epoch,
                maxtemp_c,
                maxtemp_f,
                mintemp_c,
                mintemp_f,
                avgtemp_c,
                avgtemp_f,
                maxwind_mph,
                maxwind_kph,
                totalprecip_mm,
                totalprecip_in,
                totalsnow_cm,
                totalsnow_in,
                avgvis_km,
                avgvis_miles,
                avghumidity,
                daily_will_it_rain,
                daily_chance_of_rain,
                daily_will_it_snow,
                daily_chance_of_snow,
                daily_conditions,
                daily_conditions_icon,
                daily_conditions_code,
                sunrise,
                sunset,
                moonrise,
                moonset,
                moon_phase,
                moon_illumination,
                is_moon_up,
                is_sun_up);
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
