SELECT
 year,
 lower(repo_name) AS repo,
 count()
FROM github_events
WHERE (event_type = 'WatchEvent') AND (year >= 2015)
GROUP BY
 repo,
 toYear(created_at) AS year
ORDER BY
 year ASC,
 count() DESC
LIMIT 10 BY year;
