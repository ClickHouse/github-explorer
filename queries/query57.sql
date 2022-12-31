SELECT
 concat('https://github.com/', repo_name, '/commit/', commit_id) AS URL,
 count() AS comments,
 uniq(actor_login) AS authors
FROM github_events
WHERE (event_type = 'CommitCommentEvent') AND notEmpty(commit_id)
GROUP BY
 repo_name,
 commit_id
HAVING authors >= 10
ORDER BY count() DESC
LIMIT 50;
