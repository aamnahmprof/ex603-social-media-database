-- Event: Likes
-- Producer: Posts
-- Catalog: Hashtags
-- Metric: dwell_ms ms

-- 6.3.A
-- Top N per category
-- Return the top three events by dwell time for each [post]
WITH ranked_events AS (
    SELECT
        post_id,
        like_id,
        user_id,
        dwell_ms,
        liked_at,
        ROW_NUMBER() OVER (
            PARTITION BY post_id
            ORDER BY dwell_ms DESC, like_id
        ) AS event_rank,
        FIRST_VALUE(like_id) OVER (
            PARTITION BY post_id
            ORDER BY dwell_ms DESC, like_id
        ) AS highest_dwell_event
    FROM likes
)
SELECT
    post_id,
    like_id,
    user_id,
    dwell_ms,
    event_rank,
    highest_dwell_event
FROM
    ranked_events
WHERE
    event_rank <= 3
ORDER BY
    post_id, event_rank;

-- 6.3.B
-- Period over period
-- Is the platform getting better or worse each month?
WITH monthly_totals AS (
    SELECT
        DATE_TRUNC('month', liked_at) AS month,
        SUM(dwell_ms) AS monthly_dwell

    FROM likes
    GROUP BY DATE_TRUNC('month', liked_at)
),

monthly_comparison AS (
    SELECT
        month,
        monthly_dwell,
        LAG(monthly_dwell) OVER (
            ORDER BY month
        ) AS previous_month_dwell
    FROM monthly_totals
)
SELECT
    month,
    monthly_dwell,
    previous_month_dwell,
    ROUND(
        100.0 * (
            monthly_dwell - previous_month_dwell
        ) / NULLIF(previous_month_dwell, 0),
        2
    ) AS percent_change
FROM monthly_comparison
ORDER BY month;