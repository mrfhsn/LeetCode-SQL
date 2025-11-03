CREATE TABLE if not exists subscription_events (
    event_id INT,
    user_id INT,
    event_date DATE,
    event_type VARCHAR(20),
    plan_name VARCHAR(20),
    monthly_amount DECIMAL(10,2)
);
Truncate table subscription_events;
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('1', '501', '2024-01-01', 'start', 'premium', '29.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('2', '501', '2024-02-15', 'downgrade', 'standard', '19.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('3', '501', '2024-03-20', 'downgrade', 'basic', '9.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('4', '502', '2024-01-05', 'start', 'standard', '19.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('5', '502', '2024-02-10', 'upgrade', 'premium', '29.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('6', '502', '2024-03-15', 'downgrade', 'basic', '9.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('7', '503', '2024-01-10', 'start', 'basic', '9.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('8', '503', '2024-02-20', 'upgrade', 'standard', '19.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('9', '503', '2024-03-25', 'upgrade', 'premium', '29.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('10', '504', '2024-01-15', 'start', 'premium', '29.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('11', '504', '2024-03-01', 'downgrade', 'standard', '19.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('12', '504', '2024-03-30', 'cancel', NULL, '0.0');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('13', '505', '2024-02-01', 'start', 'basic', '9.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('14', '505', '2024-02-28', 'upgrade', 'standard', '19.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('15', '506', '2024-01-20', 'start', 'premium', '29.99');
insert into subscription_events (event_id, user_id, event_date, event_type, plan_name, monthly_amount) values ('16', '506', '2024-03-10', 'downgrade', 'basic', '9.99');

-- @block
-- active + last revenue
WITH
mxed AS (
    SELECT
    user_id
    , MAX(event_date) AS ed
    FROM subscription_events
    GROUP BY user_id
)
SELECT
se.user_id
, se.monthly_amount AS current_monthly_amount
-- , se.event_type
-- , se.event_date
, se.plan_name AS current_plan 
FROM mxed
LEFT JOIN subscription_events AS se
ON mxed.user_id = se.user_id
AND mxed.ed = se.event_date
WHERE event_type != 'cancel'
;

-- @block
-- downgrade
SELECT
user_id
, event_type
FROM subscription_events
WHERE event_type = 'downgrade'
GROUP BY user_id
;

-- @block
-- max revenue
SELECT
user_id
, MAX(monthly_amount) AS max_historical_amount
FROM subscription_events
GROUP BY user_id
;

-- @block
-- sub time
SELECT
user_id
-- , MIN(event_date)
-- , MAX(event_date)
, DATEDIFF(MAX(event_date), MIN(event_date)) AS days_as_subscriber 
FROM subscription_events
GROUP BY user_id
-- HAVING DATEDIFF(MAX(event_date), MIN(event_date)) >= 60
;

-- @block
-- 3
SELECT
user_id
, MAX(monthly_amount) AS max_historical_amount
, DATEDIFF(MAX(event_date), MIN(event_date)) AS days_as_subscriber 
, MAX(event_date) AS ed
FROM subscription_events
GROUP BY user_id
;


-- @block
WITH
tmp AS (
    SELECT
    user_id
    , MAX(monthly_amount) AS max_historical_amount
    , DATEDIFF(MAX(event_date), MIN(event_date)) AS days_as_subscriber 
    , MAX(event_date) AS ed
    FROM subscription_events
    GROUP BY user_id
),
dgrade AS (
    SELECT
    user_id
    FROM subscription_events
    WHERE event_type = 'downgrade'
    GROUP BY user_id
)
SELECT
se.user_id
, se.plan_name AS current_plan 
, se.monthly_amount AS current_monthly_amount
, max_historical_amount
, days_as_subscriber 
FROM tmp
LEFT JOIN subscription_events AS se
ON tmp.user_id = se.user_id
AND tmp.ed = se.event_date
WHERE event_type != 'cancel'
AND days_as_subscriber >= 60
AND (se.monthly_amount / max_historical_amount) < 0.5
ORDER BY days_as_subscriber DESC, user_id ASC
;
