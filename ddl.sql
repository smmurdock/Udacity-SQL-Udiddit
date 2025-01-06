-----------------------------------------
-- USERS
-----------------------------------------
-- Create `users` table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(25) NOT NULL UNIQUE,
    last_login TIMESTAMP
    -- Add constraint
    CONSTRAINT "username_not_empty" CHECK (LENGTH(TRIM(username)) >= 0)
);

-- Create index on username
CREATE INDEX idx_users_username ON users(username);

-----------------------------------------
-- TOPICS
-----------------------------------------
-- Create `topics` table
CREATE TABLE topics (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) UNIQUE NOT NULL,
    description VARCHAR(500)
    -- Add constraint
    CONSTRAINT "topic_name_not_empty" CHECK (LENGTH(TRIM(name)) >= 0)
);

-- Create index on topic names
CREATE INDEX idx_topics_name ON topics(name);

-----------------------------------------
-- POSTS
-----------------------------------------
-- Create `posts` table
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    url VARCHAR(4000) DEFAULT NULL,
    text_content TEXT DEFAULT NULL,
    topic_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Add constraints
    CONSTRAINT check_url_or_text CHECK (
        (url IS NOT NULL and text_content IS NULL) OR
        (url IS NULL and text_content IS NOT NULL)
    ),
    -- Add constraint
    CONSTRAINT "post_title_not_empty" CHECK (LENGTH(TRIM(title)) >= 0)
    -- Add foreign key references
    FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Create index on post URL
CREATE INDEX idx_posts_url ON posts(url);
-- Create index on post topic_id
CREATE INDEX idx_posts_topic_id ON posts(topic_id);
-- Create index on post user_id
CREATE INDEX idx_posts_user_id ON posts(user_id);

-----------------------------------------
-- COMMENTS
-----------------------------------------
-- Create `comments` table
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    text_content TEXT NOT NULL,
    post_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    parent_comment_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Add constraint
    CONSTRAINT "comment_text_not_empty" CHECK (LENGTH(TRIM(text_content)) >= 0),
    -- Add foreign key references
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (parent_comment_id) REFERENCES comments(id) ON DELETE CASCADE
);

-- Create index on comment post_id
CREATE INDEX idx_comments_post_id ON comments(post_id);
-- Create index on comment user_id
CREATE INDEX idx_comments_user_id ON comments(user_id);
-- Create index on comment parent_comment_id
CREATE INDEX idx_comments_parent_comment_id ON comments(parent_comment_id);

-----------------------------------------
-- VOTES
-----------------------------------------
-- Create `votes` table
CREATE TABLE votes (
    id SERIAL PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    vote_value INT NOT NULL,
    -- Add constraints
    CONSTRAINT "vote_value_valid" CHECK (vote_value IN (-1, 1)),
    CONSTRAINT "vote_limit" UNIQUE (post_id, user_id),
    -- Add foreign key references
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Create index on vote post_id
CREATE INDEX idx_votes_post_id ON votes(post_id);
-- Create index on vote user_id
CREATE INDEX idx_votes_user_id ON votes(user_id);