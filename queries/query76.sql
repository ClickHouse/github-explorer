SELECT repo_name FROM github_events WHERE event_type = 'WatchEvent' ORDER BY rand() LIMIT 50;
