-- 02 | Clean the daily Budapest weather table
--
-- scooter_ops.budapestweather holds one row per day.

-- Raw table
SELECT 
	*
FROM "scooter_ops".budapestweather;

-- Generate the COUNT(DISTINCT ...) list for every column
SELECT 
    'COUNT(DISTINCT data."' || column_name || '") AS "' || column_name || '_distinct",'
FROM 
    information_schema.columns
WHERE 
    table_schema = 'scooter_ops' 
    AND table_name = 'budapestweather';

-- Distinct values per column
select 
	COUNT(DISTINCT data."datetime") AS "datetime_distinct",
	COUNT(DISTINCT data."tempmax") AS "tempmax_distinct",
	COUNT(DISTINCT data."tempmin") AS "tempmin_distinct",
	COUNT(DISTINCT data."temp") AS "temp_distinct",
	COUNT(DISTINCT data."feelslikemax") AS "feelslikemax_distinct",
	COUNT(DISTINCT data."feelslikemin") AS "feelslikemin_distinct",
	COUNT(DISTINCT data."feelslike") AS "feelslike_distinct",
	COUNT(DISTINCT data."dew") AS "dew_distinct",
	COUNT(DISTINCT data."humidity") AS "humidity_distinct",
	COUNT(DISTINCT data."precip") AS "precip_distinct",
	COUNT(DISTINCT data."precipprob") AS "precipprob_distinct",
	COUNT(DISTINCT data."precipcover") AS "precipcover_distinct",
	COUNT(DISTINCT data."preciptype") AS "preciptype_distinct",
	COUNT(DISTINCT data."snow") AS "snow_distinct",
	COUNT(DISTINCT data."snowdepth") AS "snowdepth_distinct",
	COUNT(DISTINCT data."windgust") AS "windgust_distinct",
	COUNT(DISTINCT data."windspeed") AS "windspeed_distinct",
	COUNT(DISTINCT data."winddir") AS "winddir_distinct",
	COUNT(DISTINCT data."sealevelpressure") AS "sealevelpressure_distinct",
	COUNT(DISTINCT data."cloudcover") AS "cloudcover_distinct",
	COUNT(DISTINCT data."visibility") AS "visibility_distinct",
	COUNT(DISTINCT data."solarradiation") AS "solarradiation_distinct",
	COUNT(DISTINCT data."solarenergy") AS "solarenergy_distinct",
	COUNT(DISTINCT data."uvindex") AS "uvindex_distinct",
	COUNT(DISTINCT data."severerisk") AS "severerisk_distinct",
	COUNT(DISTINCT data."sunrise") AS "sunrise_distinct",
	COUNT(DISTINCT data."sunset") AS "sunset_distinct",
	COUNT(DISTINCT data."moonphase") AS "moonphase_distinct",
	COUNT(DISTINCT data."conditions") AS "conditions_distinct",
	COUNT(DISTINCT data."description") AS "description_distinct",
	COUNT(DISTINCT data."icon") AS "icon_distinct",
	COUNT(DISTINCT data."stations") AS "stations_distinct"
from 	
	"scooter_ops".budapestweather data;

-- Drop a column with a single value
alter table 
	"scooter_ops".budapestweather 
--drop column "Column1",
--drop column "name"
drop column "stations";

-- Keep the daily average only, drop the min and max variants
alter table 
	"scooter_ops".budapestweather 
	drop column "tempmax",
	drop column "tempmin",
	drop column "feelslikemax",
	drop column "feelslikemin";

-- Distinct precipitation-probability values
select 	
	distinct b."precipprob"
from 
	"scooter_ops".budapestweather b;

-- Check that every temperature value converts to a number (decimal commas)
SELECT 
    REPLACE(b.temp, ',', '.')::FLOAT AS temp_float
FROM 
    "scooter_ops".budapestweather b;

-- Temperature arrives in Fahrenheit with decimal commas: add a Celsius column
ALTER TABLE "scooter_ops".budapestweather 
add temp_c float;

update "scooter_ops".budapestweather b 
set temp_c = 	round((REPLACE(b.temp, ',', '.')::FLOAT - 32) * 5/9,1);

update "scooter_ops".budapestweather b 
set temp_c = round(b.temp_c::numeric, 1);

-- Precipitation arrives as text with decimal commas: convert it to a number.
-- 05_reports_per_day_by_precipitation.sql depends on this.
ALTER TABLE "scooter_ops".budapestweather
    ALTER COLUMN precip TYPE float
    USING CAST(replace(precip, ',', '.') AS float);
