-- Query 1:

SELECT count() FROM github_events WHERE event_type = 'WatchEvent';


-- Query 2:

SELECT action, count() FROM github_events WHERE event_type = 'WatchEvent' GROUP BY action;


-- Query 3:

SELECT count() FROM github_events WHERE event_type = 'WatchEvent' AND repo_name IN ('ClickHouse/ClickHouse', 'yandex/ClickHouse') GROUP BY action;


-- Query 4:

SELECT repo_name, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' GROUP BY repo_name ORDER BY stars DESC LIMIT 50;


-- Query 5:

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


-- Query 6:

SELECT uniq(repo_name) FROM github_events;


-- Query 7:

SELECT repo_name, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' AND toYear(created_at) = '2020' GROUP BY repo_name ORDER BY stars DESC LIMIT 50;


-- Query 8:

SELECT repo_name, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' AND toYear(created_at) = '2019' GROUP BY repo_name ORDER BY stars DESC LIMIT 50;


-- Query 9:

SELECT repo_name, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' AND toYear(created_at) = '2018' GROUP BY repo_name ORDER BY stars DESC LIMIT 50;


-- Query 10:

SELECT repo_name, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' AND toYear(created_at) = '2017' GROUP BY repo_name ORDER BY stars DESC LIMIT 50;


-- Query 11:

SELECT repo_name, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' AND toYear(created_at) = '2016' GROUP BY repo_name ORDER BY stars DESC LIMIT 50;


-- Query 12:

SELECT repo_name, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' AND toYear(created_at) = '2015' GROUP BY repo_name ORDER BY stars DESC LIMIT 50;


-- Query 13:

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


-- Query 14:

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


-- Query 15:

SELECT toYear(created_at) AS year, count() AS stars, bar(stars, 0, 50000000, 10) AS bar FROM github_events WHERE event_type = 'WatchEvent' GROUP BY year ORDER BY year;


-- Query 16:

SELECT actor_login, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' GROUP BY actor_login ORDER BY stars DESC LIMIT 50;


-- Query 17:

SELECT actor_login, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' AND actor_login = 'alexey-milovidov' GROUP BY actor_login ORDER BY stars DESC LIMIT 50;


-- Query 18:

SELECT
 repo_name,
 count() AS stars
FROM github_events
WHERE (event_type = 'WatchEvent') AND (repo_name IN
(
 SELECT repo_name
 FROM github_events
 WHERE (event_type = 'WatchEvent') AND (actor_login = 'alexey-milovidov')
))
GROUP BY repo_name
ORDER BY stars DESC
LIMIT 50;


-- Query 19:

SELECT
 repo_name,
 count() AS stars
FROM github_events
WHERE (event_type = 'WatchEvent') AND (actor_login IN
(
 SELECT actor_login
 FROM github_events
 WHERE (event_type = 'WatchEvent') AND (repo_name IN ('ClickHouse/ClickHouse', 'yandex/ClickHouse'))
)) AND (repo_name NOT IN ('ClickHouse/ClickHouse', 'yandex/ClickHouse'))
GROUP BY repo_name
ORDER BY stars DESC
LIMIT 50;


-- Query 20:

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


-- Query 21:

SELECT
 repo_name,
 uniq(actor_login) AS total_stars,
 uniqIf(actor_login, actor_login IN
 (
  SELECT actor_login
  FROM github_events
  WHERE (event_type = 'WatchEvent') AND (repo_name IN ('torvalds/linux'))
 )) AS clickhouse_stars,
 round(clickhouse_stars / total_stars, 2) AS ratio
FROM github_events
WHERE (event_type = 'WatchEvent') AND (repo_name NOT IN ('torvalds/linux'))
GROUP BY repo_name
HAVING total_stars >= 100
ORDER BY ratio DESC
LIMIT 50;


-- Query 22:

