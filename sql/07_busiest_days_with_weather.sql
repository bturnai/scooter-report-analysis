-- 07 | Days with more than five reports, with that day's weather
with daily_count as (select
		count(m."Description") as count,
		cast(m."InsertedAt" as date) as notification_day
	from 
		"scooter_ops".municipal m
	group by 
		2)
select 
	dc.notification_day,
	b.temp_c as temperature_c,
	b.uvindex,
	b.precip as precipitation,
	b.conditions ,
	dc.count
from 
	daily_count dc,
	"scooter_ops".budapestweather b
where
	cast(b.datetime as date)= cast(dc.notification_day as date) and 
	dc.count > 5
order by 
--	dc.count desc;
	2 desc;
