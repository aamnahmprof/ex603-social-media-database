# Full Repository Presentation Script

**Estimated duration:** 8:00

**Presentation scope:** The repository documents the project from relational modeling through SQL analysis in Units 1–6. Units 1–2 establish the social media schema and integrity rules; Units 3–6 analyze an expanded exercise dataset using filtering, aggregation, joins, and window functions.

## 1. Introduction (0:30)

**Slide skeleton**
- Title: Social Media Database: Design to Engagement Analysis
- Course: EX603 — Data & Algorithms for Scalable Systems
- Roadmap: model, protect, query, analyze

**Script**
“This repository follows a social media database project from its initial design through several stages of SQL analysis. The platform centers on users, posts, likes, hashtags, and the relationship between posts and hashtags. Across Units 1 through 6, I worked on the data model, integrity rules, filtering, summary reports, joins, query plans, and time-based engagement analysis. I’ll walk through how each stage builds on the previous one and what the results can—and cannot—tell us.”

## 2. Units 1–2: Relational Design and Integrity (1:10)

**Slide skeleton**
- ERD: `schema/erd.drawio.png`
- Five relations: users, posts, likes, hashtags, post_hashtags
- Example rules: unique username; one like per user/post; nonnegative metrics

**Script**
“In Unit 1, I translated the social media domain into five relations. Users own posts. Likes connect users to posts and record when the interaction happened and its dwell time. Hashtags are stored once in a catalog, while the post_hashtags junction table supports the many-to-many relationship between posts and hashtags.

“The keys reflect those relationships. Users, posts, and hashtags have their own identifiers. Likes use a composite key of post and user, so the same user cannot like the same post twice. Post_hashtags also uses a composite key so a hashtag cannot be associated with the same post more than once.

“Unit 2 adds integrity rules. Foreign keys ensure that posts and likes refer to existing users and posts. Cascading deletes remove dependent records when their parent is deleted. Check constraints reject future dates of birth, negative view counts, and negative dwell times. These rules make invalid states harder to store, rather than relying only on application code to catch them.”

## 3. Unit 3: Filtering, NULLs, and Query Structure (1:10)

**Slide skeleton**
- Screenshot: `screenshots/unit3_3.2a.png`
- Screenshot: `screenshots/unit3_3.3.png`
- Concepts: predicates, NULL handling, CASE, subqueries, CTEs

**Script**
“Unit 3 moves from design to querying. The exercises use filters to inspect active posts, reaction statuses, country values, and missing removal reasons. They also use CASE expressions to classify engagement and calculate readable measures such as likes per hashtag.

“One important finding is that a query can run successfully and still omit data. In the ‘rows that vanished’ exercise, comparing a nullable removal_reason with a value excludes NULL rows, because NULL is unknown rather than an ordinary value. The repair makes the treatment of missing reasons explicit and verifies the row count.

“The unit also shows why a SELECT alias cannot be used in the same query's WHERE clause, then rewrites the calculation with a subquery or common table expression. For classifying high-engagement posts, a direct expression, subquery, and CTE return the same eight posts here. The practical lesson is to verify both the logic and the records included in a result before using it in a dashboard.”

## 4. Unit 4: Aggregation and Business Summaries (1:05)

**Slide skeleton**
- Screenshot: `screenshots/unit4_4.1.png`
- Screenshot: `screenshots/unit4_4.2.png`
- Concepts: aggregate statistics, HAVING, conditional aggregation, ROLLUP

**Script**
“Unit 4 summarizes activity at different levels. The queries calculate overall dwell statistics, count likes and average dwell time per post, filter groups with HAVING, and break results down by author country and media type. Conditional aggregation counts removed likes alongside total likes, and ROLLUP adds country subtotals and a grand total.

“The results provide leads for further investigation. Post 11 has the most removed likes, with five; Posts 6 and 9 have four each. That is a count, not a failure rate. A fair comparison would also need each post’s total likes, and producer-level analysis would be needed before drawing conclusions about individual creators. Aggregates are useful summaries, but grouping can hide the variation among the records being summarized.”

## 5. Unit 5: Joins and Query Plans (1:05)

