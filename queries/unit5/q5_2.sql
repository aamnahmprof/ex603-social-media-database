-- Actor: Users
-- Event: Likes
-- Producer: Posts
-- Catalog: Hashtags
-- Metric: Dwell ms

-- 5.2.A
-- Use LEFT JOIN to return all producers, including those who have never had an event.
SELECT
    p.post_id,
    p.post_title,
    count(l.like_id) like_count
FROM posts p
LEFT JOIN likes l ON p.post_id = l.post_id
GROUP BY p.post_id, p.post_title
ORDER BY like_count;
-- Write an equivalent query using INNER JOIN.
SELECT
    p.post_id,
    p.post_title,
    count(l.like_id) like_count
FROM posts p
INNER JOIN likes l ON p.post_id = l.post_id
GROUP BY p.post_id, p.post_title
ORDER BY like_count;
-- Compare the results and determine how many producers are excluded by the inner join. Explain which producers are missing and why.
    -- Two records are excluded compared to when the LEFT JOIN was used. These two records were excluded because they have no likes. An inner join looks for records that exist in BOTH tables, and since those posts were never liked, there is no reference to their post_ids in the likes table. As such, they are not included in the result when an INNER JOIN is used.

-- 5.2.B
-- Write a RIGHT JOIN that returns the same records as your LEFT JOIN from Part A.
SELECT
    p.post_id,
    p.post_title,
    count(l.like_id) like_count
FROM likes l
RIGHT JOIN posts p ON l.post_id = p.post_id
GROUP BY p.post_id, p.post_title
ORDER BY like_count;
-- Compare the results to confirm that they match.
    -- Visual comparison complete. Results match.
-- Write a FULL OUTER JOIN that includes matching and unmatched records from both tables.
SELECT *
FROM posts p
FULL OUTER JOIN likes l ON p.post_id = l.post_id;
-- Explain what a full outer join can reveal that a left join or right join alone may not show.
    -- A FULL OUTER JOIN can show rows from both tables whether they have a match in the other or not. A LEFT or RIGHT JOIN will always exclude rows where the join condition is not met, where the FULL OUTER JOIN will simply null out the columns from the table without a match.

-- 5.2.C
-- Write two queries that identify producers who have never had an event and compare them.
-- NOT EXISTS
SELECT p.post_id
FROM posts p
WHERE NOT EXISTS (
    SELECT 1
    FROM likes l
    WHERE l.post_id = p.post_id
);
-- EXCEPT
SELECT p.post_id
FROM posts p
EXCEPT SELECT l.post_id
       FROM likes l;
-- Run both queries and compare their results.
    -- Visual comparison complete. Results match.
-- In one or two sentences, explain how the approaches differ and confirm whether they identify the same producers.
    -- The two queries do identify the same producers, but in different ways. The first query checks that a post_id in posts does not appear in likes before returning it. The second query subtracts the result set of post_ids from likes, from the result set of post_ids from posts. They both accomplish what is needed, but my personal preference is NOT EXISTS. I find it provides more flexibility with what columns are returned and with how it can be used.
