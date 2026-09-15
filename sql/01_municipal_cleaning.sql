-- 01 | Clean the municipal removal-report table
--
-- scooter_ops.municipal holds one row per municipal removal report.
-- Run the statements in order.

-- Raw table
SELECT *
FROM "scooter_ops".municipal;

-- Distinct values per column, to find constant or irrelevant columns
SELECT 
    COUNT(DISTINCT data."Id") AS "Id_distinct",
	COUNT(DISTINCT data."WorkDataId") AS "WorkDataId_distinct",
	COUNT(DISTINCT data."TypeId") AS "TypeId_distinct",
	COUNT(DISTINCT data."Name") AS "Name_distinct",
	COUNT(DISTINCT data."Count") AS "Count_distinct",
	COUNT(DISTINCT data."Price") AS "Price_distinct",
	COUNT(DISTINCT data."Description") AS "Description_distinct",
	COUNT(DISTINCT data."Column8") AS "Column8_distinct",
	COUNT(DISTINCT data."PhotoTypeId") AS "PhotoTypeId_distinct",
	COUNT(DISTINCT data."InsertedAt") AS "InsertedAt_distinct",
	COUNT(DISTINCT data."IsCompleted") AS "IsCompleted_distinct",
	COUNT(DISTINCT data."PhysicallySaved") AS "PhysicallySaved_distinct"
FROM 
    "scooter_ops".municipal AS data;

-- Drop columns that hold a single value or have no analytical use
alter table 
"scooter_ops".municipal
drop column  TypeId,
drop column  name,
drop column  column8,
drop column  isCompleted,
drop column  physicallysaved,
drop column  phototypeid,
drop column  id;

-- Missing-value check on the columns the analysis uses
select 
	count(*)
from 
	"scooter_ops".municipal
where 
	"WorkDataId" is null or 
	"Count" is null or 
	"Price" is null or 
	"Description" is null or 
	"InsertedAt" is null ;

-- Date range of the reports
select 
	min("InsertedAt") as earlist_date,
	max("InsertedAt") as latest_date
from
	"scooter_ops".municipal;

-- Price distribution
select 
	min("Price"),
	max("Price"),
	AVG("Price")
from
	"scooter_ops".municipal;

-- Rows with Price = 0
select 
	*
from 
	"scooter_ops".municipal
where 
	"Price"=0 ;

-- A real removal always has a cost, so Price = 0 rows are recording errors
delete 
from 
	"scooter_ops".municipal
where 
	"Price"=0 ;

-- The district is the first token of Description: add a column for it
alter table 
	"scooter_ops".municipal 
add column	
	Discript varchar(5);

-- Cast the text timestamp to a real timestamp
ALTER TABLE "scooter_ops".municipal 
ALTER COLUMN "InsertedAt" TYPE timestamp USING "InsertedAt"::timestamp;

-- Fill the district column
update 
	"scooter_ops".municipal m
set 
	Discript = split_part(m."Description", ' ', 1);

-- Name the column
alter table 
	"scooter_ops".municipal 
rename discript to  "District";
