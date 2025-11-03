Create table If Not Exists Person (Id int, Email varchar(255));
Truncate table Person;
insert into Person (id, email) values ('1', 'john@example.com');
insert into Person (id, email) values ('2', 'bob@example.com');
insert into Person (id, email) values ('3', 'john@example.com');

-- @block
SELECT MIN(id) AS id, email
FROM Person
GROUP BY email;
;

-- @block
WITH
em AS (
    SELECT MIN(id) AS id, email
    FROM Person
    GROUP BY email
)
SELECT p.id
-- , p.email
-- , em.id
FROM Person AS p
LEFT JOIN em
ON em.id = p.id
WHERE em.id IS NULL
;

-- @block
SELECT p.id
-- , p.email
-- , em.id
FROM Person AS p
LEFT JOIN (
    SELECT MIN(id) AS id, email
    FROM Person
    GROUP BY email
) AS em
ON em.id = p.id
WHERE em.id IS NULL
;

-- @block
-- "You can't specify target table 'Person' for update in FROM clause"
-- Don't use subquery in WHERE

-- SELECT *
DELETE
FROM Person
WHERE id NOT IN (
    WITH
    em AS (
        SELECT MIN(id) AS id, email
        FROM Person
        GROUP BY email
    )
    SELECT p.id
    -- , p.email
    FROM Person AS p
    RIGHT JOIN em
    ON em.id = p.id
)
;


-- @block
-- SELECT *
DELETE
FROM Person AS ps
INNER JOIN (
    SELECT p.id
    -- , p.email
    -- , em.id
    FROM Person AS p
    LEFT JOIN (
        SELECT MIN(id) AS id, email
        FROM Person
        GROUP BY email
    ) AS em
    ON em.id = p.id
    WHERE em.id IS NULL
) AS tmp
ON tmp.id = ps.id
;


-- @block
-- Uhh! How I would have known this
-- Step 1: Create a temporary table to store the IDs to delete
CREATE TEMPORARY TABLE tmp_ids AS
SELECT p.id
FROM Person AS p
LEFT JOIN (
    SELECT MIN(id) AS id, email
    FROM Person
    GROUP BY email
) AS em ON em.id = p.id
WHERE em.id IS NULL;

-- Step 2: Delete the rows in the original table based on the IDs in the temporary table
DELETE FROM Person
WHERE id IN (SELECT id FROM tmp_ids);

-- Step 3: Drop the temporary table
DROP TEMPORARY TABLE tmp_ids;

-- @block
DELETE p
FROM Person AS p, Person AS q
WHERE p.Id > q.Id 
AND p.Email = q.Email
;