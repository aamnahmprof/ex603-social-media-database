# Unit 5

## 5.1

One report that could use the three table join from Question 1 would be a report looking at the most active users and/or times of day for the social media platform. Displaying the producer of each like and when it occurred provides an overarching view of these metrics. 

The junction table is essential for answering Question 2 - without it, posts and hashtags would not be able to be joined at all. There is no reference to hashtags in posts, nor vice-versa, so the junction table is the only way to make that connection and see any hashtag-related analytics. 

## 5.2

1. The two producers which were excluded by the INNER JOIN where Post_14 and Post_15.
2. When a producer has no events, it means that the post was not liked by any user. It could be low performing content, it could have been posted at a time where there is no online activity so it missed the feed, or maybe the post was removed or deactivated; there are many possible reasons for this to happen. 
3. By using an INNER JOIN, leadership may be unaware of something they should know. An INNER JOIN removes records from the result which do not have matches in both tables; so, in this case, a report that uses one would exclude posts with no likes. What if the purpose of the report is to see low-performing posts? Leadership would see posts with 1, 2, 3 likes but not 0 - the most negatively performing posts of all. 
4. Leadership would likely want to dig deeper into why they have never been active. They may want to explore how to prevent that going forwards if it's an instance where a post was flagged and immediately removed for some reason. 
5. Leadership should take a closer look at Post_14 and Post_15 to understand why they received no likes. Rather than immediately assuming the content was unsuccessful, they should investigate whether the posts were removed, flagged, published at a bad time, or simply never reached many users. Depending on what they find, they should take steps to mitigate this from happening in the future so they can maximize engagement on the platform. 

## 5.3

1. I don't believe there's anywhere a Cartesian product can be particularly helpful on this platform. The main place I *would* think of is with posts and hashtags, but that need has been mitigated by the post_hashtags junction table. 
2. Nested Loop Left Join, Hash Left Join
3. The estimated row counts and costs help explain PostgreSQL's decisions. The likes table is estimated to have 200 rows and users 100 rows, making a Hash Join a reasonable choice. The Index Scan on posts_pkey also shows that PostgreSQL can use the primary key index to find matching posts efficiently. Memoize indicates that repeated post_id lookups can be cached.
4. Understanding the join algorithms helps identify potential performance issues as the database grows. It also helps explain how PostgreSQL retrieves and combines records and whether indexes or other database optimizations could improve query performance.
5. If the tables became significantly larger, a Hash Join might become more efficient than a Nested Loop Join. If the joining columns were indexed and the data was already sorted, a Merge Join might also become a better option. Changes in table size, data distribution, and available indexes could all affect which algorithm is used.

## Reflection

In Task 5.3, PostgreSQL used a Hash Left Join and a Nested Loop Left Join to connect the three tables. I think these choices made sense given the relatively small size of the tables and the indexes available. However, as the database grows, PostgreSQL might choose different algorithms depending on how much data it needs to process.

For example, if the likes and users tables grew significantly, a Hash Join might still be appropriate, but the amount of data needed to build and search the hash table would increase. If the posts table became much larger, the Nested Loop Join could become less efficient because it would need to perform more lookups. In that situation, a Hash Join might be a better option, depending on the number of matching records.

Indexes could also influence these decisions. If the joining columns were indexed, PostgreSQL might favor index-based lookups. Alternatively, if the tables were large and the joining columns were already sorted or indexed in a way that supports ordered access, a Merge Join could become more efficient.

Overall, table size, available indexes, and the number of matching records all influence which join algorithm PostgreSQL selects. Understanding this helps identify potential performance issues before they become a problem as the database grows.