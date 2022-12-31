SELECT
 repo_name,
 count() AS prs,
 uniq(actor_login) AS authors
FROM github_events
WHERE (event_type = 'IssuesEvent') AND (action = 'opened') AND (actor_login IN
(
 SELECT actor_login
 FROM github_events
 WHERE (event_type = 'IssuesEvent') AND (action = 'opened') AND (repo_name IN ('yandex/ClickHouse', 'ClickHouse/ClickHouse'))
)) AND (repo_name NOT ILIKE '%ClickHouse%')
GROUP BY repo_name
ORDER BY authors DESC
LIMIT 50;
