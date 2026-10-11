-- 3.3a Direct expression — identify posts with high engagement.
    SELECT post_id,
           post_title,
           like_count,
           CASE
               WHEN like_count >= 300 THEN 'High engagement'
               WHEN like_count >= 100 THEN 'Medium engagement'
               ELSE 'Low engagement'
           END AS engagement_category
    FROM posts
    WHERE CASE
              WHEN like_count >= 300 THEN 'High engagement'
              WHEN like_count >= 100 THEN 'Medium engagement'
              ELSE 'Low engagement'
          END = 'High engagement'
    ORDER BY like_count DESC;
    -- Returns 8 high engagement posts

-- 3.3b Subquery — calculate the engagement category first.
    SELECT post_id, post_title, like_count, engagement_category
    FROM (
        SELECT post_id,
               post_title,
               like_count,
               CASE
                   WHEN like_count >= 300 THEN 'High engagement'
                   WHEN like_count >= 100 THEN 'Medium engagement'
                   ELSE 'Low engagement'
               END AS engagement_category
        FROM posts
    ) AS post_engagement
    WHERE engagement_category = 'High engagement'
    ORDER BY like_count DESC;
    -- Returns 8 high engagement posts

-- 3.3c CTE — calculate engagement categories in a named result.
    WITH post_engagement AS (
        SELECT post_id,
               post_title,
               like_count,
               CASE
                   WHEN like_count >= 300 THEN 'High engagement'
                   WHEN like_count >= 100 THEN 'Medium engagement'
                   ELSE 'Low engagement'
               END AS engagement_category
        FROM posts
    )
    SELECT post_id, post_title, like_count, engagement_category
    FROM post_engagement
    WHERE engagement_category = 'High engagement'
    ORDER BY like_count DESC;
    -- Returns 8 high engagement posts
-- I do not believe there is any input which would cause these three queries to behave differently or return varying results.