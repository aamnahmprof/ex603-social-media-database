-- 4.1.1
-- Calculate the count, total, average, minimum, and maximum of dwell_ms across the likes table, and how many distinct users have posted

SELECT
    COUNT(COALESCE(dwell_ms, 0)) AS sec_count,
    SUM(dwell_ms) AS total_sec,
    MIN(dwell_ms) AS min_sec,
    MAX(dwell_ms) AS max_sec,
    COUNT(DISTINCT user_id) AS unique_user
FROM LIKES;
-- Results
-- 200 values for dwell_ms, with nulls replaced with 0 so they are counted.
-- 3,628,190 total seconds spent 'dwelling' on posts (1.00783 hours).
-- Lowest dwell_ms is 0. This makes sense as nulls have been replaced with 0, but it is interesting why this value would be null at all. ms is a pretty small unit of time and it's hard not to spend that much time on a post. This is worth investigating.
-- Greatest dewll_ms is 70,860. This is 1.181 minutes, which is definitely a reasonable amount of time to spend on a post.
-- 30 unique users found in the table. This makes sense, as there are 30 total users in the database.

-- 4.1.2
-- Calculate like count and average dwell_ms for each post
SELECT
    post_id,
    COUNT(*) AS num_likes,
    AVG(dwell_ms) AS avg_dwell_ms
FROM likes
GROUP BY post_id
ORDER BY num_likes DESC;
-- Results
-- These results show that activity and results are not necessarily correlated. The post with the least amount of likes had a greater average dwell_ms than the post with the greatest number of likes.

-- 4.1.3
-- Exclude posts with like count under 10
SELECT
    post_id,
    COUNT(*) AS num_likes,
    AVG(dwell_ms) AS avg_dwell_ms
FROM likes
GROUP BY post_id
HAVING COUNT(*) >= 10
ORDER BY num_likes DESC;
-- I selected the threshold of 10 based on the greatest like count of 21. Given that this count itself is not very high, it doesn't make sense to exclude another subset in my opinion. The only real outlier looking at the result from 4.1.2 was with 6 like counts, and I decided 10 was a good threshold for future added data based on all of this.

-- 4.1.4
-- View like count and average dwell ms for posts aggregated by region (author country) and media type.
SELECT
    posts.author_country as author_country,
    post_media.media_code as media_type,
    posts.post_id as post_id,
    posts.like_count as like_count,
    AVG(likes.dwell_ms) AS avg_dwell_ms
FROM likes
LEFT JOIN posts ON
    likes.post_id = posts.post_id
LEFT JOIN post_media ON
    likes.post_id = post_media.post_id
GROUP BY author_country, media_type, posts.post_id, like_count
ORDER BY author_country, like_count;
-- The results show the most successful media types broken down by country, aggregated to one row per combination for leadership to view.