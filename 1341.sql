DROP TABLE Users;

Create table If Not Exists Movies (movie_id int, title varchar(30));
Create table If Not Exists Users (user_id int, name varchar(30));
Create table If Not Exists MovieRating (movie_id int, user_id int, rating int, created_at date);
Truncate table Movies;
insert into Movies (movie_id, title) values ('1', 'Avengers');
insert into Movies (movie_id, title) values ('2', 'Frozen 2');
insert into Movies (movie_id, title) values ('3', 'Joker');
Truncate table Users;
insert into Users (user_id, name) values ('1', 'Daniel');
insert into Users (user_id, name) values ('2', 'Monica');
insert into Users (user_id, name) values ('3', 'Maria');
insert into Users (user_id, name) values ('4', 'James');
Truncate table MovieRating;
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '1', '3', '2020-01-12');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '2', '4', '2020-02-11');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '3', '2', '2020-02-12');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '4', '1', '2020-01-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '1', '5', '2020-02-17');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '2', '2', '2020-02-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '3', '2', '2020-03-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('3', '1', '3', '2020-02-22');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('3', '2', '4', '2020-02-25');

-- @block
SELECT user_id, name
FROM Users
ORDER BY name
;

-- @block
SELECT
-- u.user_id, name
name AS result
-- , COUNT(movie_id) AS cnt
-- COUNT(movie_id) AS result
FROM Users AS u
LEFT JOIN MovieRating AS mr
ON u.user_id = mr.user_id
GROUP BY u.user_id, name
-- ORDER BY cnt DESC, name
ORDER BY COUNT(movie_id) DESC, name
-- ORDER BY result DESC, name
LIMIT 1
;

-- @block
SELECT
-- m.movie_id
-- , title
title AS result
-- , rating
-- , AVG(rating) AS rating
-- , created_at
FROM MovieRating AS mr
RIGHT JOIN Movies AS m
ON m.movie_id = mr.movie_id
WHERE LEFT(created_at, 7) = '2020-02'
GROUP BY m.movie_id, title
-- ORDER BY rating DESC, title
ORDER BY AVG(rating) DESC, title
LIMIT 1
;

-- @block
(SELECT
name AS results
FROM Users AS u
LEFT JOIN MovieRating AS mr
ON u.user_id = mr.user_id
GROUP BY u.user_id, name
ORDER BY COUNT(movie_id) DESC, name
LIMIT 1)
UNION ALL
(SELECT
title AS results
FROM MovieRating AS mr
RIGHT JOIN Movies AS m
ON m.movie_id = mr.movie_id
WHERE LEFT(created_at, 7) = '2020-02'
GROUP BY m.movie_id, title
ORDER BY AVG(rating) DESC, title
LIMIT 1)
;