SELECT
 repo_name,
 sum(event_type = 'WatchEvent') AS num_stars,
 sum(body ILIKE '%ClickHouse%') AS num_comments
FROM github_events
WHERE (body ILIKE '%ClickHouse%') OR (event_type = 'WatchEvent')
GROUP BY repo_name
HAVING num_comments > 0
ORDER BY num_stars DESC
LIMIT 50;
