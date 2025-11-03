Create table If Not Exists Logs (id int, num int);
Truncate table Logs;
insert into Logs (id, num) values ('1', '1');
insert into Logs (id, num) values ('2', '1');
insert into Logs (id, num) values ('3', '1');
insert into Logs (id, num) values ('4', '2');
insert into Logs (id, num) values ('5', '1');
insert into Logs (id, num) values ('6', '2');
insert into Logs (id, num) values ('7', '2');
insert into Logs (id, num) values ('8', '2');
insert into Logs (id, num) values ('9', '1');
insert into Logs (id, num) values ('10', '1');
insert into Logs (id, num) values ('11', '1');

-- @block
WITH
l2 AS (
    SELECT (id + 1) AS id, num
    FROM Logs
),
l3 AS (
    SELECT (id + 2) AS id, num
    FROM Logs
)
SELECT
-- *
DISTINCT l1.num AS ConsecutiveNums
FROM Logs AS l1
INNER JOIN l2
ON l1.id = l2.id
AND l1.num = l2.num
INNER JOIN l3
ON l1.id = l3.id
AND l1.num = l3.num
;