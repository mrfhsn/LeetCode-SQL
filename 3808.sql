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

-- @block
-> Sort: reaction_ratio DESC, rcnt.user_id  (cost=5.1..5.1 rows=0) (actual time=0.142..0.142 rows=2 loops=1)
    -> Filter: ((rcnt.trc >= 5) and ((rcnt.rc / rcnt.trc) >= 0.6))  (cost=5..5 rows=0) (actual time=0.134..0.135 rows=2 loops=1)
        -> Table scan on rcnt  (cost=5..5 rows=0) (actual time=0.129..0.13 rows=6 loops=1)
            -> Materialize CTE rcnt  (cost=2.5..2.5 rows=0) (actual time=0.129..0.129 rows=6 loops=1)
                -> Table scan on <temporary>  (cost=2.5..2.5 rows=0) (actual time=0.124..0.125 rows=6 loops=1)
                    -> Temporary table with deduplication  (cost=0..0 rows=0) (actual time=0.124..0.124 rows=6 loops=1)
                        -> Window aggregate with buffering: count(reactions.reaction) OVER (PARTITION BY reactions.user_id )   (actual time=0.102..0.114 rows=15 loops=1)
                            -> Sort: reactions.user_id  (actual time=0.0963..0.0975 rows=15 loops=1)
                                -> Table scan on <temporary>  (cost=2.5..2.5 rows=0) (actual time=0.0898..0.0914 rows=15 loops=1)
                                    -> Temporary table  (cost=0..0 rows=0) (actual time=0.0893..0.0893 rows=15 loops=1)
                                        -> Window aggregate with buffering: count(reactions.reaction) OVER (PARTITION BY reactions.user_id,reactions.reaction )   (actual time=0.0734..0.0858 rows=15 loops=1)
                                            -> Sort: reactions.user_id, reactions.reaction  (cost=1.75 rows=15) (actual time=0.057..0.058 rows=15 loops=1)
                                                -> Table scan on reactions  (cost=1.75 rows=15) (actual time=0.0304..0.0414 rows=15 loops=1)



-> Sort: reaction_ratio DESC, t.user_id  (actual time=0.0907..0.0908 rows=2 loops=1)
    -> Stream results  (cost=14.7 rows=30) (actual time=0.0773..0.0826 rows=2 loops=1)
        -> Nested loop inner join  (cost=14.7 rows=30) (actual time=0.0748..0.0792 rows=2 loops=1)
            -> Filter: (t.user_id is not null)  (cost=0.279..4.19 rows=15) (actual time=0.0461..0.0467 rows=3 loops=1)
                -> Table scan on t  (cost=2.5..2.5 rows=0) (actual time=0.0456..0.046 rows=3 loops=1)
                    -> Materialize CTE t  (cost=0..0 rows=0) (actual time=0.0452..0.0452 rows=3 loops=1)
                        -> Filter: (trc >= 5)  (actual time=0.0395..0.0401 rows=3 loops=1)
                            -> Table scan on <temporary>  (actual time=0.037..0.0374 rows=3 loops=1)
                                -> Aggregate using temporary table  (actual time=0.0364..0.0364 rows=3 loops=1)
                                    -> Table scan on reactions  (cost=1.75 rows=15) (actual time=0.0188..0.0264 rows=15 loops=1)
            -> Filter: ((r.rc / t.trc) >= 0.6)  (cost=0.257..0.513 rows=2) (actual time=0.00997..0.0105 rows=0.667 loops=3)
                -> Index lookup on r using <auto_key0> (user_id=t.user_id)  (cost=0.257..0.513 rows=2) (actual time=0.00863..0.0091 rows=2 loops=3)
                    -> Materialize CTE r  (cost=0..0 rows=0) (actual time=0.0236..0.0236 rows=6 loops=1)
                        -> Table scan on <temporary>  (actual time=0.019..0.0197 rows=6 loops=1)
                            -> Aggregate using temporary table  (actual time=0.0187..0.0187 rows=6 loops=1)
                                -> Table scan on reactions  (cost=1.75 rows=15) (actual time=0.0017..0.0075 rows=15 loops=1)


