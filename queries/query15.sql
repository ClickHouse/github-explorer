SELECT
 repo_name,
 uniq(actor_login) AS total_stars,
 uniqIf(actor_login, actor_login IN
 (
  SELECT actor_login
  FROM github_events
  WHERE (event_type = 'WatchEvent') AND (repo_name IN ('ClickHouse/ClickHouse', 'yandex/ClickHouse'))
 )) AS clickhouse_stars,
 round(clickhouse_stars / total_stars, 2) AS ratio
FROM github_events
WHERE (event_type = 'WatchEvent') AND (repo_name NOT IN ('ClickHouse/ClickHouse', 'yandex/ClickHouse'))
GROUP BY repo_name
HAVING total_stars >= 100
ORDER BY ratio DESC
LIMIT 50;
