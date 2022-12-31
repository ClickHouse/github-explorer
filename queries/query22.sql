SELECT repo_name, created_at, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' GROUP BY repo_name, created_at ORDER BY count() DESC LIMIT 50;
