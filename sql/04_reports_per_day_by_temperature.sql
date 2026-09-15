-- 04 | Average reports per day in each temperature band
--
-- The join starts from the weather table, so days with no report still count
-- as days. Dividing by the number of days in each band keeps rare bands
-- comparable with common ones.
SELECT
    CASE
        WHEN b.temp_c < 0  THEN 'a) Freeze'
        WHEN b.temp_c < 10 THEN 'b) Cold (0-10 C)'
        WHEN b.temp_c < 20 THEN 'c) Cool (10-20 C)'
        WHEN b.temp_c < 25 THEN 'd) Warm (20-25 C)'
        ELSE 'e) above 25 C'
    END AS temp_band,
    COUNT(DISTINCT CAST(b.datetime AS DATE))  AS days_in_band,
    COUNT(m."InsertedAt")                      AS announcements,
    ROUND(COUNT(m."InsertedAt")::numeric
          / COUNT(DISTINCT CAST(b.datetime AS DATE)), 2) AS avg_per_day
FROM "scooter_ops".budapestweather b
LEFT JOIN "scooter_ops".municipal m
    ON CAST(m."InsertedAt" AS DATE) = CAST(b.datetime AS DATE)
WHERE b.datetime >= '2025-07-08'
  AND b.datetime <  '2026-07-08'
GROUP BY 1
ORDER BY 1;
