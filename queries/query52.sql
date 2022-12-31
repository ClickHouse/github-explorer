SELECT
 repo_name,
 number,
 count() AS comments
FROM github_events
WHERE (event_type = 'IssueCommentEvent') AND (action = 'created')
GROUP BY
 repo_name,
 number
ORDER BY count() DESC
LIMIT 50;