SELECT
 repo_name,
 uniq(actor_login) AS total_stars,
 uniqIf(actor_login, actor_login IN
 (
  SELECT actor_login
  FROM github_events
  WHERE (event_type = 'WatchEvent') AND (repo_name IN ('llvm/llvm-project'))
 )) AS clickhouse_stars,
 round(clickhouse_stars / total_stars, 2) AS ratio
FROM github_events
WHERE (event_type = 'WatchEvent') AND (repo_name NOT IN ('llvm/llvm-project'))
GROUP BY repo_name
HAVING total_stars >= 100
ORDER BY ratio DESC
LIMIT 50;


-- Query 23:

WITH repo_name IN
 (
  SELECT repo_name
  FROM github_events
  WHERE (event_type = 'WatchEvent') AND (actor_login IN ('alexey-milovidov'))
 ) AS is_my_repo
SELECT
 actor_login,
 sum(is_my_repo) AS stars_my,
 sum(NOT is_my_repo) AS stars_other,
 round(stars_my / (196 + stars_other), 3) AS ratio
FROM github_events
WHERE event_type = 'WatchEvent'
GROUP BY actor_login
ORDER BY ratio DESC
LIMIT 50;


-- Query 24:

SELECT
 repo_name,
 count() AS prs,
 uniq(actor_login) AS authors
FROM github_events
WHERE (event_type = 'PullRequestEvent') AND (action = 'opened') AND (actor_login IN
(
 SELECT actor_login
 FROM github_events
 WHERE (event_type = 'PullRequestEvent') AND (action = 'opened') AND (repo_name IN ('yandex/ClickHouse', 'ClickHouse/ClickHouse'))
)) AND (repo_name NOT ILIKE '%ClickHouse%')
GROUP BY repo_name
ORDER BY authors DESC
LIMIT 50;


-- Query 25:

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


-- Query 26:

SELECT
 repo_name,
 toDate(created_at) AS day,
 count() AS stars
FROM github_events
WHERE event_type = 'WatchEvent'
GROUP BY
 repo_name,
 day
ORDER BY count() DESC
LIMIT 1 BY repo_name
LIMIT 50;


-- Query 27:

SELECT repo_name, created_at, count() AS stars FROM github_events WHERE event_type = 'WatchEvent' GROUP BY repo_name, created_at ORDER BY count() DESC LIMIT 50;


-- Query 28:

WITH toYear(created_at) AS year
SELECT
 repo_name,
 sum(year = 2020) AS stars2020,
 sum(year = 2019) AS stars2019,
 stars2020 / stars2019 AS yoy,
 min(created_at) AS first_seen
FROM github_events
WHERE event_type = 'WatchEvent'
GROUP BY repo_name
HAVING (min(created_at) <= '2019-01-01 00:00:00') AND (stars2019 >= 1000)
ORDER BY yoy DESC
LIMIT 50;


-- Query 29:

WITH toYear(created_at) AS year
SELECT
 repo_name,
 sum(year = 2020) AS stars2020,
 sum(year = 2019) AS stars2019,
 round(stars2020 / stars2019, 3) AS yoy,
 min(created_at) AS first_seen
FROM github_events
WHERE event_type = 'WatchEvent'
GROUP BY repo_name
HAVING (min(created_at) <= '2019-01-01 00:00:00') AND (max(created_at) >= '2020-06-01 00:00:00') AND (stars2019 >= 1000)
ORDER BY yoy ASC
LIMIT 50;


-- Query 30:

SELECT
 repo_name,
 max(stars) AS daily_stars,
 sum(stars) AS total_stars,
 total_stars / daily_stars AS rate
FROM
(
 SELECT
  repo_name,
  toDate(created_at) AS day,
  count() AS stars
 FROM github_events
 WHERE event_type = 'WatchEvent'
 GROUP BY
  repo_name,
  day
)
GROUP BY repo_name
ORDER BY rate DESC
LIMIT 50;


-- Query 31:

SELECT toDayOfWeek(created_at) AS day, count() AS stars, bar(stars, 0, 50000000, 10) AS bar FROM github_events WHERE event_type = 'WatchEvent' GROUP BY day ORDER BY day;


-- Query 32:

