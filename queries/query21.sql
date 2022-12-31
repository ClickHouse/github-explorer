SELECT
 repo_name,
 toDate(created_at) AS day,
 count() AS stars
FROM github_events
WHERE event_type = 'WatchEvent'
GROUP BY
 repo_name,
 day
ORDER BY count() DESC
LIMIT 1 BY repo_name
LIMIT 50;
