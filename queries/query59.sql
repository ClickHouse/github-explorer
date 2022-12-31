SELECT
 actor_login,
 count() AS c,
 uniq(repo_name) AS repos
FROM github_events
WHERE event_type = 'PushEvent'
GROUP BY actor_login
ORDER BY c DESC
LIMIT 50;