SELECT uniq(actor_login) FROM github_events;


-- Query 33:

SELECT uniq(actor_login) FROM github_events WHERE event_type = 'WatchEvent';


-- Query 34:

SELECT uniq(actor_login) FROM github_events WHERE event_type = 'PushEvent';


-- Query 35:

SELECT uniq(actor_login) FROM github_events WHERE event_type = 'PullRequestEvent' AND action = 'opened';


-- Query 36:

SELECT
 repo_name,
 count()
FROM github_events
WHERE (event_type = 'WatchEvent') AND (actor_login IN
(
 SELECT actor_login
 FROM github_events
 WHERE (event_type = 'PullRequestEvent') AND (action = 'opened')
))
GROUP BY repo_name
ORDER BY count() DESC
LIMIT 50;


-- Query 37:

SELECT
 repo_name,
 count()
FROM github_events
WHERE (event_type = 'WatchEvent') AND (actor_login IN
(
 SELECT actor_login
 FROM github_events
 WHERE (event_type = 'PullRequestEvent') AND (action = 'opened')
 GROUP BY actor_login
 HAVING count() >= 10
))
GROUP BY repo_name
ORDER BY count() DESC
LIMIT 50;


-- Query 38:

SELECT repo_name, count(), uniq(actor_login) FROM github_events WHERE event_type = 'PullRequestEvent' AND action = 'opened' GROUP BY repo_name ORDER BY count() DESC LIMIT 50;


-- Query 39:

SELECT repo_name, count(), uniq(actor_login) AS u FROM github_events WHERE event_type = 'PullRequestEvent' AND action = 'opened' GROUP BY repo_name ORDER BY u DESC LIMIT 50;


-- Query 40:

SELECT repo_name, count() AS c, uniq(actor_login) AS u FROM github_events WHERE event_type = 'IssuesEvent' AND action = 'opened' GROUP BY repo_name ORDER BY c DESC LIMIT 50;


-- Query 41:

WITH (event_type = 'IssuesEvent') AND (action = 'opened') AS issue_created
SELECT
 repo_name,
 sum(issue_created) AS c,
 uniqIf(actor_login, issue_created) AS u,
 sum(event_type = 'WatchEvent') AS stars
FROM github_events
WHERE event_type IN ('IssuesEvent', 'WatchEvent')
GROUP BY repo_name
ORDER BY c DESC
LIMIT 50;


-- Query 42:

WITH (event_type = 'IssuesEvent') AND (action = 'opened') AS issue_created
SELECT
 repo_name,
 sum(issue_created) AS c,
 uniqIf(actor_login, issue_created) AS u,
 sum(event_type = 'WatchEvent') AS stars
FROM github_events
WHERE event_type IN ('IssuesEvent', 'WatchEvent')
GROUP BY repo_name
HAVING stars >= 1000
ORDER BY c DESC
LIMIT 50;


-- Query 43:

WITH (event_type = 'IssuesEvent') AND (action = 'opened') AS issue_created
SELECT
 repo_name,
 sum(issue_created) AS c,
 uniqIf(actor_login, issue_created) AS u,
 sum(event_type = 'WatchEvent') AS stars
FROM github_events
WHERE event_type IN ('IssuesEvent', 'WatchEvent')
GROUP BY repo_name
ORDER BY u DESC
LIMIT 50;


-- Query 44:

SELECT repo_name, uniqIf(actor_login, event_type = 'PushEvent') AS u, sum(event_type = 'WatchEvent') AS stars FROM github_events WHERE event_type IN ('PushEvent', 'WatchEvent') AND repo_name != '/' GROUP BY repo_name ORDER BY u DESC LIMIT 50;


-- Query 45:

SELECT
 repo_name,
 uniqIf(actor_login, (event_type = 'PushEvent') AND match(ref, '/(main|master)$')) AS u,
 sum(event_type = 'WatchEvent') AS stars
FROM github_events
WHERE (event_type IN ('PushEvent', 'WatchEvent')) AND (repo_name != '/')
GROUP BY repo_name
ORDER BY u DESC
LIMIT 50;


