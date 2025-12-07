DROP TABLE IF exists course_completions;
CREATE TABLE course_completions (
    user_id INT,
    course_id INT,
    course_name VARCHAR(100),
    completion_date DATE,
    course_rating INT
);
Truncate table course_completions;
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('1', '101', 'Python Basics', '2024-01-05', '5');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('1', '102', 'SQL Fundamentals', '2024-02-10', '4');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('1', '103', 'JavaScript', '2024-03-15', '5');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('1', '104', 'React Basics', '2024-04-20', '4');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('1', '105', 'Node.js', '2024-05-25', '5');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('1', '106', 'Docker', '2024-06-30', '4');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('2', '101', 'Python Basics', '2024-01-08', '4');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('2', '104', 'React Basics', '2024-02-14', '5');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('2', '105', 'Node.js', '2024-03-20', '4');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('2', '106', 'Docker', '2024-04-25', '5');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('2', '107', 'AWS Fundamentals', '2024-05-30', '4');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('3', '101', 'Python Basics', '2024-01-10', '3');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('3', '102', 'SQL Fundamentals', '2024-02-12', '3');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('3', '103', 'JavaScript', '2024-03-18', '3');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('3', '104', 'React Basics', '2024-04-22', '2');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('3', '105', 'Node.js', '2024-05-28', '3');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('4', '101', 'Python Basics', '2024-01-12', '5');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('4', '108', 'Data Science', '2024-02-16', '5');
insert into course_completions (user_id, course_id, course_name, completion_date, course_rating) values ('4', '109', 'Machine Learning', '2024-03-22', '5');

-- @block
SELECT
    user_id
    , course_id
    , course_name
    , completion_date
    , course_rating
    , COUNT(user_id) OVER(PARTITION BY user_id) AS cnt
    , AVG(course_rating) OVER(PARTITION BY user_id) AS cr
    , RANK() OVER(PARTITION BY user_id ORDER BY completion_date) AS rnk
FROM course_completions
;

-- @block
WITH
tmp AS (
    SELECT
        user_id
        -- , course_id
        , course_name
        , COUNT(user_id) OVER(PARTITION BY user_id) AS cnt
        , AVG(course_rating) OVER(PARTITION BY user_id) AS cr
        , RANK() OVER(PARTITION BY user_id ORDER BY completion_date) AS rnk
    FROM course_completions
)
SELECT
    t1.course_name AS first_course
    , t2.course_name AS second_course
    , COUNT(*) AS transition_count
FROM tmp AS t1
INNER JOIN tmp AS t2
ON t1.user_id = t2.user_id
AND (t1.rnk + 1) = t2.rnk
AND t1.cnt >= 5 
AND t1.cr >= 4
GROUP BY t1.course_name, t2.course_name
ORDER BY transition_count DESC, first_course, second_course
;
