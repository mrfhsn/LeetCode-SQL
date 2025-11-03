Create table If Not Exists Users (user_id int, user_name varchar(20));
Create table If Not Exists Register (contest_id int, user_id int);
Truncate table Users;
insert into Users (user_id, user_name) values ('6', 'Alice');
insert into Users (user_id, user_name) values ('2', 'Bob');
insert into Users (user_id, user_name) values ('7', 'Alex');
Truncate table Register;
insert into Register (contest_id, user_id) values ('215', '6');
insert into Register (contest_id, user_id) values ('209', '2');
insert into Register (contest_id, user_id) values ('208', '2');
insert into Register (contest_id, user_id) values ('210', '6');
insert into Register (contest_id, user_id) values ('208', '6');
insert into Register (contest_id, user_id) values ('209', '7');
insert into Register (contest_id, user_id) values ('209', '6');
insert into Register (contest_id, user_id) values ('215', '7');
insert into Register (contest_id, user_id) values ('208', '7');
insert into Register (contest_id, user_id) values ('210', '2');
insert into Register (contest_id, user_id) values ('207', '2');
insert into Register (contest_id, user_id) values ('210', '7');


-- @block
SELECT
u.user_id, user_name
, contest_id, r.user_id
-- , AS percentage
FROM Users AS u
-- CROSS JOIN Register AS r
INNER JOIN Register AS r
ON u.user_id = r.user_id
-- ORDER BY contest_id
ORDER BY u.user_id
;

-- @block
SELECT
contest_id
, r.user_id
, uu.user_id
, u.user_id, u.user_name
-- , AS percentage
FROM Register AS r
CROSS JOIN Users AS u
LEFT JOIN Users AS uu
ON r.user_id = uu.user_id
ORDER BY contest_id
;


-- @block
SELECT DISTINCT contest_id
, u.user_id
FROM Register AS r
CROSS JOIN Users AS u
ORDER BY contest_id
;

-- @block
-- EXPLAIN ANALYZE
WITH
dis_res AS (
    SELECT DISTINCT contest_id
    , u.user_id
    FROM Register AS r
    CROSS JOIN Users AS u
    -- ORDER BY contest_id
)
SELECT dr.contest_id
-- , COUNT(dr.user_id)
-- , COUNT(rr.user_id)
, ROUND((COUNT(rr.user_id) * 100 / COUNT(dr.user_id)), 2) AS percentage 
FROM dis_res AS dr
LEFT JOIN Register AS rr
ON dr.user_id = rr.user_id
AND dr.contest_id = rr.contest_id
GROUP BY dr.contest_id
-- ORDER BY contest_id
ORDER BY percentage DESC, contest_id ASC
;

-- @block
-- EXPLAIN ANALYZE
SELECT DISTINCT r.contest_id
-- , u.user_id
-- , rr.user_id
-- , COUNT(u.user_id)
-- , COUNT(rr.user_id)
, ROUND((COUNT(rr.user_id) * 100 / COUNT(u.user_id)), 2) AS percentage
FROM Register AS r
CROSS JOIN Users AS u
LEFT JOIN Register AS rr
ON u.user_id = rr.user_id
AND r.contest_id = rr.contest_id
GROUP BY r.contest_id
-- ORDER BY contest_id
ORDER BY percentage DESC, contest_id ASC
;