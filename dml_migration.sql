-- Populate `users` table with existing data
INSERT INTO users ("username")
    SELECT DISTINCT username
    FROM bad_posts
UNION
    SELECT DISTINCT username
    FROM bad_comments
UNION
    SELECT DISTINCT REGEXP_SPLIT_TO_TABLE(upvotes, ',')
    FROM bad_posts
UNION
    SELECT DISTINCT REGEXP_SPLIT_TO_TABLE(downvotes, ',')
    FROM bad_posts;