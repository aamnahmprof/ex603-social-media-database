-- 6.2.A
-- Row to row
--
WITH producer_trends AS (
    SELECT
        post_id,
        like_id,
        liked_at,
        dwell_ms,
        LAG(dwell_ms) OVER (
            PARTITION BY post_id
            ORDER BY liked_at, like_id
        ) AS previous_dwell_ms,
        LEAD(dwell_ms) OVER (
            PARTITION BY post_id
            ORDER BY liked_at, like_id
        ) AS next_dwell_ms
    FROM likes
)
SELECT
    post_id,
    like_id,
    liked_at,
    previous_dwell_ms,
    dwell_ms AS current_dwell_ms,
    next_dwell_ms,
    dwell_ms - previous_dwell_ms AS dwell_ms_delta
FROM
    producer_trends
WHERE
    post_id = '7'
ORDER BY
    liked_at, like_id;

-- 6.2.B
-- Cumulative and smoothed
--
-- Target total per quarter: 1,000,000
SELECT
    liked_at,
    dwell_ms,
    SUM(dwell_ms) OVER (
        ORDER BY liked_at, post_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_total,
    SUM(dwell_ms) OVER (
        PARTITION BY DATE_TRUNC('quarter', liked_at)
        ORDER BY liked_at, post_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS quarterly_running_total,
    AVG(dwell_ms) OVER (
        ORDER BY liked_at, post_id
        ROWS BETWEEN 6 PRECEDING
        AND CURRENT ROW
    ) AS moving_average,
    1000000 - SUM(dwell_ms) OVER (
        PARTITION BY DATE_TRUNC('quarter', liked_at)
        ORDER BY liked_at, post_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS remaining_to_quarterly_target
FROM likes
ORDER BY liked_at, post_id;
-- The only quarter where the platform met the target was Q3
-- ROWS counts individual physical rows, so when two rows have the same ORDER BY value, it still treats them as separate rows based on their position in the ordering. RANGE treats rows with the same ORDER BY value as peers, meaning they can be included together in the same window frame.

-- 6.2.C
-- Where the series stops
WITH producer_activity AS (
    SELECT
        post_id,
        liked_at,
        LAG(liked_at) OVER (
            PARTITION BY post_id
            ORDER BY liked_at
        ) AS previous_timestamp
    FROM likes
),
producer_gaps AS (
    SELECT
        post_id,
        previous_timestamp,
        liked_at AS resumed_timestamp,
        liked_at - previous_timestamp AS gap_duration
    FROM producer_activity
)
SELECT
    *
FROM
    producer_gaps
WHERE
    gap_duration > INTERVAL '7 days'
ORDER BY
    gap_duration DESC;