-- 3.1a: Return top 10 active posts, sorted by like count in descending order.
    SELECT *
    FROM posts
    WHERE is_visible is TRUE
      AND like_count > 100
    ORDER BY like_count desc
    LIMIT 10;
-- This query only returns 9 rows, meaning only 9 posts have a like count of over 100. The top 4 posts are all tied in performance with 400 likes.

-- 3.1b: Return all possible event statuses. In this case, likes are the event.
    SELECT DISTINCT reaction_status
    FROM likes;
-- This query returns 3 status values: active, flagged, and removed. I was only expecting active and removed, but it does make sense for a like to be flagged if, say, the user who liked the post has had their account flagged.

-- 3.1c: Filter the events (likes) in 2 different ways - once using a numerical range, and once using IN and an explicit list of values.
    -- Query 1: Checking for likes with a weight of more than 1.5, as these must be some sort of significant.
    SELECT *
    FROM likes
    WHERE weight > 1.5
    ORDER BY weight;
    -- Returns 26 likes which have all been given a weight of 2. I'm curious why these have been given greater importance.

    -- Query 2: Checking for likes only from users not in America.
    SELECT *
    FROM likes
    WHERE client_country IN ('Vietnam', 'India', 'UK');
    -- 123 likes from users not in America (US & Brazil are the two American countries in the likes dataset)

-- 3.1d: Work with text and missing values.
    -- Query 1: Find posts whose names match a text pattern using LIKE. Checking for post titles that match the assumed pattern.
    SELECT *
    FROM posts
    WHERE post_title LIKE 'Post%';
    -- 15 (out of a total 15) posts match the naming style that they should.

    -- Query 2: Identify records where a reason/value is missing (NULL)
    SELECT *
    FROM likes
    WHERE removal_reason IS NULL;

    SELECT *
    FROM likes
    WHERE reaction_status = 'removed'
    AND removal_reason IS NULL;
    -- There are 166 likes where the removal_reason is null, but none of those likes have been removed so this makes sense.

    -- Query 3: Use COALESCE to replace a missing value with a useful label. I will be stating that no removal reason is needed, per 3.1d - Query 2.
    SELECT like_id, user_id, post_id, reaction_status, coalesce(removal_reason, 'No Reason Needed - Like has not been removed.') as removal_reason
    FROM likes;
    -- Returns the specified columns with any null removal reasons replaced.

-- 3.1e: Create a query with calculated/computed columns that would make sense to someone who does not work with SQL. This query looks at general performance based on hashtag use.
    SELECT
        p.post_title AS post_name,
        p.like_count AS total_likes,
        COUNT(DISTINCT ph.hashtag_id) AS number_of_hashtags,
        ROUND(
            p.like_count::NUMERIC /
            NULLIF(COUNT(DISTINCT ph.hashtag_id), 0),
            2
        ) AS likes_per_hashtag,
        CASE
            WHEN p.like_count > 100
                 AND COUNT(DISTINCT ph.hashtag_id) > 0
            THEN 'Popular hashtagged post'
            WHEN p.like_count > 100
            THEN 'Popular post without hashtags'
            ELSE 'Needs more engagement'
        END AS performance_summary
    FROM posts p
    LEFT JOIN post_hashtags ph
        ON p.post_id = ph.post_id
    GROUP BY p.post_id, p.post_title, p.like_count
    ORDER BY total_likes DESC;
-- Result shows that most hashtagged posts are relatively successful compared to the dataset overall.