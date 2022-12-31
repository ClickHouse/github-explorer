SELECT
 repo_name,
 sum(event_type = 'ForkEvent') AS forks,
 sum(event_type = 'WatchEvent') AS stars,
 round(stars / forks, 3) AS ratio
FROM github_events
WHERE event_type IN ('ForkEvent', 'WatchEvent')
GROUP BY repo_name
ORDER BY forks DESC
LIMIT 50;
