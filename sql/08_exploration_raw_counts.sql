-- 08 | Early exploration with raw counts
--
-- These queries count reports without dividing by the number of days in each
-- group, so common conditions look bigger because they occur more often.
-- 04 and 05 replace the weather queries with per-day rates. This file is kept
-- to show the starting point.

-- Reports by weather condition
select 
	b."conditions", 
	Count(*) as notification_count
from 
	"scooter_ops".municipal m
join 	
	"scooter_ops".budapestweather b 
on 
	cast(m."InsertedAt" as Date) = cast(b.datetime as date)
group by 
	b.conditions 
order by 
	notification_count desc;

-- Reports by weather description
select 
	b."description", 
	Count(*) as notification_count
from 
	"scooter_ops".municipal m
join 	
	"scooter_ops".budapestweather b 
on 
	cast(m."InsertedAt" as Date) = cast(b.datetime as date)
group by 
	b.description 
order by 
	notification_count desc;

-- Reports by part of day
select 
	case 
		when cast("InsertedAt" as TIME) <= '06:00:00' then 'Dawn'
		when cast("InsertedAt" as TIME) <= '12:00:00' then 'Morning'
		when cast("InsertedAt" as TIME) <= '18:00:00' then 'Afternoon'
		else 'Night'
	end as categoryName,
	count(*)
from 
	"scooter_ops".municipal
group by 
	categoryname ;

-- Reports by temperature band, raw counts. Most reports fell between 0 and 15 C.
select 
	case
		when cast(b.temp_c as float)<= 0 then  'Freeze (<0)'
		when cast(b.temp_c as float)<= 5 then  'Lighter freeze (0-5)'
		when cast(b.temp_c as float)<= 10 then  'Cold (5-10)'
		when cast(b.temp_c as float)<= 15 then  'Light (10-15)'
		when cast(b.temp_c as float)<= 20 then  'Slightly warm (15-20)'
		when cast(b.temp_c as float)<= 25 then  'Warm (20-25)'
		else 'Hot (>25)'
	end temp_category,
	count(m."InsertedAt")
from 
	"scooter_ops".municipal m,
	"scooter_ops".budapestweather b
where 
	cast(m."InsertedAt" as date) = cast(b.datetime as date) and 
	m."InsertedAt" > '2025-07-08' and  
	m."InsertedAt" < '2026-07-08' 
group by 
	1
order by 2 desc;
