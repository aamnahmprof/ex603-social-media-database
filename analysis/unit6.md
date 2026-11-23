# Unit 6

## 6.1

1. How does each like's dwell time compare to the average dwell time of all likes on that post? A group average using GROUP BY would not answer this question, because it would return only one row per post. This does not allow for a comparison of individual dwell times to that value. 

2. A 'Top Posts' leaderboard that ranks posts by like count should use the RANK() ranking values. Because the rankings are determined by like count, and this is a whole number, any tied posts should receive the same rank. There would be no fair way to decide who gets a better rank. Also, it skips the next rank(s) if there is a tie, which is appropriate for a leaderboard. If there are two people in 2nd, there cannot be someone in 3rd as well for competitive purposes. 

## 6.2

1. A large delta may indicate that a like has a dwell time that is very different from the one before it on the same post. This could reflect engaging or confusing content, unusual user behavior, or a change around the post. Leadership should investigate the surrounding likes and post before making changes to content or moderation policies.

2. A plain SUM combines all dwell values into one total and does not show how the total changes across individual rows. A running total preserves each like and shows cumulative dwell time through that point, which makes it possible to track progress toward a quarterly target over time.

3. I chose a seven-row moving-average window because it gives a short-term view of recent activity while limiting the effect of a single unusual like. A larger window would create a smoother result and react more slowly to changes, while a smaller window would be closer to the value of each individual row and could tell a more volatile story.

4. The gaps in this platform represent periods with no like activity for a post. The query compares consecutive liked_at values for each post, and the results include many gaps longer than seven days. Post 9 has the longest gap at 112 days, 13 hours, and 58 minutes, while Post 12 has a gap of 106 days, 17 hours, and 50 minutes. This indicates a real stop in like activity rather than a missing calendar row, because the result is based on the like events that were actually recorded. Leadership should investigate which posts were inactive for the longest periods to determine whether they lost visibility, were removed or changed, or simply no longer kept users interested.

## 6.3

1. Top-N could power a feature that shows the three likes with the highest dwell times for each post. Three is useful because it provides enough examples to identify patterns without overwhelming creators or analysts. One would be too limited and vulnerable to unusual behavior, while ten would make the feature less focused and harder to use.

2. A large month-over-month change in dwell time could mean that user engagement is increasing or decreasing. An increase may indicate that recent content or platform changes are keeping users engaged for longer. A decrease could indicate lower content quality, less activity, or an issue with how dwell events are recorded. Leadership should investigate which posts or changes contributed to the movement and take action based on what they find. A positive change could be used to guide future content decisions, while a negative change should lead to deeper analysis and improvements.

## Reflection

Window functions keep rows while aggregates collapse them. In this project, that difference makes many reporting questions easier to answer. For example, I can show each like's dwell time beside the average dwell time for its post using PARTITION BY. This is a natural window-function question because every like must remain in the result with a post-level comparison. A GROUP BY alone would only return one row for each post and cannot preserve the individual likes needed for the comparison.

Window functions also make time-based reporting possible without changing the shape of the data. The monthly dwell query uses LAG to compare each month with the month before it, while a plain monthly SUM would only produce a separate total for each month. The running total and moving average similarly show how engagement changes across rows instead of reducing the platform to one overall number.

These reporting patterns are useful because leadership needs to identify which posts or periods require action. Ranking, previous-row comparisons, cumulative totals, moving averages, and gaps all keep the underlying event in context. A GROUP BY can calculate summaries, but it cannot compare a current row with the prior row or show each post beside a category average without reducing the detail. Window functions let the analysis keep individual likes, posts, and time periods visible while still calculating meaningful summaries.