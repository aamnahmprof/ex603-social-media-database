-- 5.1.1
-- Write a query that joins three tables to display the user who 'gave' each like, the post that was liked, and the date and time the like occurred.
SELECT
    u.user_name,
    p.post_title,
    l.liked_at
FROM likes l
LEFT JOIN users u ON l.user_id = u.user_id
LEFT JOIN posts p ON l.post_id = p.post_id;

-- 5.1.2
-- Write a query that connects the producer table to the catalog table through the junction table. Return the producers associated with your theme's catalog tag
SELECT
    h.hashtag_name, p.post_title
FROM hashtags h
LEFT JOIN post_hashtags p_h ON h.hashtag_id = p_h.hashtag_id
LEFT JOIN posts p ON p_h.post_id = p.post_id
WHERE h.hashtag_name = 'tech';
-- Unsure what "your theme's catalog tag" would be - my theme is Social Media, and that is not an existing hashtag. Used tech as it was the closest.

-- 5.1.3
-- Write a self join to compare records within the producer table. Use the results to explore whether the producers identified in Assignment 4 share characteristics with other producers or whether differences in activity levels may explain their performance.
WITH post_activity AS (
    SELECT
        post_id,
        COUNT(*) AS like_count,
        AVG(dwell_ms) AS avg_dwell_ms
    FROM likes
    GROUP BY post_id
)
SELECT
    p1.post_id AS post,
    p1.author_country AS country,
    a1.like_count,
    a1.avg_dwell_ms,
    p2.post_id AS compared_post,
    a2.like_count AS compared_like_count,
    a2.avg_dwell_ms AS compared_avg_dwell_ms
FROM posts p1
JOIN posts p2
    ON p1.author_country = p2.author_country
    AND p1.post_id <> p2.post_id
LEFT JOIN post_activity a1
    ON p1.post_id = a1.post_id
LEFT JOIN post_activity a2
    ON p2.post_id = a2.post_id
ORDER BY p1.author_country, a1.like_count DESC;