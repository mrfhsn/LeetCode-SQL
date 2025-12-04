DROP TABLE IF exists employees;
DROP TABLE IF exists meetings;

CREATE TABLE if not exists employees (
    employee_id INT,
    employee_name VARCHAR(255),
    department VARCHAR(100)
);
CREATE TABLE meetings (
    meeting_id INT,
    employee_id INT,
    meeting_date DATE,
    meeting_type VARCHAR(50),
    duration_hours DECIMAL(4, 2)
);
Truncate table employees;
insert into employees (employee_id, employee_name, department) values ('1', 'Alice Johnson', 'Engineering');
insert into employees (employee_id, employee_name, department) values ('2', 'Bob Smith', 'Marketing');
insert into employees (employee_id, employee_name, department) values ('3', 'Carol Davis', 'Sales');
insert into employees (employee_id, employee_name, department) values ('4', 'David Wilson', 'Engineering');
insert into employees (employee_id, employee_name, department) values ('5', 'Emma Brown', 'HR');
Truncate table meetings;
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('1', '1', '2023-06-05', 'Team', '8.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('2', '1', '2023-06-06', 'Client', '6.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('3', '1', '2023-06-07', 'Training', '7.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('4', '1', '2023-06-12', 'Team', '12.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('5', '1', '2023-06-13', 'Client', '9.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('6', '2', '2023-06-05', 'Team', '15.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('7', '2', '2023-06-06', 'Client', '8.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('8', '2', '2023-06-12', 'Training', '10.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('9', '3', '2023-06-05', 'Team', '4.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('10', '3', '2023-06-06', 'Client', '3.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('11', '4', '2023-06-05', 'Team', '25.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('12', '4', '2023-06-19', 'Client', '22.0');
insert into meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) values ('13', '5', '2023-06-05', 'Training', '2.0');

-- @block
TRUNCATE TABLE employees;
TRUNCATE TABLE meetings;

INSERT INTO employees (employee_id, employee_name, department) VALUES
(1, 'Yolanda Harris', 'Finance'),
(2, 'Carol Wright', 'Engineering');

INSERT INTO meetings (meeting_id, employee_id, meeting_date, meeting_type, duration_hours) VALUES
(1, 1, '2023-06-05', 'Team', 2.9),
(2, 1, '2023-06-06', 'Client', 31.4),
(3, 1, '2023-06-11', 'Training', 1.6),
(4, 1, '2023-06-10', 'Team', 2.4),
(5, 1, '2023-06-11', 'Client', 2.8),
(6, 1, '2023-06-09', 'Training', 3.2),
(7, 1, '2023-06-19', 'Client', 6.8),
(8, 1, '2023-06-17', 'Team', 22.2),
(9, 1, '2023-06-26', 'Client', 5.4),
(10, 1, '2023-06-25', 'Team', 3.8),
(11, 1, '2023-06-26', 'Client', 17.8),
(12, 1, '2023-06-30', 'Client', 2.8),
(13, 1, '2023-07-03', 'Training', 2.8),
(14, 1, '2023-07-01', 'Team', 0.8),
(15, 1, '2023-07-01', 'Team', 6.5),
(16, 1, '2023-07-06', 'Client', 0.7),
(17, 1, '2023-07-10', 'Team', 12.4),
(18, 1, '2023-07-17', 'Training', 1.2),
(19, 1, '2023-07-16', 'Team', 2.2),
(20, 1, '2023-07-14', 'Team', 2.8),
(21, 1, '2023-07-13', 'Client', 3.3),
(22, 1, '2023-07-24', 'Training', 4),
(23, 1, '2023-07-21', 'Team', 7.4),
(24, 1, '2023-07-23', 'Team', 12.7),
(25, 2, '2023-06-05', 'Training', 2),
(26, 2, '2023-06-04', 'Training', 3.6),
(27, 2, '2023-06-04', 'Team', 2.1),
(28, 2, '2023-06-03', 'Training', 3.4),
(29, 2, '2023-06-10', 'Training', 2),
(30, 2, '2023-06-10', 'Team', 7.8),
(31, 2, '2023-06-19', 'Team', 0.8),
(32, 2, '2023-06-16', 'Team', 1.8),
(33, 2, '2023-06-16', 'Team', 5.1),
(34, 2, '2023-06-26', 'Team', 4),
(35, 2, '2023-06-23', 'Client', 22.8),
(36, 2, '2023-06-29', 'Training', 3.5),
(37, 2, '2023-07-02', 'Client', 2.2),
(38, 2, '2023-07-01', 'Client', 2.2),
(39, 2, '2023-07-03', 'Training', 1),
(40, 2, '2023-07-07', 'Client', 4.2),
(41, 2, '2023-07-09', 'Client', 4.1),
(42, 2, '2023-07-08', 'Training', 23),
(43, 2, '2023-07-18', 'Client', 1.7),
(44, 2, '2023-07-14', 'Training', 28.8),
(45, 2, '2023-07-24', 'Team', 2.5),
(46, 2, '2023-07-20', 'Team', 2.7),
(47, 2, '2023-07-23', 'Team', 5.1);


-- @block
SELECT
    employee_id
    , WEEK(meeting_date, 7) AS wk
    , SUM(duration_hours)
FROM meetings
GROUP BY employee_id, wk
;

-- @block
WITH
tmp AS (
    SELECT
        employee_id
        , WEEK(meeting_date, 7) AS wk
        -- , SUM(duration_hours) AS sm
    FROM meetings
    GROUP BY employee_id, wk
    HAVING SUM(duration_hours) > 20
)
SELECT
    employee_id
    , COUNT(*) AS cnt
FROM tmp
GROUP BY employee_id
HAVING COUNT(*) >= 2
;

-- @block
WITH
tmp AS (
    SELECT
        employee_id
        , WEEK(meeting_date, 7) AS wk
        -- , SUM(duration_hours) AS sm
    FROM meetings
    GROUP BY employee_id, wk
    HAVING SUM(duration_hours) > 20
),
tmp2 AS (
    SELECT
        employee_id
        , COUNT(*) AS cnt
    FROM tmp
    GROUP BY employee_id
    HAVING COUNT(*) >= 2
)
SELECT
    t.employee_id
    , e.employee_name
    , e.department
    , cnt AS meeting_heavy_weeks
FROM tmp2 AS t
INNER JOIN employees AS e
ON t.employee_id = e.employee_id
ORDER BY meeting_heavy_weeks DESC, e.employee_name
;
