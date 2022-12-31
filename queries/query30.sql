SELECT uniq(actor_login) FROM github_events WHERE event_type = 'PullRequestEvent' AND action = 'opened';
