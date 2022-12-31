SELECT
 repo_name,
 number,
 count() AS comments,
 uniq(actor_login) AS authors
FROM github_events
WHERE (event_type = 'IssueCommentEvent') AND (action = 'created') AND (number > 10)
GROUP BY
 repo_name,
 number
HAVING authors >= 10
ORDER BY count() DESC
LIMIT 50;
