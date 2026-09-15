-- 05 | Average reports per day in each precipitation band
--
-- Needs the precipitation conversion at the end of 02_weather_cleaning.sql.
-- Same method as 04: LEFT JOIN from the weather table, reports divided by days.
select 
	case
		when precip =0 then 'a) dry'
		when precip <0.098 then 'b) very light rain'
		when precip < 0.3 then 'c) light rain'
		else 'e) significant rain'
	end as precip_band,
	count(distinct b.datetime ) as days_per_year,
	count(m."InsertedAt") as announcements,
	Round(
		count(m."InsertedAt")::numeric / 
		count(distinct b.datetime)::numeric ,3) as avg_announcement
from 
	"scooter_ops".budapestweather b 
left join
	"scooter_ops".municipal m 
	on cast(b.datetime  as date) =cast(m."InsertedAt"  as date)
where 
	b.datetime >= '2025-07-08' and
	b.datetime < '2026-07-08'
group by 
	1
order by 
	1
;
