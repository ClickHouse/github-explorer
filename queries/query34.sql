SELECT repo_name, count(), uniq(actor_login) AS u FROM github_events WHERE event_type = 'PullRequestEvent' AND action = 'opened' GROUP BY repo_name ORDER BY u DESC LIMIT 50;
