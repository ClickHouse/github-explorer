SELECT
 actor_login,
 count(),
 uniq(repo_name) AS repos,
 uniq(repo_name, number) AS prs,
 replaceRegexpAll(substringUTF8(anyHeavy(body), 1, 100), '[\r\n]', ' ') AS comment
FROM github_events
WHERE (event_type = 'PullRequestReviewCommentEvent') AND (action = 'created')
GROUP BY actor_login
ORDER BY count() DESC
LIMIT 50;
