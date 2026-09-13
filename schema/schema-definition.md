## This documentation details each relation, its attributes, the primary key for each relation, and each attribute's domain and constraints.

### **Relations**

USERS (
    user_id,
    username,
    first_name,
    last_name,
    email,
    phone,
    dob,
    account_creation_dt
)

POSTS (
    post_id,
    user_id,
    content,
    is_active,
    view_count,
    created_at
)

LIKES (
    post_id,
    user_id,
    liked_at,
    dwell_ms
)

HASHTAGS (
    hashtag_id,
    hashtag_name
)

POST_HASHTAGS (
    post_id,
    hashtag_id
)

### **Primary Keys**
| Relation | Primary Key |
|---|---|
| **USERS** | `user_id` |
| **POSTS** | `post_id` |
| **LIKES** | (`post_id`, `user_id`) |
| **HASHTAGS** | `hashtag_id` |
| **POST_HASHTAGS** | (`post_id`, `hashtag_id`) |

### **Domains**

| Relation | Attribute | Domain | 
|---|---|---|
| **USERS** | `user_id` | `INTEGER` |
| | `username` | `VARCHAR` |
| | `first_name` | `VARCHAR` |
| | `last_name` | `VARCHAR` |
| | `email` | `VARCHAR` |
| | `phone` | `VARCHAR` |
| | `dob` | `DATE` |
| | `account_creation_dt` | `TIMESTAMP` |
| **POSTS** | `post_id` | `INTEGER` |
| | `user_id` | `INTEGER` |
| | `content` | `VARCHAR` |
| | `is_active` | `BOOLEAN` |
| | `view_count` | `INTEGER` |
| | `created_at` | `TIMESTAMP` |
| **LIKES** | `post_id` | `INTEGER` |
| | `user_id` | `INTEGER` |
| | `liked_at` | `TIMESTAMP` |
| | `dwell_ms` | `INTEGER` |
| **HASHTAGS** | `hashtag_id` | `INTEGER` |
| | `hashtag_name` | `VARCHAR` |
| **POST_HASHTAGS** | `post_id` | `INTEGER` |
| | `hashtag_id` | `INTEGER` |
