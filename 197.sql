Create table If Not Exists Weather (id int, recordDate date, temperature int);
Truncate table Weather;
insert into Weather (id, recordDate, temperature) values ('1', '2015-01-01', '10');
insert into Weather (id, recordDate, temperature) values ('2', '2015-01-02', '25');
insert into Weather (id, recordDate, temperature) values ('3', '2015-01-03', '20');
insert into Weather (id, recordDate, temperature) values ('4', '2015-01-04', '30');

-- @block
SELECT
-- id, recordDate, ADDDATE(recordDate, INTERVAL 1 DAY), temperature
id
, w1.recordDate
, w2.recordDate
, w1.temperature
, w2.temperature
FROM Weather AS w1
INNER JOIN Weather AS w2
ON w1.recordDate = w2.ADDDATE(recordDate, INTERVAL 1 DAY) AS recordDate

;

-- @block
WITH
y AS (
    SELECT ADDDATE(recordDate, INTERVAL 1 DAY) AS recordDate, temperature
    FROM Weather
)
SELECT 
w.id
-- , w.recordDate
-- , y.recordDate
-- , w.temperature
-- , y.temperature
FROM Weather AS w
INNER JOIN y
ON w.recordDate = y.recordDate
AND w.temperature > y.temperature
;