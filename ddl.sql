-- Create `users` table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(25) UNIQUE NOT NULL
);

-- Create `topics` table
CREATE TABLE topics (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) UNIQUE NOT NULL,
    description VARCHAR(500)
);

-- Create `posts` table
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    url VARCHAR(4000) DEFAULT NULL,
    text_content TEXT DEFAULT NULL,
    topic_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    CONSTRAINT check_url_or_text CHECK (
        (url IS NOT NULL and text_content IS NULL) OR
        (url IS NULL and text_content IS NOT NULL)
    ),
    FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Create `comments` table
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    text_content NOT NULL,
    parent_comment_id DEFAULT NULL,
    post_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (parent_comment_id) REFERENCES comments(id) ON DELETE CASCADE
);