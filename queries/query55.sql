SELECT
 concat('https://github.com/', repo_name, '/issues/', toString(number)) AS URL,
 max(comments),
 argMax(authors, comments) AS authors,
 argMax(number, comments) AS number,
 sum(stars) AS stars
FROM
(
 SELECT *
 FROM
 (
  SELECT
   repo_name,
   number,
   count() AS comments,
   uniq(actor_login) AS authors
  FROM github_events
  WHERE (event_type = 'IssueCommentEvent') AND (action = 'created') AND (number > 10)
  GROUP BY
   repo_name,
   number
  HAVING authors >= 10
 ) AS t1
 INNER JOIN
 (
  SELECT
   repo_name,
   count() AS stars
  FROM github_events
  WHERE event_type = 'WatchEvent'
  GROUP BY repo_name
  HAVING stars > 10000
 ) AS t2 USING (repo_name)
)
GROUP BY repo_name
ORDER BY stars DESC
LIMIT 50;
