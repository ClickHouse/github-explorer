SELECT toDayOfWeek(created_at) AS day, count() AS stars, bar(stars, 0, 50000000, 10) AS bar FROM github_events WHERE event_type = 'WatchEvent' GROUP BY day ORDER BY day;
