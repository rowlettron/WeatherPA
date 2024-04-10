import pandas as pd
import json
import os
from sys import platform
from pathlib import Path

pd.options.mode.chained_assignment = None

if platform == "darwin":
    folder = "/Users/ron/OneDrive/Training/Hadoop/WeatherFiles/"
else:
    folder = "C:\Source\GitHub\WeatherPA/"
    
ext = "json"

def create_base_dataframe(folder, filename):
    file = folder + filename
    with open(file) as f:
        data = json.load(f)
    
    df = pd.json_normalize(data)
    
    return df, data

def export_location(df, folder, filename):
    #file = filename.split('.')[0]
    file = Path(filename).stem
    
    export_file = folder +'Location/' + file + '.csv'
    df_location = df[['location.name','location.region','location.country','location.lat','location.lon','location.tz_id','location.localtime_epoch','location.localtime']]
    
    df_location.rename(columns = {'location.name':'city',
                              'location.region':'state',
                              'location.country':'country',
                              'location.lat':'latitude',
                              'location.lon':'longitude',
                              'location.tz_id':'timezone',
                              'location.localtime_epoch':'localtime_epoch',
                              'location.localtime':'localtime'}, inplace = True)

    df_location.insert(0, 'PostalCode', file)

    df_location.to_csv(export_file,index=False,encoding="ascii")


def export_current(df, folder, filename):
    file = filename.split('.')[0]
    export_file = folder +'Current/' + file + '.csv'
    
    df_current = df[['current.last_updated_epoch',
                'current.last_updated',
                'current.temp_c',
                'current.temp_f',
                'current.is_day',
                'current.condition.text',
                'current.wind_mph',
                'current.wind_kph',
                'current.wind_degree',
                'current.wind_dir',
                'current.pressure_mb',
                'current.pressure_in',
                'current.precip_mm',
                'current.precip_in',
                'current.humidity',
                'current.cloud',
                'current.feelslike_c',
                'current.feelslike_f',
                'current.vis_km',
                'current.vis_miles',
                'current.uv',
                'current.gust_kph',
                'current.gust_mph']]
    
    df_current.rename(columns = {'current.last_updated_epoch':'lastupdated_epoch',
                             'current.last_updated':'lastupdated',
                             'current.temp_c':'temp_c',
                             'current.temp_f':'temp_f',
                             'current.is_day':'is_day',
                             'current.condition.text':'current_conditions',
                             'current.wind_mph':'wind_mph',
                             'current.wind_kph':'wind_kph',
                             'current.wind_degree':'wind_degree',
                             'current.wind_dir':'wind_dir',
                             'current.pressure_mb':'pressure_mb',
                             'current.pressure_in':'pressure_in',
                             'current.precip_mm':'precip_mm',
                             'current.precip_in':'precip_in',
                             'current.humidity':'humidity',
                             'current.cloud':'cloud',
                             'current.feelslike_c':'feelslike_c',
                             'current.feelslike_f':'feelslike_f',
                             'current.vis_km':'vis_km',
                             'current.vis_miles':'vis_miles',
                             'current.uv':'uv',
                             'current.gust_kph':'gust_kph',
                             'current.gust_mph':'gust_mph'}, inplace=True)
    
    df_current.insert(0, 'PostalCode', file)
    
    df_current.to_csv(export_file,index=False,encoding="ascii")

def export_forecast(data, folder, filename):
    file = filename.split('.')[0]
    export_file = folder +'Forecast/' + file + '.csv'
    
    df_forecast = pd.json_normalize(data,
                       record_path=['forecast','forecastday','hour'],
                       meta=[
                             ['forecast','forecastday','astro','sunrise'], 
                             ['forecast','forecastday','astro','sunset'],
                             ['forecast','forecastday','astro','moonrise'],
                             ['forecast','forecastday','astro','moonset'],
                             ['forecast','forecastday','astro','moon_phase'],
                             ['forecast','forecastday','astro','moon_illumination'],
                             ['forecast','forecastday','astro','is_moon_up'],
                             ['forecast','forecastday','astro','is_sun_up']])
    
    df_forecast.rename(columns = {'condition.text':'conditions',
                                'condition.icon':'icon',
                                'condition.code':'code',
                                'forecast.forecastday.astro.sunrise':'sunrise',
                                'forecast.forecastday.astro.sunset':'sunset',
                                'forecast.forecastday.astro.moonrise':'moonrise',
                                'forecast.forecastday.astro.moonset':'moonset',
                                'forecast.forecastday.astro.moon_phase':'moon_phase',
                                'forecast.forecastday.astro.moon_illumination':'moon_illumination',
                                'forecast.forecastday.astro.is_moon_up':'is_moon_up',
                                'forecast.forecastday.astro.is_sun_up':'is_sun_up'}, inplace = True)
    
    df_forecast.insert(0, 'PostalCode', file)
    
    df_forecast.to_csv(export_file,index=False,encoding="ascii")

for filename in os.listdir(folder):
    f = os.path.join(folder, filename)
    if filename.endswith(ext):
        print(filename)
        df, data = create_base_dataframe(folder, filename)
        
        export_location(df, folder, filename)
        
        export_current(df, folder, filename)
        
        export_forecast(data, folder, filename)
        
    else:
        continue