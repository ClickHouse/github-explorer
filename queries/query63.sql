SELECT
 lower(substring(repo_name, 1, position(repo_name, '/'))) AS org,
 uniq(actor_login) AS authors,
 uniqIf(actor_login, event_type = 'PullRequestEvent') AS pr_authors,
 uniqIf(actor_login, event_type = 'IssuesEvent') AS issue_authors,
 uniqIf(actor_login, event_type = 'IssueCommentEvent') AS comment_authors,
 uniqIf(actor_login, event_type = 'PullRequestReviewCommentEvent') AS review_authors,
 uniqIf(actor_login, event_type = 'PushEvent') AS push_authors
FROM github_events
WHERE event_type IN ('PullRequestEvent', 'IssuesEvent', 'IssueCommentEvent', 'PullRequestReviewCommentEvent', 'PushEvent')
GROUP BY org
ORDER BY authors DESC
LIMIT 50;
