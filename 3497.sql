DROP TABLE IF Exists UserActivity;
CREATE TABLE if not exists UserActivity (
    user_id INT,
    activity_date DATE,
    activity_type VARCHAR(20),
    activity_duration INT
);
Truncate table UserActivity;
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('1', '2023-01-01', 'free_trial', '45');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('1', '2023-01-02', 'free_trial', '30');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('1', '2023-01-05', 'free_trial', '60');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('1', '2023-01-10', 'paid', '75');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('1', '2023-01-12', 'paid', '90');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('1', '2023-01-15', 'paid', '65');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('2', '2023-02-01', 'free_trial', '55');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('2', '2023-02-03', 'free_trial', '25');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('2', '2023-02-07', 'free_trial', '50');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('2', '2023-02-10', 'cancelled', '0');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('3', '2023-03-05', 'free_trial', '70');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('3', '2023-03-06', 'free_trial', '60');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('3', '2023-03-08', 'free_trial', '80');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('3', '2023-03-12', 'paid', '50');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('3', '2023-03-15', 'paid', '55');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('3', '2023-03-20', 'paid', '85');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('4', '2023-04-01', 'free_trial', '40');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('4', '2023-04-03', 'free_trial', '35');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('4', '2023-04-05', 'paid', '45');
insert into UserActivity (user_id, activity_date, activity_type, activity_duration) values ('4', '2023-04-07', 'cancelled', '0');

-- @block
SELECT
    user_id
    , activity_date
    , activity_type
    , activity_duration
    , RANK() OVER(PARTITION BY user_id ORDER BY activity_date)
FROM UserActivity
;

-- @block
SELECT
    user_id
    , SUM(CASE
        WHEN activity_type = 'free_trial' THEN activity_duration
        ELSE 0
    END) AS sm1
    , SUM(CASE
        WHEN activity_type = 'free_trial' THEN 1
        ELSE 0
    END) AS d1
    , SUM(CASE
        WHEN activity_type = 'paid' THEN activity_duration
        ELSE 0
    END) AS sm2
    , SUM(CASE
        WHEN activity_type = 'paid' THEN 1
        ELSE 0
    END) AS d2
FROM UserActivity
GROUP BY user_id
;

-- @block
WITH
tmp AS (
    SELECT
        user_id
        , ROUND(SUM(CASE
            WHEN activity_type = 'free_trial' THEN activity_duration
            ELSE 0
        END) / SUM(CASE
            WHEN activity_type = 'free_trial' THEN 1
            ELSE 0
        END), 2) AS trial_avg_duration
        , ROUND(SUM(CASE
            WHEN activity_type = 'paid' THEN activity_duration
            ELSE 0
        END) / SUM(CASE
            WHEN activity_type = 'paid' THEN 1
            ELSE 0
        END), 2) AS paid_avg_duration
    FROM UserActivity
    GROUP BY user_id
)
SELECT *
FROM tmp
WHERE paid_avg_duration IS NOT NULL
;