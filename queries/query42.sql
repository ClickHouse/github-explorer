SELECT repo_name, sum(event_type = 'MemberEvent') AS invitations, sum(event_type = 'WatchEvent') AS stars FROM github_events WHERE event_type IN ('MemberEvent', 'WatchEvent') GROUP BY repo_name HAVING stars >= 100 ORDER BY invitations DESC LIMIT 50;
