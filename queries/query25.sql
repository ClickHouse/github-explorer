SELECT
 repo_name,
 max(stars) AS daily_stars,
 sum(stars) AS total_stars,
 round(total_stars / daily_stars, 2) AS rate
FROM
(
 SELECT
  repo_name,
  toDate(created_at) AS day,
  count() AS stars
 FROM github_events
 WHERE event_type = 'WatchEvent'
 GROUP BY
  repo_name,
  day
)
GROUP BY repo_name
ORDER BY rate DESC
LIMIT 50;
