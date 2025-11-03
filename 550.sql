DROP table Activity;
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');

-- @block
SELECT
player_id
, MIN(event_date) AS mnd
, ADDDATE(MIN(event_date), INTERVAL 1 DAY) AS amnd
FROM Activity
GROUP BY player_id

-- @block
SELECT
-- DISTINCT player_id
-- ,
COUNT(DISTINCT player_id)
FROM Activity
-- GROUP BY player_id
;

-- @block
WITH
tmp AS (
    SELECT
    player_id
    -- , MIN(event_date) AS mnd
    , ADDDATE(MIN(event_date), INTERVAL 1 DAY) AS amnd
    FROM Activity
    GROUP BY player_id
)
SELECT
ROUND(COUNT(*) / (
    SELECT
    COUNT(DISTINCT player_id)
    FROM Activity
), 2) AS fraction
FROM Activity AS a
INNER JOIN tmp
ON a.player_id = tmp.player_id
AND a.event_date = tmp.amnd
;