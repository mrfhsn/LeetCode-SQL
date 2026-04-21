DROP TABLE IF Exists reactions;

CREATE TABLE reactions (
    user_id INT,
    content_id INT,
    reaction VARCHAR(255)
);

Truncate table reactions;
insert into reactions (user_id, content_id, reaction) values ('1', '101', 'like');
insert into reactions (user_id, content_id, reaction) values ('1', '102', 'like');
insert into reactions (user_id, content_id, reaction) values ('1', '103', 'like');
insert into reactions (user_id, content_id, reaction) values ('1', '104', 'wow');
insert into reactions (user_id, content_id, reaction) values ('1', '105', 'like');
insert into reactions (user_id, content_id, reaction) values ('2', '201', 'like');
insert into reactions (user_id, content_id, reaction) values ('2', '202', 'wow');
insert into reactions (user_id, content_id, reaction) values ('2', '203', 'sad');
insert into reactions (user_id, content_id, reaction) values ('2', '204', 'like');
insert into reactions (user_id, content_id, reaction) values ('2', '205', 'wow');
insert into reactions (user_id, content_id, reaction) values ('3', '301', 'love');
insert into reactions (user_id, content_id, reaction) values ('3', '302', 'love');
insert into reactions (user_id, content_id, reaction) values ('3', '303', 'love');
insert into reactions (user_id, content_id, reaction) values ('3', '304', 'love');
insert into reactions (user_id, content_id, reaction) values ('3', '305', 'love');

-- @block
SELECT
    user_id,
    COUNT(reaction)
FROM reactions
GROUP BY user_id
;

-- @block
SELECT
    user_id,
    reaction,
    COUNT(reaction)
FROM reactions
GROUP BY user_id, reaction
;

-- @block
SELECT DISTINCT
    user_id,
    reaction,
    -- COUNT(reaction),
    COUNT(reaction) OVER (PARTITION BY user_id, reaction) AS rc,
    COUNT(reaction) OVER (PARTITION BY user_id) AS trc
FROM reactions
-- GROUP BY user_id, reaction
;

-- @block
EXPLAIN ANALYZE
WITH
rcnt AS (
    SELECT DISTINCT
        user_id,
        reaction,
        COUNT(reaction) OVER (PARTITION BY user_id, reaction) AS rc,
        COUNT(reaction) OVER (PARTITION BY user_id) AS trc
    FROM reactions
)
SELECT
    user_id,
    reaction AS dominant_reaction,
    ROUND((rc / trc), 2) AS reaction_ratio 
FROM rcnt
WHERE trc >= 5
AND (rc / trc) >= 0.6
ORDER BY reaction_ratio DESC, user_id
;

-- @block
EXPLAIN ANALYZE
WITH
t AS (
    SELECT
        user_id,
        COUNT(reaction) AS trc
    FROM reactions
    GROUP BY user_id
),
r AS (
    SELECT
        user_id,
        reaction,
        COUNT(reaction) AS rc
    FROM reactions
    GROUP BY user_id, reaction
)
SELECT 
    t.user_id,
    r.reaction AS dominant_reaction,
    ROUND((rc / trc), 2) AS reaction_ratio
FROM t
JOIN r
ON r.user_id = t.user_id
WHERE trc >= 5
AND (rc / trc) >= 0.6
ORDER BY reaction_ratio DESC, user_id
;

-- @block
-- EXPLAIN ANALYZE
WITH
r AS (
    SELECT
        user_id,
        reaction,
        COUNT(reaction) AS rc
    FROM reactions
    GROUP BY user_id, reaction
),
t AS (
    SELECT
        user_id,
        SUM(rc) AS trc
    FROM r
    GROUP BY user_id
    HAVING trc >= 5
)
SELECT 
    t.user_id,
    r.reaction AS dominant_reaction,
    ROUND((rc / trc), 2) AS reaction_ratio
FROM t
JOIN r
ON r.user_id = t.user_id
WHERE (rc / trc) >= 0.6
ORDER BY reaction_ratio DESC, user_id
;
