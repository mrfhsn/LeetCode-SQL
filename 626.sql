Create table If Not Exists Seat (id int, student varchar(255));
Truncate table Seat;
insert into Seat (id, student) values ('1', 'Abbot');
insert into Seat (id, student) values ('2', 'Doris');
insert into Seat (id, student) values ('3', 'Emerson');
insert into Seat (id, student) values ('4', 'Green');
insert into Seat (id, student) values ('5', 'Jeames');

-- @block
SELECT COUNT(*)
FROM Seat

-- @block
WITH
odd AS (
    SELECT (id - 1) AS id, student
    FROM Seat
    WHERE id % 2 = 0
)
even AS (
    SELECT (id + 1) AS id, student
    FROM Seat
    WHERE id % 2 != 0
)
-- cnt AS (
--     SELECT COUNT(*) AS cnt
--     FROM Seat
-- )
SELECT
CASE
    WHEN (SELECT COUNT(*) AS cnt FROM Seat) % 2 != 0
    THEN (
        CASE
            WHEN id = (SELECT COUNT(*) AS cnt FROM Seat)
            THEN id - 1
        END
    )
END AS id, student
FROM odd
UNION
SELECT *
FROM even;


-- @block
SELECT
CASE
    WHEN id % 2 != 0
    THEN
        CASE
            WHEN id = (SELECT COUNT(*) AS cnt FROM Seat)
            THEN id
            ELSE id + 1
        END
    ELSE id - 1
END AS id
, student
FROM Seat
ORDER BY id
;


-- @block
SELECT (id - 1) AS id, student
    FROM Seat
    WHERE id % 2 = 0
;

-- @block
SELECT (id + 1) AS id, student
    FROM Seat
    WHERE id % 2 != 0
;

-- @block
-- WITH
-- cnt AS (
--     SELECT COUNT(*) AS cnt
--     FROM Seat
-- )
SELECT
CASE
    -- WHEN cnt.cnt % 2 != 0 THEN "YES"
    WHEN (SELECT COUNT(*) AS cnt
    FROM Seat) % 2 != 0 THEN "YES"
    ELSE "yes"
END AS "done"
-- FROM cnt
FROM Seat
;