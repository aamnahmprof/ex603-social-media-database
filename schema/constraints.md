### USERS

| Constraint | Justification |
|---|---|
| `user_id GENERATED ALWAYS AS IDENTITY` | Automatically generates an identifier for each newly created user. |
| `PRIMARY KEY (user_id)` | Forces every newly generated ID to be unique. |
| `username UNIQUE` | Prevents multiple users from having the same username. |
| `username NOT NULL` | Every account must have a username. |
| `first_name NOT NULL` | A user's first name is required. |
| `last_name NOT NULL` | A user's last name is required. |
| `dob NOT NULL` | A date of birth is required for every user, allowing age determination if/when needed. |
| `account_creation_date NOT NULL` | Every user account must have a recorded creation date for business data. |
| `account_creation_date DEFAULT CURRENT_TIMESTAMP` | Automatically records when the account was created if no value is provided. |

### POSTS

| Constraint | Justification |
|---|---|
| `PRIMARY KEY (post_id)` | Uniquely identifies every post. |
| `post_id GENERATED ALWAYS AS IDENTITY` | Automatically generates a unique identifier for each new post. |
| `user_id FOREIGN KEY REFERENCES USERS(user_id)` | Ensures that every post belongs to an existing user. |
| `user_id NOT NULL` | A post must have an author. |
| `content NOT NULL` | Every post must contain content. |
| `is_active NOT NULL` | Ensures every post has an explicitly defined active/inactive status. |
| `is_active DEFAULT TRUE` | Newly created posts are active by default. |
| `view_count NOT NULL` | Ensures every post has a defined view count. |
| `view_count DEFAULT 0` | A newly created post starts with zero views. |
| `created_at NOT NULL` | Every post must have a creation timestamp. |
| `created_at DEFAULT CURRENT_TIMESTAMP` | Automatically records when the post was created. |
| `ON DELETE CASCADE` on `user_id` | If a user is deleted, their posts are also deleted because a post cannot exist without its author. |

### LIKES

| Constraint | Justification |
|---|---|
| `PRIMARY KEY (post_id, user_id)` | Prevents the same user from liking the same post more than once. |
| `post_id FOREIGN KEY REFERENCES POSTS(post_id)` | Ensures that every like refers to an existing post. |
| `user_id FOREIGN KEY REFERENCES USERS(user_id)` | Ensures that every like belongs to an existing user. |
| `post_id NOT NULL` | Every like must reference a post. |
| `user_id NOT NULL` | Every like must reference a user. |
| `liked_at NOT NULL` | Ensures that the time of the like is recorded. |
| `liked_at DEFAULT CURRENT_TIMESTAMP` | Automatically records when the like was created. |
| `dwell_ms NOT NULL` | Ensures that the key metric of time spent on the post is recorded for every like. |
| `ON DELETE CASCADE` on `post_id` | If a post is deleted, its likes are also deleted because they cannot exist without the post. |
| `ON DELETE CASCADE` on `user_id` | If a user is deleted, their likes are also deleted because they cannot exist without the user. |

### HASHTAGS

| Constraint | Justification |
|---|---|
| `PRIMARY KEY (hashtag_id)` | Uniquely identifies each hashtag. |
| `hashtag_id GENERATED ALWAYS AS IDENTITY` | Automatically generates an identifier for each new hashtag. |
| `hashtag_name UNIQUE` | Prevents duplicate hashtags. |
| `hashtag_name NOT NULL` | Every hashtag must have a name. |

### POST_HASHTAGS

| Constraint | Justification |
|---|---|
| `PRIMARY KEY (post_id, hashtag_id)` | Prevents the same hashtag from being associated with the same post more than once. |
| `post_id FOREIGN KEY REFERENCES POSTS(post_id)` | Ensures that every association refers to an existing post. |
| `hashtag_id FOREIGN KEY REFERENCES HASHTAGS(hashtag_id)` | Ensures that every association refers to an existing hashtag. |
| `post_id NOT NULL` | Every association must identify a post. |
| `hashtag_id NOT NULL` | Every association must identify a hashtag. |
| `ON DELETE CASCADE` on `post_id` | If a post is deleted, its hashtag associations are also deleted. |
| `ON DELETE CASCADE` on `hashtag_id` | If a hashtag is deleted, its post associations are also deleted. |

### Additional CHECK Constraints

| Constraint | Justification |
|---|---|
| `CHECK (view_count >= 0)` | A post cannot have a negative number of views. |
| `CHECK (dwell_ms >= 0)` | A dwell time cannot be negative. |
| `CHECK (dob <= CURRENT_DATE)` | Prevents a user's date of birth from being set to a future date. |