-- Query 46:

SELECT
 repo_name,
 uniqIf(actor_login, (event_type = 'PushEvent') AND match(ref, '/(main|master)$')) AS u,
 sum(event_type = 'WatchEvent') AS stars
FROM github_events
WHERE (event_type IN ('PushEvent', 'WatchEvent')) AND (repo_name != '/')
GROUP BY repo_name
HAVING stars >= 100
ORDER BY u DESC
LIMIT 50;


-- Query 47:

SELECT repo_name, sum(event_type = 'MemberEvent') AS invitations, sum(event_type = 'WatchEvent') AS stars FROM github_events WHERE event_type IN ('MemberEvent', 'WatchEvent') GROUP BY repo_name HAVING stars >= 100 ORDER BY invitations DESC LIMIT 50;


-- Query 48:

SELECT repo_name, count() AS forks FROM github_events WHERE event_type = 'ForkEvent' GROUP BY repo_name ORDER BY forks DESC LIMIT 50;


-- Query 49:

SELECT
 repo_name,
 sum(event_type = 'ForkEvent') AS forks,
 sum(event_type = 'WatchEvent') AS stars,
 round(stars / forks, 3) AS ratio
FROM github_events
WHERE event_type IN ('ForkEvent', 'WatchEvent')
GROUP BY repo_name
ORDER BY forks DESC
LIMIT 50;


-- Query 50:

SELECT
 repo_name,
 sum(event_type = 'ForkEvent') AS forks,
 sum(event_type = 'WatchEvent') AS stars,
 round(stars / forks, 2) AS ratio
FROM github_events
WHERE event_type IN ('ForkEvent', 'WatchEvent')
GROUP BY repo_name
HAVING (stars > 100) AND (forks > 100)
ORDER BY ratio DESC
LIMIT 50;


-- Query 51:

SELECT
 repo_name,
 sum(event_type = 'ForkEvent') AS forks,
 sum(event_type = 'WatchEvent') AS stars,
 round(forks / stars, 2) AS ratio
FROM github_events
WHERE event_type IN ('ForkEvent', 'WatchEvent')
GROUP BY repo_name
HAVING (stars > 100) AND (forks > 100)
ORDER BY ratio DESC
LIMIT 50;


-- Query 52:

SELECT sum(event_type = 'ForkEvent') AS forks, sum(event_type = 'WatchEvent') AS stars, round(stars / forks, 2) AS ratio FROM github_events WHERE event_type IN ('ForkEvent', 'WatchEvent');


-- Query 53:

SELECT
 sum(stars) AS stars,
 sum(forks) AS forks,
 round(stars / forks, 2) AS ratio
FROM
(
 SELECT
  sum(event_type = 'ForkEvent') AS forks,
  sum(event_type = 'WatchEvent') AS stars
 FROM github_events
 WHERE event_type IN ('ForkEvent', 'WatchEvent')
 GROUP BY repo_name
 HAVING stars > 100
);


-- Query 54:

SELECT count() FROM github_events WHERE event_type = 'IssueCommentEvent';


-- Query 55:

SELECT repo_name, count() FROM github_events WHERE event_type = 'IssueCommentEvent' GROUP BY repo_name ORDER BY count() DESC LIMIT 50;


-- Query 56:

SELECT
 repo_name,
 count() AS comments,
 uniq(number) AS issues,
 round(comments / issues, 2) AS ratio
FROM github_events
WHERE event_type = 'IssueCommentEvent'
GROUP BY repo_name
ORDER BY count() DESC
LIMIT 50;


-- Query 57:

SELECT
 repo_name,
 number,
 count() AS comments
FROM github_events
WHERE (event_type = 'IssueCommentEvent') AND (action = 'created')
GROUP BY
 repo_name,
 number
ORDER BY count() DESC
LIMIT 50;


-- Query 58:

SELECT
 repo_name,
 number,
 count() AS comments
