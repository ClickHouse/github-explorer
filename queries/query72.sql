SELECT repo_name, count() FROM github_events WHERE body ILIKE '%ClickHouse%' GROUP BY repo_name ORDER BY count() DESC LIMIT 50;