**Slide skeleton**
- Screenshot: `screenshots/unit5_5.1.png`
- Screenshot: `screenshots/unit5_5.2.png`
- Screenshot: `screenshots/unit5_explain.png`
- Concepts: inner/outer joins, junctions, anti-joins, EXPLAIN

**Script**
“Unit 5 connects related information. A three-table join brings together the user who liked a post, the post itself, and the event timestamp. A separate join uses the post_hashtags junction to connect posts to hashtag names. The exercises also compare posts with similar authors and performance.

“Join choice affects which records appear. An inner join excludes posts without likes, while a left join keeps them and reports a count of zero. In this dataset, Posts 14 and 15 have no likes. NOT EXISTS and EXCEPT both identify those posts, giving leadership a way to find the content that would disappear from an inner-join report.

“The cross-join exercise combines 15 posts with five hashtags to produce 75 pairs, illustrating why a Cartesian product should be intentional. Finally, EXPLAIN shows how PostgreSQL plans a join. For this relatively small dataset, the displayed plan uses a hash left join and a nested-loop left join with an index lookup. The plan is evidence about this query and data size—not a guarantee that the same strategy is best as the tables grow.”

## 6. Unit 6: Window Functions and Trends (1:25)

**Slide skeleton**
- Screenshot: `screenshots/unit6_6.1.png`
- Screenshot: `screenshots/unit6_6.2.png`
- Screenshot: `screenshots/unit6_6.3.png`
- Concepts: partitioned averages, ranking, LAG/LEAD, running totals, moving averages

**Script**
“Unit 6 keeps row-level detail while adding comparisons. The first query shows each like beside the average dwell time for its post and the difference from that average. Ranking functions order posts by like count while handling ties in different ways; NTILE divides them into four groups.

“A top-N query also returns the three highest-dwell likes for each post. Other queries compare each event with the previous and next event, calculate running and quarterly totals, and smooth recent activity with a seven-row moving average. The gap query uses LAG on each post’s like timestamps to find intervals longer than seven days. It identifies long periods without a recorded like; by itself, it cannot establish why activity stopped.

“The period-over-period query aggregates dwell time by month, then uses LAG to compare each month with the prior one. The results are volatile: monthly dwell fell sharply in some periods and rebounded in others. January totals 320,360 milliseconds and December totals 370,650, a net increase of about 15.69 percent, but that endpoint comparison does not demonstrate steady improvement.”

## 7. Findings, Limits, and Next Steps (1:05)

**Slide skeleton**
- Unit 3: validate status counts and NULL treatment before making decisions
- Units 4–5: investigate removed-like counts and zero-like posts
- Unit 6: review Posts 9 and 12; validate event logging
- Next step: align schema and analytics data model

**Script**
“Taken together, the units show why reporting needs both data checks and context. Unit 3 challenges an assumed failure rate by separating active, flagged, and removed statuses and checking how missing values affect the result. Unit 4 identifies posts with higher removed-like counts, while Unit 5 surfaces posts with no likes. Unit 6 flags long activity gaps, including the longest gaps on Posts 9 and 12.

“These are investigation priorities, not proof of cause. A long gap could reflect lower visibility, a changed or removed post, low interest, or incomplete event logging. Likewise, a higher removed-like count is not necessarily a higher rate. Next, I would review event logging and post status, compare counts with appropriate denominators, and monitor engagement after the causes are better understood.

“There is also a modeling limitation visible in the repository: the early schema documentation uses fields such as content and dwell_ms, while later query exercises use an expanded dataset with fields such as post_title, reaction_status, and media type. The units demonstrate a progression of database skills, but the schema and later analysis dataset should be reconciled before treating every query as a single turnkey application.”

## 8. Close (0:30)

**Slide skeleton**
- Summary: design → integrity → analysis
- Repository: [aamnahmprof/ex603-social-media-database](https://github.com/aamnahmprof/ex603-social-media-database)
- Callout: schema, SQL exercises, findings, and screenshots

**Script**
“This project moves from defining reliable relationships and constraints to asking increasingly detailed questions of the data. Filtering and aggregation establish the basic picture; joins preserve relationships and expose missing activity; window functions add row-level and time-based context. The findings point to specific records to investigate while making clear where the data does not yet explain the cause. The repository includes the schema, SQL exercises, written analyses, and screenshots.”
