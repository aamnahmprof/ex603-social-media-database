-- 5.3.A
-- Write a CROSS JOIN between two small tables.
SELECT *
FROM posts
CROSS JOIN hashtags;
-- Run the CROSS JOIN and count the resulting rows.
    -- 75 rows
-- Show how the result matches the multiplication of the two source table counts.
    -- Row count of posts: 15
    -- Row count of hashtags: 5
    -- 5 * 15 = 75
-- Explain when a Cartesian product might be useful and when it could indicate a query error.

-- 5.3.B
-- Return to your three-table join from Task 5.1, Part A. Use PostgreSQL's EXPLAIN command to examine how the database plans to execute the query.
EXPLAIN
SELECT
    u.user_name,
    p.post_title,
    l.liked_at
FROM likes l
LEFT JOIN users u ON l.user_id = u.user_id
LEFT JOIN posts p ON l.post_id = p.post_id;
-- Capture the full execution plan.
    -- Nested Loop Left Join  (cost=12.40..28.34 rows=200 width=524)
    --   ->  Hash Left Join  (cost=12.25..17.80 rows=200 width=270)
    --         Hash Cond: (l.user_id = u.user_id)
    --         ->  Seq Scan on likes l  (cost=0.00..5.00 rows=200 width=16)
    --         ->  Hash  (cost=11.00..11.00 rows=100 width=262)
    --               ->  Seq Scan on users u  (cost=0.00..11.00 rows=100 width=262)
    --   ->  Memoize  (cost=0.15..0.41 rows=1 width=262)
    --         Cache Key: l.post_id
    --         Cache Mode: logical
    --         ->  Index Scan using posts_pkey on posts p  (cost=0.14..0.40 rows=1 width=262)
    --               Index Cond: (post_id = l.post_id)
-- Identify the join algorithm or algorithms used, such as Nested Loop, Hash Join, or Merge Join.
    -- Nested Loop Left Join, Hash Left Join
-- Explain why PostgreSQL may have selected these algorithms, considering table sizes and available indexes.
    -- For the Hash Left Join (l.user_id = u.user_id), this seems like a reasonable choice because both tables are relatively small. For the Nested Loop Left Join, PostgreSQL can use the index on posts.post_id to efficiently find matching records rather than scanning the entire table for each match.
-- Predict which part of the query might become less efficient as the dataset grows.
    -- The Nested Loop Left Join would likely become less efficient with a growing dataset, due to the fact that it has to look up each post_id. Repeated lookups can become more expensive with a much larger dataset. The execution plan estimates 200 rows entering the nested loop, which is manageable now but could increase substantially as more likes are recorded.
