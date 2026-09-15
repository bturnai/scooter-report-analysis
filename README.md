# Scooter Report Analysis

SQL analysis of one year of municipal scooter-removal reports from a scooter-sharing service in Budapest, joined to daily weather. It asks which districts generate the most removals, how that ranking moves month to month, and how weather changes the number of removals per day.

- **Case study:** https://bturnai.lovable.app/scooter-report-analysis
- **Interactive dashboard:** https://public.tableau.com/views/UrbanScooterOperations/Dashboard1

## Findings

- Removals are concentrated in a few districts. District V. has 349 reports over the year, District VI. 157 and District XIII. 133.
- The weather effect is non-linear. Per day, removals peak in the cold band (0 to 10 C) and on days with very light rain. Sub-zero days and days with significant rain are the quietest.

## Method

The weather queries compare reports per day within each weather band. Raw counts would make a rare condition look small only because it occurs on fewer days. The join starts from the weather table (`LEFT JOIN`), so days with zero reports still count in the denominator.

## Data

The report data comes from a real scooter-sharing company. It is anonymised and is not included in this repository. The queries run against two PostgreSQL tables in the `scooter_ops` schema:

| Table | Contents |
|---|---|
| `municipal` | One row per municipal removal report: report time (`InsertedAt`), number of scooters (`Count`), cost (`Price`) and a free-text `Description` whose first token is the district |
| `budapestweather` | Daily Budapest weather: date (`datetime`), temperature, precipitation and conditions |

## Files

Run in order:

| File | What it does |
|---|---|
| `sql/01_municipal_cleaning.sql` | Profiles the report table, drops unused columns, removes `Price = 0` rows as recording errors, extracts the district and casts the timestamp |
| `sql/02_weather_cleaning.sql` | Profiles the weather table, drops unused columns, converts temperature to Celsius and precipitation to a number |
| `sql/03_district_monthly_rank.sql` | Total reports per district, and a monthly district ranking with month-over-month change (`RANK()`, `LAG()`) |
| `sql/04_reports_per_day_by_temperature.sql` | Average reports per day in each temperature band |
| `sql/05_reports_per_day_by_precipitation.sql` | Average reports per day in each precipitation band |
| `sql/06_reports_by_part_of_day_and_weekday.sql` | Average daily reports by weekday and part of day |
| `sql/07_busiest_days_with_weather.sql` | Days with more than five reports, matched to their weather |
| `sql/08_exploration_raw_counts.sql` | Early raw-count queries by weather and time of day, kept for reference. Files 04 and 05 replace them with per-day rates |

## Limitations

- Weather is joined at day level, so a morning shower is credited to reports filed on a dry afternoon.
- Per-worker productivity cannot be measured reliably, because shifts with no report do not appear in the data.
- Exact figures depend on the year analysed.

## Stack

PostgreSQL, Tableau Public
