SELECT
 repo_name,
 count() AS comments,
 uniq(number) AS issues,
 round(comments / issues, 2) AS ratio
FROM github_events
WHERE event_type = 'IssueCommentEvent'
GROUP BY repo_name
ORDER BY count() DESC
LIMIT 50;
