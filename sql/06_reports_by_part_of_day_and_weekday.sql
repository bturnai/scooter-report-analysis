-- 06 | Average daily reports by weekday and part of day
with partOfDay_notofications as (
select 
	--Extract(isodow from "InsertedAt") as day_of_week,
	TO_CHAR("InsertedAt", 'FMDay') AS day_name,
	--EXTRACT(HOUR from  "InsertedAt") as hour_of_day,
	case 
		when cast("InsertedAt" as TIME) <= '06:00:00' then 'Dawn'
		when cast("InsertedAt" as TIME) <= '12:00:00' then 'Morning'
		when cast("InsertedAt" as TIME) <= '18:00:00' then 'Afternoon'
		else 'Night'
	end as categoryName,
	cast("InsertedAt" as date),
	count("Description")
from 
	"scooter_ops".municipal
group by 
	1,2,3)


select 
	day_name,
	categoryname ,
	Round(AVG(count), 2)
from
	partOfDay_notofications
group by
	1,2
order by 
	3 desc ;
