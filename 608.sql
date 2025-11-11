Create table If Not Exists Tree (id int, p_id int);
Truncate table Tree;
insert into Tree (id, p_id) values ('1', NULL);
insert into Tree (id, p_id) values ('2', '1');
insert into Tree (id, p_id) values ('3', '1');
insert into Tree (id, p_id) values ('4', '2');
insert into Tree (id, p_id) values ('5', '2');

-- @block
SELECT
p_id
, COUNT(p_id)
FROM Tree
GROUP BY p_id
;

-- @block
WITH
tmp AS (
    SELECT
    p_id
    , COUNT(p_id) AS cnt
    FROM Tree
    GROUP BY p_id
)
SELECT
t.id
, t.p_id
, tmp.cnt
FROM Tree AS t
LEFT JOIN tmp
ON t.id = tmp.p_id
;

-- @block
WITH
tmp AS (
    SELECT
    p_id
    , COUNT(p_id) AS cnt
    FROM Tree
    GROUP BY p_id
),
jnt AS (
    SELECT
    t.id
    , t.p_id
    , tmp.cnt
    FROM Tree AS t
    LEFT JOIN tmp
    ON t.id = tmp.p_id
)
SELECT
id,
CASE
    WHEN p_id IS NULL THEN 'Root'
    WHEN p_id IS NOT NULL AND cnt IS NOT NULL THEN 'Inner'
    ELSE 'Leaf'
END AS 'type'
FROM jnt
;