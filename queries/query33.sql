SELECT repo_name, count(), uniq(actor_login) FROM github_events WHERE event_type = 'PullRequestEvent' AND action = 'opened' GROUP BY repo_name ORDER BY count() DESC LIMIT 50;
