CREATE TABLE If not exists user_content (
    content_id INT,
    content_text VARCHAR(255)
);
Truncate table user_content;
insert into user_content (content_id, content_text) values ('1', 'hello world of SQL');
insert into user_content (content_id, content_text) values ('2', 'the QUICK-brown fox');
insert into user_content (content_id, content_text) values ('3', 'modern-day DATA science');
insert into user_content (content_id, content_text) values ('4', 'web-based FRONT-end development');

-- @block
SELECT
content_id
,
CASE
    WHEN content_text LIKE "% _%" THEN 
END
FROM user_content
;