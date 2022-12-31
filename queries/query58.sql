SELECT
 concat('https://github.com/', repo_name, '/pull/', toString(number)) AS URL,
 uniq(actor_login) AS authors
FROM github_events
WHERE (event_type = 'PullRequestReviewCommentEvent') AND (action = 'created')
GROUP BY
 repo_name,
 number
ORDER BY authors DESC
LIMIT 50;
