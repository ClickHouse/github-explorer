SELECT
 repo AS name,
 groupArrayInsertAt(toUInt32(c), toUInt64(dateDiff('month', toDate('2015-01-01'), month))) AS data
FROM
(
 SELECT
  lower(repo_name) AS repo,
  toStartOfMonth(created_at) AS month,
  count() AS c
 FROM github_events
 WHERE (event_type = 'WatchEvent') AND (toYear(created_at) >= 2015) AND (repo IN
 (
  SELECT lower(repo_name) AS repo
  FROM github_events
  WHERE (event_type = 'WatchEvent') AND (toYear(created_at) >= 2015)
  GROUP BY repo
  ORDER BY count() DESC
  LIMIT 10
 ))
 GROUP BY
 repo,
 month
)
GROUP BY repo
ORDER BY repo ASC
;
