WITH toYear(created_at) AS year
SELECT
 repo_name,
 sum(year = 2020) AS stars2020,
 sum(year = 2019) AS stars2019,
 round(stars2020 / stars2019, 3) AS yoy,
 min(created_at) AS first_seen
FROM github_events
WHERE event_type = 'WatchEvent'
GROUP BY repo_name
HAVING (min(created_at) <= '2019-01-01 00:00:00') AND (max(created_at) >= '2020-06-01 00:00:00') AND (stars2019 >= 1000)
ORDER BY yoy ASC
LIMIT 50;
