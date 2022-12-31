SELECT
 lower(substring(repo_name, 1, position(repo_name, '/'))) AS org,
 uniq(repo_name) AS repos
FROM
(
 SELECT repo_name
 FROM github_events
 WHERE event_type = 'WatchEvent'
 GROUP BY repo_name
 HAVING count() >= 10
)
GROUP BY org
ORDER BY repos DESC
LIMIT 50;
