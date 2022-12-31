WITH (event_type = 'IssuesEvent') AND (action = 'opened') AS issue_created
SELECT
 repo_name,
 sum(issue_created) AS c,
 uniqIf(actor_login, issue_created) AS u,
 sum(event_type = 'WatchEvent') AS stars
FROM github_events
WHERE event_type IN ('IssuesEvent', 'WatchEvent')
GROUP BY repo_name
HAVING stars >= 1000
ORDER BY c DESC
LIMIT 50;