-> Sort: reaction_ratio DESC, t.user_id  (actual time=0.0963..0.0964 rows=2 loops=1)
    -> Stream results  (cost=14.7 rows=30) (actual time=0.082..0.0881 rows=2 loops=1)
        -> Nested loop inner join  (cost=14.7 rows=30) (actual time=0.0798..0.0849 rows=2 loops=1)
            -> Filter: (t.user_id is not null)  (cost=0.279..4.19 rows=15) (actual time=0.0748..0.0752 rows=3 loops=1)
                -> Table scan on t  (cost=2.5..2.5 rows=0) (actual time=0.0743..0.0747 rows=3 loops=1)
                    -> Materialize CTE t  (cost=0..0 rows=0) (actual time=0.074..0.074 rows=3 loops=1)
                        -> Filter: (trc >= 5)  (actual time=0.068..0.0688 rows=3 loops=1)
                            -> Table scan on <temporary>  (actual time=0.0658..0.0662 rows=3 loops=1)
                                -> Aggregate using temporary table  (actual time=0.0654..0.0654 rows=3 loops=1)
                                    -> Table scan on r  (cost=2.5..2.5 rows=0) (actual time=0.0567..0.0574 rows=6 loops=1)
                                        -> Materialize CTE r if needed  (cost=0..0 rows=0) (actual time=0.0563..0.0563 rows=6 loops=1)
                                            -> Table scan on <temporary>  (actual time=0.0489..0.0499 rows=6 loops=1)
                                                -> Aggregate using temporary table  (actual time=0.048..0.048 rows=6 loops=1)
                                                    -> Table scan on reactions  (cost=1.75 rows=15) (actual time=0.021..0.0307 rows=15 loops=1)
            -> Filter: ((r.rc / t.trc) >= 0.6)  (cost=0.257..0.513 rows=2) (actual time=0.0021..0.00263 rows=0.667 loops=3)
                -> Index lookup on r using <auto_key0> (user_id=t.user_id)  (cost=0.257..0.513 rows=2) (actual time=967e-6..0.00157 rows=2 loops=3)
                    -> Materialize CTE r if needed (query plan printed elsewhere)  (cost=0..0 rows=0) (never executed)


-> Sort: reaction_ratio DESC, t.user_id  (actual time=0.0817..0.0817 rows=2 loops=1)
    -> Stream results  (cost=14.7 rows=30) (actual time=0.07..0.0744 rows=2 loops=1)
        -> Nested loop inner join  (cost=14.7 rows=30) (actual time=0.0676..0.0714 rows=2 loops=1)
            -> Filter: (t.user_id is not null)  (cost=0.279..4.19 rows=15) (actual time=0.0633..0.0636 rows=3 loops=1)
                -> Table scan on t  (cost=2.5..2.5 rows=0) (actual time=0.0629..0.0632 rows=3 loops=1)
                    -> Materialize CTE t  (cost=0..0 rows=0) (actual time=0.0627..0.0627 rows=3 loops=1)
                        -> Filter: (trc >= 5)  (actual time=0.0568..0.0572 rows=3 loops=1)
                            -> Table scan on <temporary>  (actual time=0.0552..0.0555 rows=3 loops=1)
                                -> Aggregate using temporary table  (actual time=0.055..0.055 rows=3 loops=1)
                                    -> Table scan on r  (cost=2.5..2.5 rows=0) (actual time=0.0482..0.0488 rows=6 loops=1)
                                        -> Materialize CTE r if needed  (cost=0..0 rows=0) (actual time=0.0479..0.0479 rows=6 loops=1)
                                            -> Table scan on <temporary>  (actual time=0.042..0.0426 rows=6 loops=1)
                                                -> Aggregate using temporary table  (actual time=0.0415..0.0415 rows=6 loops=1)
                                                    -> Table scan on reactions  (cost=1.75 rows=15) (actual time=0.0197..0.0274 rows=15 loops=1)
            -> Filter: ((r.rc / t.trc) >= 0.6)  (cost=0.257..0.513 rows=2) (actual time=0.00163..0.00207 rows=0.667 loops=3)
                -> Index lookup on r using <auto_key0> (user_id=t.user_id)  (cost=0.257..0.513 rows=2) (actual time=833e-6..0.00127 rows=2 loops=3)
                    -> Materialize CTE r if needed (query plan printed elsewhere)  (cost=0..0 rows=0) (never executed)


