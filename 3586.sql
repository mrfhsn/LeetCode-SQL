DROP TABLE IF exists patients;
DROP TABLE IF exists covid_tests;
CREATE TABLE patients (
    patient_id INT,
    patient_name VARCHAR(255),
    age INT
);
CREATE TABLE covid_tests (
    test_id INT,
    patient_id INT,
    test_date DATE,
    result VARCHAR(50)
);
Truncate table patients;
insert into patients (patient_id, patient_name, age) values ('1', 'Alice Smith', '28');
insert into patients (patient_id, patient_name, age) values ('2', 'Bob Johnson', '35');
insert into patients (patient_id, patient_name, age) values ('3', 'Carol Davis', '42');
insert into patients (patient_id, patient_name, age) values ('4', 'David Wilson', '31');
insert into patients (patient_id, patient_name, age) values ('5', 'Emma Brown', '29');
Truncate table covid_tests;
insert into covid_tests (test_id, patient_id, test_date, result) values ('1', '1', '2023-01-15', 'Positive');
insert into covid_tests (test_id, patient_id, test_date, result) values ('2', '1', '2023-01-25', 'Negative');
insert into covid_tests (test_id, patient_id, test_date, result) values ('3', '2', '2023-02-01', 'Positive');
insert into covid_tests (test_id, patient_id, test_date, result) values ('4', '2', '2023-02-05', 'Inconclusive');
insert into covid_tests (test_id, patient_id, test_date, result) values ('5', '2', '2023-02-12', 'Negative');
insert into covid_tests (test_id, patient_id, test_date, result) values ('6', '3', '2023-01-20', 'Negative');
insert into covid_tests (test_id, patient_id, test_date, result) values ('7', '3', '2023-02-10', 'Positive');
insert into covid_tests (test_id, patient_id, test_date, result) values ('8', '3', '2023-02-20', 'Negative');
insert into covid_tests (test_id, patient_id, test_date, result) values ('9', '4', '2023-01-10', 'Positive');
insert into covid_tests (test_id, patient_id, test_date, result) values ('10', '4', '2023-01-18', 'Positive');
insert into covid_tests (test_id, patient_id, test_date, result) values ('11', '5', '2023-02-15', 'Negative');
insert into covid_tests (test_id, patient_id, test_date, result) values ('12', '5', '2023-02-20', 'Negative');
-- insert into covid_tests (test_id, patient_id, test_date, result) values ('13', '2', '2023-02-20', 'Negative');

-- @block
SELECT
    patient_id
    , test_date
    , result
    , RANK() OVER(PARTITION BY patient_id ORDER BY test_date)
FROM covid_tests
;

-- @block
SELECT
    patient_id
    , MIN(test_date)
    , result
FROM covid_tests
WHERE result = 'Positive'
GROUP BY patient_id
;

-- @block
WITH
pr AS (
    SELECT
        patient_id
        , MIN(test_date) AS td
        , result
    FROM covid_tests
    WHERE result = 'Positive'
    GROUP BY patient_id
)
SELECT
    pr.patient_id
    , pr.td
    -- , pr.result
    -- , ct.test_date
    , MIN(ct.test_date)
    -- , ct.result
FROM pr
INNER JOIN covid_tests AS ct
ON pr.patient_id = ct.patient_id
AND ct.result = 'Negative'
AND pr.td < ct.test_date
GROUP BY pr.patient_id
;


-- @block
WITH
pr AS (
    SELECT
        patient_id
        , MIN(test_date) AS td
        , result
    FROM covid_tests
    WHERE result = 'Positive'
    GROUP BY patient_id
),
nr AS (
    SELECT
        pr.patient_id
        , pr.td AS pd
        -- , ct.test_date AS nd
        , MIN(ct.test_date) AS nd
    FROM pr
    INNER JOIN covid_tests AS ct
    ON pr.patient_id = ct.patient_id
    AND ct.result = 'Negative'
    AND pr.td < ct.test_date
    GROUP BY pr.patient_id
)
SELECT
    nr.patient_id
    , p.patient_name
    , p.age
    -- , pd
    -- , nd
    , DATEDIFF(nd, pd) AS recovery_time 
FROM nr
INNER JOIN patients as p
ON nr.patient_id = p.patient_id
ORDER BY recovery_time, patient_name
;