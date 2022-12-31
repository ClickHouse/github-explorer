SELECT
 sum(stars) AS stars,
 sum(forks) AS forks,
 round(stars / forks, 2) AS ratio
FROM
(
 SELECT
  sum(event_type = 'ForkEvent') AS forks,
  sum(event_type = 'WatchEvent') AS stars
 FROM github_events
 WHERE event_type IN ('ForkEvent', 'WatchEvent')
 GROUP BY repo_name
 HAVING stars > 100
);
