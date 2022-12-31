SELECT
 actor_login,
 sum(event_type = 'PushEvent') AS c,
 uniqIf(repo_name, event_type = 'PushEvent') AS repos,
 sum(event_type = 'IssuesEvent') AS issues,
 sum(event_type = 'WatchEvent') AS stars,
 anyHeavy(repo_name)
FROM github_events
WHERE (event_type IN ('PushEvent', 'IssuesEvent', 'WatchEvent')) AND (repo_name IN
(
 SELECT repo_name
 FROM github_events
 WHERE event_type = 'WatchEvent'
 GROUP BY repo_name
 ORDER BY count() DESC
 LIMIT 10000
))
GROUP BY actor_login
HAVING (repos < 10000) AND (issues > 1) AND (stars > 1)
ORDER BY c DESC
LIMIT 50;
