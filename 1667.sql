DROP TABLE Users
-- @block
CREATE TABLE IF NOT EXISTS Users (user_id int, name varchar(40));
Truncate table Users;
insert into Users (user_id, name) values (1, 'aLice');
insert into Users (user_id, name) values (2, 'bOB');

-- @block
SELECT *
FROM Users
;

-- @block
SELECT user_id, LOWER(name)
FROM Users
;

-- @block
SELECT user_id, UPPER(name, 1)
FROM Users
;

-- @block
SELECT user_id, LEFT(name, 1)
FROM Users
;

-- @block
SELECT user_id, INSERT(name, 1, 2, "sef")
FROM Users
;

-- @block
SELECT user_id, CONCAT(name, "sef")
FROM Users
;

-- @block
SELECT user_id, SUBSTRING(name, 2, 3), SUBSTRING(name, 2)
FROM Users
;
-- @block
SELECT user_id, CONCAT(name, "sef")
FROM Users
;

-- @block
-- best
SELECT user_id, INSERT(LOWER(name), 1, 1, UPPER(LEFT(name, 1))) AS name
FROM Users
ORDER BY user_id
;

-- @block
SELECT user_id, CONCAT(UPPER(LEFT(name, 1)), SUBSTRING(LOWER(name), 2)) AS name
FROM Users
ORDER BY user_id
;

-- @block
SELECT user_id, CONCAT(UPPER(LEFT(name, 1)), LOWER(RIGHT(name, LENGTH(name)-1))) AS name
FROM Users
ORDER BY user_id
;