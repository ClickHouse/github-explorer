SELECT
 repo_name,
 uniqIf(actor_login, (event_type = 'PushEvent') AND match(ref, '/(main|master)$')) AS u,
 sum(event_type = 'WatchEvent') AS stars
FROM github_events
WHERE (event_type IN ('PushEvent', 'WatchEvent')) AND (repo_name != '/')
GROUP BY repo_name
ORDER BY u DESC
LIMIT 50;
