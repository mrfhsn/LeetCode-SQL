Create table If Not Exists Queue (person_id int, person_name varchar(30), weight int, turn int);
Truncate table Queue;
insert into Queue (person_id, person_name, weight, turn) values ('5', 'Alice', '250', '1');
insert into Queue (person_id, person_name, weight, turn) values ('4', 'Bob', '175', '5');
insert into Queue (person_id, person_name, weight, turn) values ('3', 'Alex', '350', '2');
insert into Queue (person_id, person_name, weight, turn) values ('6', 'John Cena', '400', '3');
insert into Queue (person_id, person_name, weight, turn) values ('1', 'Winston', '500', '6');
insert into Queue (person_id, person_name, weight, turn) values ('2', 'Marie', '200', '4');

-- @block
Create table If Not Exists Queue (person_id int, person_name varchar(30), weight int, turn int);
Truncate table Queue;
insert into Queue (person_id, person_name, weight, turn) values ('5', 'Alice', '50', '1');
insert into Queue (person_id, person_name, weight, turn) values ('4', 'Bob', '75', '5');
insert into Queue (person_id, person_name, weight, turn) values ('3', 'Alex', '50', '2');
insert into Queue (person_id, person_name, weight, turn) values ('6', 'John Cena', '40', '3');
insert into Queue (person_id, person_name, weight, turn) values ('1', 'Winston', '50', '6');
insert into Queue (person_id, person_name, weight, turn) values ('2', 'Marie', '20', '4');

-- @block
SELECT
-- person_id
-- ,
person_name
-- , turn
-- , weight
, SUM(weight) OVER(ORDER BY turn) AS sum_wght
FROM Queue
;

-- @block
SELECT
person_name
-- , sum_wght
FROM (
    SELECT
    person_name
    , SUM(weight) OVER(ORDER BY turn) AS sum_wght
    FROM Queue
) AS tmp
WHERE sum_wght <= 1000
ORDER BY sum_wght DESC
LIMIT 1
;

-- @block
WITH
tmp AS (
    SELECT
    person_name
    , SUM(weight) OVER(ORDER BY turn) AS sum_wght
    FROM Queue
)
SELECT
person_name
-- , sum_wght
FROM tmp
WHERE sum_wght <= 1000
ORDER BY sum_wght DESC
LIMIT 1
;