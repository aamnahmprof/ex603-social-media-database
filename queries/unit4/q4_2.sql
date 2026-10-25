-- 4.2.A
-- Calculate like count and removed like count for each post
SELECT
    post_id as post,
    COUNT(*) as like_count,
    SUM(CASE WHEN reaction_status = 'removed' THEN 1 ELSE 0 END) as failed_likes
FROM likes
GROUP BY post_id
ORDER BY failed_likes DESC;

-- 4.2.B
-- Calculate like count per country (author country), and total like count across all posts
SELECT
    author_country,
    sum(like_count) as like_count,
    CASE
        WHEN author_country IS NULL THEN 'Grand Total'
        ELSE 'Country Total'
    END AS row_type
FROM posts
GROUP BY ROLLUP (author_country);

-- 4.2.C
-- Return posts where like count is over 75% of the maximum like count found in the dataset
WITH like_count AS (
    SELECT
        post_id,
        COUNT(*) AS num_likes
    FROM likes
    GROUP BY post_id
)
SELECT
    post_id
FROM (
    SELECT
        post_id,
        num_likes,
        MAX(num_likes) OVER () AS max_likes
    FROM like_count
) AS t
WHERE num_likes >= 0.75 * max_likes
ORDER BY num_likes DESC;