# Unit 4

## 4.1

The people who would act on the per-producer breakdown are the content producers themselves, since they have the most direct control over what they post. By comparing their content's performance, they can identify which types of posts receive more engagement and use that information to inform future content. Leadership could also use this breakdown to identify broader trends across producers, countries, and media types.

Although I examined individual posts by post_id in queries 4.1.2 and 4.1.3, aggregating results by producer, country, or media type can hide differences between individual posts. An overall like count does not show which specific posts perform well, while an average dwell time conceals the distribution of viewing times. For example, a high average could result from consistently high dwell times or from a few posts with unusually high values. Similarly, a count of users does not reveal which users are engaging or whether engagement is concentrated among a small group.

The relatively low maximum like count of 21 also limits how confidently I can draw conclusions about content performance. Although I filtered out posts with fewer than 10 likes in query 4.1.3, this threshold does not necessarily establish that the remaining results are representative.

The next step would be to examine the distribution of dwell times for individual posts, alongside their like counts and distinct actor counts. I would also compare performance across producers and media types to see whether the patterns hold across multiple posts rather than being driven by a single result. This would provide more context for deciding what content producers should change or continue creating.

## 4.2

**Part A**

This query answers the two questions of how many likes each post has received, and how many of those likes have been removed. This allows us to identify posts with high engagement and/or a higher number of removed likes.

**Part B**

A manager or leadership team would benefit from subtotals because they can compare like counts across countries without looking at every post individually. The grand total shows overall engagement across all countries, giving leadership a broader view than the individual country totals.

**Part C**

This pipeline answers the question of which posts have at least 75% of the maximum like count? It calculates the like count for each post, finds the maximum, and returns posts that are close to that maximum. This helps identify potentially high-performing posts. I used this metric rather than a constant value so that even if the dataset changes, the threshold remains.

## Reflection

Conditional aggregation is useful when we need several related answers from the same table. For example, instead of running one query to count active likes and another to count removed likes, we can use conditional expressions inside aggregate functions to calculate both counts in one query.

With two separate filtered queries, the database may have to read through the same data twice. If the table contains one million rows, each query might examine up to one million rows, resulting in roughly two million row checks altogether. A conditional aggregation can often calculate both results during a single pass, examining each row once and updating the appropriate totals. This can reduce repeated work, especially when the table is large or stored on disk, where reading data is costly. It can also reduce query execution overhead because the database runs one query rather than two.

The exact performance improvement depends on the database’s query plan, indexes, caching, and the filters. An index could make a separate filtered query faster, and the database may optimize either approach. Still, when both answers require examining much of the same dataset, conditional aggregation is often more efficient because it avoids repeating the scan while returning multiple results together.