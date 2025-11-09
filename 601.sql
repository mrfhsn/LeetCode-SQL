Create table If Not Exists Stadium (id int, visit_date DATE NULL, people int);
Truncate table Stadium;
insert into Stadium (id, visit_date, people) values ('1', '2017-01-01', '10');
insert into Stadium (id, visit_date, people) values ('2', '2017-01-02', '109');
insert into Stadium (id, visit_date, people) values ('3', '2017-01-03', '150');
insert into Stadium (id, visit_date, people) values ('4', '2017-01-04', '99');
insert into Stadium (id, visit_date, people) values ('5', '2017-01-05', '145');
insert into Stadium (id, visit_date, people) values ('6', '2017-01-06', '1455');
insert into Stadium (id, visit_date, people) values ('7', '2017-01-07', '199');
insert into Stadium (id, visit_date, people) values ('8', '2017-01-09', '188');

-- @block
SELECT
id
, visit_date
, people
, LEAD(id) OVER(ORDER BY id) AS l1i
, LEAD(people) OVER(ORDER BY id) AS l1p
, LEAD(id, 2) OVER(ORDER BY id) AS l2i
, LEAD(people, 2) OVER(ORDER BY id) AS l2p
FROM Stadium
;

-- @block
SELECT
id
, visit_date
, people
, LAG(id) OVER(ORDER BY id) AS l1i
, LAG(people) OVER(ORDER BY id) AS l1p
, LAG(id, 2) OVER(ORDER BY id) AS l2i
, LAG(people, 2) OVER(ORDER BY id) AS l2p
FROM Stadium
;

-- @block
WITH
ld AS (
SELECT
    id
    , people
    , LEAD(id) OVER(ORDER BY id) AS l1i
    , LEAD(people) OVER(ORDER BY id) AS l1p
    , LEAD(id, 2) OVER(ORDER BY id) AS l2i
    , LEAD(people, 2) OVER(ORDER BY id) AS l2p
    FROM Stadium
)
SELECT
id
, CASE
    WHEN people >= 100 AND l1i = id + 1 AND l2i = id + 2 AND l1p >= 100 AND l2p >= 100 THEN people
END AS people
FROM ld
;

-- @block
WITH
ld AS (
SELECT
    id
    , people
    , LEAD(id) OVER(ORDER BY id) AS l1i
    , LEAD(people) OVER(ORDER BY id) AS l1p
    , LEAD(id, 2) OVER(ORDER BY id) AS l2i
    , LEAD(people, 2) OVER(ORDER BY id) AS l2p
    FROM Stadium
),
cs AS (
    SELECT
    id
    , CASE
        WHEN people >= 100 AND l1i = id + 1 AND l2i = id + 2 AND l1p >= 100 AND l2p >= 100 THEN people
    END AS people
    FROM ld
)
SELECT
DISTINCT
st.id
, st.visit_date 
, st.people
FROM Stadium AS st
INNER JOIN cs
ON st.id = cs.id
OR st.id = cs.id + 1
OR st.id = cs.id + 2
WHERE cs.people IS NOT NULL
ORDER BY st.visit_date
;