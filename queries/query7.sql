SELECT repo_name, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' AND toYear(created_at) = {year:UInt16} GROUP BY repo_name ORDER BY stars DESC LIMIT 50;
