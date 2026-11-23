-- Actor: Users
-- Event: Likes
-- Producer: Posts
-- Catalog: Hashtags
-- Metric: Dwell ms

-- 6.1.1
-- Compare each event to its producer’s average.
-- How does the dwell ms of each like compare to the average dwell ms of all likes on that post?
SELECT
    user_id,
    like_id,
    post_id,
    dwell_ms,
    AVG(dwell_ms) OVER (
        PARTITION BY post_id
    ) AS post_avg_dwell_ms,
    dwell_ms - AVG(dwell_ms) OVER (
        PARTITION BY post_id
    ) AS difference_from_avg
FROM likes;

-- 6.1.2
-- Rank producers three ways
-- Ranks posts based on their like count using three methods, each of which handle tiebreaks differently.
WITH post_likes AS (
    SELECT
        post_id,
        count(like_id) AS like_count
    FROM
        likes
    GROUP BY
        post_id
)
SELECT
    post_id,
    row_number() OVER (
        ORDER BY like_count DESC
        ) AS row_number,
    rank() OVER (
        ORDER BY like_count DESC
        ) AS rank,
    dense_rank() OVER (
        ORDER BY like_count DESC
        )
FROM
    post_likes;

-- 6.1.3
-- Sort producers into four bands
-- Categorize posts into quartiles based on like count.
WITH post_likes AS (
    SELECT
        post_id,
        count(like_id) AS like_count
    FROM
        likes
    GROUP BY
        post_id
)
SELECT
    post_id,
    like_count,
    ntile(4) OVER (
        ORDER BY like_count DESC
        ) AS quartile
FROM
    post_likes
ORDER BY
    quartile;