WITH repo_name IN
 (
  SELECT repo_name
  FROM github_events
  WHERE (event_type = 'WatchEvent') AND (actor_login IN ('alexey-milovidov'))
 ) AS is_my_repo
SELECT
 actor_login,
 sum(is_my_repo) AS stars_my,
 sum(NOT is_my_repo) AS stars_other,
 round(stars_my / (196 + stars_other), 3) AS ratio
FROM github_events
WHERE event_type = 'WatchEvent'
GROUP BY actor_login
ORDER BY ratio DESC
LIMIT 50;