FROM github_events
WHERE (event_type = 'IssueCommentEvent') AND (action = 'created') AND (number > 10)
GROUP BY
 repo_name,
 number
ORDER BY count() DESC
LIMIT 50;


-- Query 59:

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
ORDER BY count() DESC
LIMIT 50;


-- Query 60:

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


-- Query 61:

SELECT
 repo_name,
 count() AS comments,
 uniq(actor_login) AS authors
FROM github_events
WHERE event_type = 'CommitCommentEvent'
GROUP BY repo_name
ORDER BY count() DESC
LIMIT 50;


-- Query 62:

SELECT
 concat('https://github.com/', repo_name, '/commit/', commit_id) AS URL,
 count() AS comments,
 uniq(actor_login) AS authors
FROM github_events
WHERE (event_type = 'CommitCommentEvent') AND notEmpty(commit_id)
GROUP BY
 repo_name,
 commit_id
HAVING authors >= 10
ORDER BY count() DESC
LIMIT 50;


-- Query 63:

SELECT
 concat('https://github.com/', repo_name, '/pull/', toString(number)) AS URL,
 uniq(actor_login) AS authors
FROM github_events
WHERE (event_type = 'PullRequestReviewCommentEvent') AND (action = 'created')
GROUP BY
 repo_name,
 number
ORDER BY authors DESC
LIMIT 50;


-- Query 64:

SELECT
 actor_login,
 count() AS c,
 uniq(repo_name) AS repos
FROM github_events
WHERE event_type = 'PushEvent'
GROUP BY actor_login
ORDER BY c DESC
LIMIT 50;


-- Query 65:

SELECT
 actor_login,
 sum(event_type = 'PushEvent') AS c,
 uniqIf(repo_name, event_type = 'PushEvent') AS repos,
 sum(event_type = 'IssuesEvent') AS issues,
 sum(event_type = 'WatchEvent') AS stars,
 anyHeavy(repo_name)
FROM github_events
WHERE (event_type IN ('PushEvent', 'IssuesEvent', 'WatchEvent')) AND (repo_name IN
(
 SELECT repo_name
 FROM github_events
 WHERE event_type = 'WatchEvent'
 GROUP BY repo_name
 ORDER BY count() DESC
 LIMIT 10000
))
GROUP BY actor_login
HAVING (repos < 10000) AND (issues > 1) AND (stars > 1)
ORDER BY c DESC
LIMIT 50;


-- Query 66:

SELECT
 lower(substring(repo_name, 1, position(repo_name, '/'))) AS org,
 count() AS stars
FROM github_events
WHERE event_type = 'WatchEvent'
GROUP BY org
ORDER BY stars DESC
LIMIT 50;


-- Query 67:

SELECT
 lower(substring(repo_name, 1, position(repo_name, '/'))) AS org,
 uniq(repo_name) AS repos
FROM
(
 SELECT repo_name
 FROM github_events
 WHERE event_type = 'WatchEvent'
 GROUP BY repo_name
 HAVING count() >= 10
)
GROUP BY org
ORDER BY repos DESC
LIMIT 50;


-- Query 68:

SELECT
 lower(substring(repo_name, 1, position(repo_name, '/'))) AS org,
 uniq(actor_login) AS authors,
 uniqIf(actor_login, event_type = 'PullRequestEvent') AS pr_authors,
 uniqIf(actor_login, event_type = 'IssuesEvent') AS issue_authors,
 uniqIf(actor_login, event_type = 'IssueCommentEvent') AS comment_authors,
 uniqIf(actor_login, event_type = 'PullRequestReviewCommentEvent') AS review_authors,
 uniqIf(actor_login, event_type = 'PushEvent') AS push_authors
FROM github_events
WHERE event_type IN ('PullRequestEvent', 'IssuesEvent', 'IssueCommentEvent', 'PullRequestReviewCommentEvent', 'PushEvent')
GROUP BY org
ORDER BY authors DESC
LIMIT 50;


-- Query 69:

SELECT
 repo_name,
 count() AS prs,
 uniq(actor_login) AS authors,
 sum(additions) AS adds,
 sum(deletions) AS dels
