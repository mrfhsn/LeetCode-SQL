Create table If Not Exists RequestAccepted (requester_id int not null, accepter_id int null, accept_date date null);
Truncate table RequestAccepted;
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09');

-- @block
SELECT
requester_id AS id
, COUNT(requester_id) AS cnt
FROM RequestAccepted
GROUP BY requester_id
;

-- @block
SELECT
accepter_id AS id
, COUNT(accepter_id) AS cnt
FROM RequestAccepted
GROUP BY accepter_id
;

-- @block
(SELECT
requester_id AS id
, COUNT(requester_id) AS cnt
FROM RequestAccepted
GROUP BY requester_id)
UNION ALL
(SELECT
accepter_id AS id
, COUNT(accepter_id) AS cnt
FROM RequestAccepted
GROUP BY accepter_id)
;

-- @block
WITH
tmp AS (
    (SELECT
    requester_id AS id
    , COUNT(requester_id) AS cnt
    FROM RequestAccepted
    GROUP BY requester_id)
    UNION ALL
    (SELECT
    accepter_id AS id
    , COUNT(accepter_id) AS cnt
    FROM RequestAccepted
    GROUP BY accepter_id)
)
SELECT
id
, SUM(cnt) AS num
FROM tmp
GROUP BY id
ORDER BY num DESC
LIMIT 1
;