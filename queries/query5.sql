SELECT
 exp10(floor(log10(c))) AS stars,
 uniq(k)
FROM
(
 SELECT
 repo_name AS k,
 count() AS c
 FROM github_events
 WHERE event_type = 'WatchEvent'
 GROUP BY k
)
GROUP BY stars
ORDER BY stars ASC;
