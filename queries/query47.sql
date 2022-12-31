SELECT sum(event_type = 'ForkEvent') AS forks, sum(event_type = 'WatchEvent') AS stars, round(stars / forks, 2) AS ratio FROM github_events WHERE event_type IN ('ForkEvent', 'WatchEvent');
