-- =================================================================
-- EX 603 Assignment 2 — schema.sql
-- Theme: Social Media
-- Author: Aamnah M.
-- Target: PostgreSQL 14+
-- =================================================================
-- Reset. Reverse creation order, so no dependency blocks a drop.

DROP TABLE IF EXISTS likes    CASCADE;
DROP TABLE IF EXISTS post_hashtags   CASCADE;
DROP TABLE IF EXISTS posts   CASCADE;
DROP TABLE IF EXISTS hashtags   CASCADE;
DROP TABLE IF EXISTS users    CASCADE;

-- Table creation

CREATE TABLE users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(30),
    dob DATE NOT NULL,
    account_creation_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    constraint chk_dob
        CHECK (dob <= CURRENT_DATE)
);

CREATE TABLE hashtags (
    hashtag_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hashtag_name VARCHAR (40) NOT NULL UNIQUE
);

CREATE TABLE posts (
    post_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    view_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    constraint fk_posts_user
        FOREIGN KEY(user_id)
        REFERENCES users(user_id) ON DELETE CASCADE,
    constraint chk_view_count
        CHECK(view_count >= 0)
);

CREATE TABLE post_hashtags (
    post_id INTEGER NOT NULL,
    hashtag_id INTEGER NOT NULL,
    constraint pk_junction_ph
        PRIMARY KEY(post_id, hashtag_id),
    constraint fk_ph_posts
        FOREIGN KEY(post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE,
    constraint fk_ph_hashtag
        FOREIGN KEY(hashtag_id)
        REFERENCES hashtags(hashtag_id)
        ON DELETE CASCADE
);

CREATE TABLE likes (
    post_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    liked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dwell_ms INTEGER NOT NULL,
    constraint pk_junction_likes
        PRIMARY KEY(post_id, user_id),
    constraint fk_likes_post
        FOREIGN KEY(post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE,
    constraint fk_likes_user
        FOREIGN KEY(user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,
    constraint chk_dwell_ms
        CHECK(dwell_ms >= 0)
);