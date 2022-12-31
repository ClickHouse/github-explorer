SELECT
 lower(substring(repo_name, 1, position(repo_name, '/'))) AS org,
 count() AS stars
FROM github_events
WHERE event_type = 'WatchEvent'
GROUP BY org
ORDER BY stars DESC
LIMIT 50;
