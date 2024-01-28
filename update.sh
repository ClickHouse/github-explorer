#!/bin/bash

source config

clickhouse-client $CLICKHOUSE_PLAY_PARAMS --query_id github_events_update --query "
INSERT INTO github_events
WITH
    (SELECT max(file_time) + INTERVAL 1 HOUR FROM github_events) AS time,
    format(
        'https://clickhouse-public-datasets.s3.amazonaws.com/gharchive/original/{}-{}.json.gz',
        formatDateTime(time, '%Y-%m-%d'), toHour(time)) AS url
SELECT
    time,
    type,
    COALESCE(actor.login, actor_attributes.login),
    COALESCE(repo.name, repository.owner || '/' || repository.name),
    created_at,
    COALESCE(payload.updated_at, payload.comment.updated_at, payload.issue.updated_at, payload.pull_request.updated_at),
    payload.action,
    payload.comment.id,
    COALESCE(payload.review.body, payload.comment.body, payload.issue.body, payload.pull_request.body, payload.release.body),
    payload.comment.path,
    payload.comment.position,
    payload.comment.line,
    payload.ref,
    payload.ref_type,
    COALESCE(payload.comment.user.login, payload.issue.user.login, payload.pull_request.user.login),
    COALESCE(payload.issue.number, payload.pull_request.number, payload.number),
    COALESCE(payload.issue.title, payload.pull_request.title),
    arrayMap(x -> tupleElement(x, 'name'), payload.issue.labels || payload.pull_request.labels),
    COALESCE(payload.issue.state, payload.pull_request.state),
    COALESCE(payload.issue.locked, payload.pull_request.locked),
    COALESCE(payload.issue.assignee.login, payload.pull_request.assignee.login),
    arrayMap(x -> tupleElement(x, 'login'), payload.issue.assignees || payload.pull_request.assignees),
    COALESCE(payload.issue.comments, payload.pull_request.comments),
    COALESCE(payload.review.author_association, payload.issue.author_association, payload.pull_request.author_association),
    COALESCE(payload.issue.closed_at, payload.pull_request.closed_at),
    payload.pull_request.merged_at,
    payload.pull_request.merged_commit_sha,
    arrayMap(x -> tupleElement(x, 'login'), payload.pull_request.requested_reviewers),
    arrayMap(x -> tupleElement(x, 'name'), payload.pull_request.requested_teams),
    payload.pull_request.head.ref,
    payload.pull_request.head.sha,
    payload.pull_request.base.ref,
    payload.pull_request.base.sha,
    payload.pull_request.merged,
    payload.pull_request.mergeable,
    payload.pull_request.rebaseable,
    payload.pull_request.mergeable_state,
    payload.pull_request.merged_by.login,
    payload.pull_request.review_comments,
    payload.pull_request.maintainer_can_modify,
    payload.pull_request.commits,
    payload.pull_request.additions,
    payload.pull_request.deletions,
    payload.pull_request.changed_files,
    payload.comment.diff_hunk,
    payload.comment.original_position,
    payload.comment.commit_id,
    payload.comment.original_commit_id,
    payload.size,
    payload.distinct_size,
    startsWith(payload.member, '{') ? JSONExtractString(payload.member, 'login') : payload.member,
    payload.release.tag_name,
    payload.release.name,
    payload.review.state
FROM url((SELECT url), auto,
'
    id Nullable(String),
    type Nullable(String),
    actor Tuple(
        login Nullable(String)),
    actor_attributes Tuple(
        login Nullable(String)),
    repo Tuple(
        name Nullable(String)),
    repository Tuple(
        owner Nullable(String),
        name Nullable(String)),
    created_at DateTime,
    payload Tuple(
        updated_at Nullable(DateTime),
        action Nullable(String),
        ref Nullable(String),
        ref_type Nullable(String),
        number Nullable(Int64),
        size Nullable(Int64),
        distinct_size Nullable(Int64),
        comment Tuple(
            updated_at Nullable(DateTime),
            id Nullable(String),
            body Nullable(String),
            path Nullable(String),
            position Nullable(String),
            line Nullable(String),
            user Tuple(
                login Nullable(String)),
            diff_hunk Nullable(String),
            original_position Nullable(String),
            commit_id Nullable(String),
            original_commit_id Nullable(String)),
        issue Tuple(
            updated_at Nullable(DateTime),
            closed_at Nullable(DateTime),
            body Nullable(String),
            user Tuple(
                login Nullable(String)),
            number Nullable(Int64),
            title Nullable(String),
            labels Array(Tuple(name Nullable(String))),
            state Nullable(String),
            locked Nullable(String),
            assignee Tuple(
                login Nullable(String)),
            assignees Array(Tuple(
                login Nullable(String))),
            comments Nullable(Int64),
            author_association Nullable(String)),
        pull_request Tuple(
            updated_at Nullable(DateTime),
            closed_at Nullable(DateTime),
            merged_at Nullable(DateTime),
            merged_commit_sha Nullable(String),
            body Nullable(String),
            user Tuple(
                login Nullable(String)),
            number Nullable(Int64),
            title Nullable(String),
            labels Array(Tuple(name Nullable(String))),
            state Nullable(String),
            locked Nullable(String),
            assignee Tuple(
                login Nullable(String)),
            assignees Array(Tuple(
                login Nullable(String))),
            comments Nullable(Int64),
            review_comments Nullable(Int64),
            author_association Nullable(String),
            requested_reviewers Array(Tuple(
                login Nullable(String))),
            requested_teams Array(Tuple(
                name Nullable(String))),
            head Tuple(
                ref Nullable(String),
                sha Nullable(String)),
            base Tuple(
                ref Nullable(String),
                sha Nullable(String)),
            merged Nullable(String),
            mergeable Nullable(String),
            rebaseable Nullable(String),
            maintainer_can_modify Nullable(String),
            mergeable_state Nullable(String),
            merged_by Tuple(
                login Nullable(String)),
            commits Nullable(Int64),
            additions Nullable(Int64),
            deletions Nullable(Int64),
            changed_files Nullable(Int64)),
        review Tuple(
            body Nullable(String),
            author_association Nullable(String),
            state Nullable(String)),
        release Tuple(
            body Nullable(String),
            tag_name Nullable(String),
            name Nullable(String)),
        member Nullable(String)
    )
')
SETTINGS date_time_input_format = 'best_effort', input_format_allow_errors_ratio = 0.01, input_format_allow_errors_num = 1000
"
