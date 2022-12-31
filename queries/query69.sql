WITH arrayJoin(labels) AS label
SELECT
 sum(label ILIKE '%bug%') AS bugs,
 sum(label ILIKE '%feature%') AS features,
 bugs / features AS ratio
FROM github_events
WHERE (event_type IN ('IssuesEvent', 'PullRequestEvent', 'IssueCommentEvent')) AND (action IN ('created', 'opened', 'labeled')) AND ((label ILIKE '%bug%') OR (label ILIKE '%feature%'));
