-- 03 | District totals and monthly district ranking

-- Total reports, scooters removed and average price per district
select 
	m."District",
	count(m."Count") as notification_count,
	sum(m."Count") as sum_roller,
	Round(Avg(m."Price"), 0)
from
	"scooter_ops".municipal m 
group by 
	m."District";

-- Monthly district ranking with the change against the previous month.
-- RANK() is partitioned by month, so districts compete within the same month.
-- LAG() is partitioned by district, so it reads that district's previous month.
WITH monthly AS (
    SELECT
        date_trunc('month', "InsertedAt") AS month,
        "District",
        SUM("Count") AS rollers_removed
    FROM "scooter_ops".municipal
    GROUP BY 1, 2
)
SELECT
    month,
    "District",
    rollers_removed,
    RANK() OVER (PARTITION BY month ORDER BY rollers_removed DESC) AS rank_in_month,
    rollers_removed - LAG(rollers_removed)
        OVER (PARTITION BY "District" ORDER BY month) AS change_vs_prev_month
FROM monthly
ORDER BY month, rank_in_month;
