# Unit 1

## Modeling Justification
I followed the designated structure for the actor, producer, event, catalog, and junction for the social media theme. This automatically meant that the 5 relations would be 'Users', 'Posts', 'Likes', 'Hashtags', and 'Post_hashtags' - from there, I began to determine the attributes. 

I started with the users relation, and based my design off of what my experience signing up for social media platforms is. I went with a pretty simple attribute structure, including an auto-generated user_id, a username that must be unique to already existing ids on the platform, and basic user informaton. The reason I went with an auto-generated user_id as the primary key rather than the username is because it allows for a little more efficiency with querying as well as a simpler foreign key to use than complex username strings.

From there, I moved on to the posts relation, and quickly realized I should specify a type of media for this platform. Otherwise, it would leave the attributes very vague and would not allow for seamless use of the system. I decided to go with a text based social media platform where the content attribute can be filled with any text.  
I also chose to add view_count as the numeric attribute that can be used for filtering in the future. I went with this metric because I belive it is a solid comparison metric to see how views affect like performance.

The next relation I defined was likes, and this was relatively simple. Every user can only like a post once, which makes (user_id, post_id) the clear primary key. I also decided to stored liked_at as a timestamp, which will help to see when posts are performing better/worse compared to when they were created. The dwell_ms will be used as a key metric per the assignment.

I then defined the catalog relation of hashtags. This was very simple - I decided that for every hashtag created (which must be unique), a unique id would be auto generated and used as the primary key. This sets up the database perfectly for the following junction.

Post_hashtags is a junction relation between posts and hashtags, where each row simply stores a post_id and a hashtag_id that was used on that post. These attributes together create the primary key.

## Reflection
Going through this exercise helped me see a lot more clearly how much detail goes into database design. I have never truly thought about how many columns need enforced uniqueness, or how greatly autogenerating primary keys can help improve the efficiency of a system. It just helped me to see how much attention needs to be paid to ensure a system works as intended; I realized this with even a small database of just 5 tables with no more than 8 attributes in one. I can't begin to imagine how many things could go wrong in intircate corporation databases with countless relations and attributes that need the proper domains and constraints.