FROM github_events
WHERE (event_type = 'PullRequestEvent') AND (action = 'opened') AND (additions < 10000) AND (deletions < 10000)
GROUP BY repo_name
HAVING (adds / dels) < 10
ORDER BY adds + dels DESC
LIMIT 50;


-- Query 70:

SELECT
 repo_name,
 count() AS pushes,
 uniq(actor_login) AS authors
FROM github_events
WHERE (event_type = 'PushEvent') AND (repo_name IN
(
 SELECT repo_name
 FROM github_events
 WHERE event_type = 'WatchEvent'
 GROUP BY repo_name
 ORDER BY count() DESC
 LIMIT 10000
))
GROUP BY repo_name
ORDER BY count() DESC
LIMIT 50;


-- Query 71:

SELECT
 actor_login,
 count(),
 uniq(repo_name) AS repos,
 uniq(repo_name, number) AS prs,
 replaceRegexpAll(substringUTF8(anyHeavy(body), 1, 100), '[\r\n]', ' ') AS comment
FROM github_events
WHERE (event_type = 'PullRequestReviewCommentEvent') AND (action = 'created')
GROUP BY actor_login
ORDER BY count() DESC
LIMIT 50;


-- Query 72:

SELECT
 arrayJoin(labels) AS label,
 count() AS c
FROM github_events
WHERE (event_type IN ('IssuesEvent', 'PullRequestEvent', 'IssueCommentEvent')) AND (action IN ('created', 'opened', 'labeled'))
GROUP BY label
ORDER BY c DESC
LIMIT 50;


-- Query 73:

SELECT
 arrayJoin(labels) AS label,
 count() AS c
FROM github_events
WHERE (event_type IN ('IssuesEvent', 'PullRequestEvent', 'IssueCommentEvent')) AND (action IN ('created', 'opened', 'labeled')) AND ((label ILIKE '%bug%') OR (label ILIKE '%feature%'))
GROUP BY label
ORDER BY c DESC
LIMIT 50;


-- Query 74:

WITH arrayJoin(labels) AS label
SELECT
 sum(label ILIKE '%bug%') AS bugs,
 sum(label ILIKE '%feature%') AS features,
 bugs / features AS ratio
FROM github_events
WHERE (event_type IN ('IssuesEvent', 'PullRequestEvent', 'IssueCommentEvent')) AND (action IN ('created', 'opened', 'labeled')) AND ((label ILIKE '%bug%') OR (label ILIKE '%feature%'));


-- Query 75:

SELECT count(), repo_name FROM github_events WHERE event_type = 'WatchEvent' GROUP BY repo_name ORDER BY length(repo_name) DESC LIMIT 50;


-- Query 76:

SELECT repo_name, count() FROM github_events WHERE event_type = 'WatchEvent' GROUP BY repo_name ORDER BY length(repo_name) ASC LIMIT 50;


-- Query 77:

SELECT repo_name, count() FROM github_events WHERE body ILIKE '%ClickHouse%' GROUP BY repo_name ORDER BY count() DESC LIMIT 50;


-- Query 78:

SELECT
 repo_name,
 sum(event_type = 'WatchEvent') AS num_stars,
 sum(body ILIKE '%ClickHouse%') AS num_comments
FROM github_events
WHERE (body ILIKE '%ClickHouse%') OR (event_type = 'WatchEvent')
GROUP BY repo_name
HAVING num_comments > 0
ORDER BY num_stars DESC
LIMIT 50;


-- Query 79:

SELECT * FROM github_events WHERE body ILIKE '%ClickHouse%' AND repo_name = '996icu/996.ICU';


-- Query 80:

SELECT body, count() FROM github_events WHERE notEmpty(body) AND length(body) < 100 GROUP BY body ORDER BY count() DESC LIMIT 50;


-- Query 81:

SELECT repo_name FROM github_events WHERE event_type = 'WatchEvent' ORDER BY rand() LIMIT 50;


