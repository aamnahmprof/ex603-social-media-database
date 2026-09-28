# Unit 2

**Constraints Table**

| Foreign key | ON DELETE choice | Reason |
|---|---|---|
| `fk_posts_user` | `CASCADE` | Posts are owned by a user, so deleting the user should also delete their posts. |
| `fk_ph_posts` | `CASCADE` | If a post is deleted, hashtags cannot be attached to it anymore. |
| `fk_ph_hashtag` | `CASCADE` | If a hashtag is deleted, it cannot be associated with a post anymore. |
| `fk_likes_post` | `CASCADE` | If a post is deleted, there cannot be any likes on that post. |
| `fk_likes_user` | `CASCADE` | Since a user cannot be null in likes, if a user is deleted their likes must be too. |

*Explanation*

fk_posts_user: When a user is deleted, the options for any content they've posted is to either delete it or set the associated user to null. Having a null user does not make sense, because it's important for content to be credited to the original creator. Because of this, I set the rule to CASCADE so that if a user deletes their account, they are automatically deleting anything they've posted as well. 

fk_ph_posts: When a post is deleted, it is gone forever, That means all the content is irrelevant and cannot be seen anywhere. Hashtags are a part of that text content, and if the post is deleted, setting post_id to null would result in rows of just an empty post reference and a hashtag refernce. That is essentially useless data, so I set this to CASCADE - if a post is deleted, its references in post_hashtags are too.

fk_ph_hashtag: If a hashtag is deleted, there is no way for it to be associated with any social media content anymore. People can include the word/phrase IN their content, but there's no actual relevance to it beyond that anymore. I decided this meant it would only make sense to delete post_hashtag records if the corresponding hashtag no longer exists - so, I set it to CASCADE. 

fk_likes_post: If a user deletes one of their posts, there is no longer a need to store the metrics about that post such as liks. This data would no longer have any relevance or use, because the post is the only thing it related to. Because of this, I chose to set the rule to CASCADE.

fk_likes_user: If a user deletes their account from this platform, I do not believe it makes sense to store their previous likes on a post. Because user_id has to have a value. there has to be a valid user_id in that column in the likes table. If there isn't, the row and data are essentially useless. So, I set this up with a CASCADE rule as well. 

**Checks**

| CHECK constraint | Invalid state it prevents | How that state could otherwise arise |
|---|---|---|
| `chk_dob` | Prevents a user's birthday from being in the future. | A user could accidentally enter a future date as their date of birth when creating or updating their account. This may be adjusted to enforce an age limit later on.r |
| `chk_view_count` | Prevents a post from having a negative number of views. | An application error or incorrect update could set the `view_count` below zero. |
| `chk_dwell_ms` | Prevents a like from having a negative dwell time. | An application or data-entry error could record a negative number of milliseconds for the user's dwell time. |