SELECT
 arrayJoin(labels) AS label,
 count() AS c
FROM github_events
WHERE (event_type IN ('IssuesEvent', 'PullRequestEvent', 'IssueCommentEvent')) AND (action IN ('created', 'opened', 'labeled')) AND ((label ILIKE '%bug%') OR (label ILIKE '%feature%'))
GROUP BY label
ORDER BY c DESC
LIMIT 50;
