DROP TABLE IF Exists Scores;
CREATE TABLE Scores (
    student_id INT,
    subject VARCHAR(50),
    score INT,
    exam_date VARCHAR(10)
);
Truncate table Scores;
insert into Scores (student_id, subject, score, exam_date) values ('101', 'Math', '70', '2023-01-15');
insert into Scores (student_id, subject, score, exam_date) values ('101', 'Math', '85', '2023-02-15');
insert into Scores (student_id, subject, score, exam_date) values ('101', 'Physics', '65', '2023-01-15');
insert into Scores (student_id, subject, score, exam_date) values ('101', 'Physics', '60', '2023-02-15');
insert into Scores (student_id, subject, score, exam_date) values ('102', 'Math', '80', '2023-01-15');
insert into Scores (student_id, subject, score, exam_date) values ('102', 'Math', '85', '2023-02-15');
insert into Scores (student_id, subject, score, exam_date) values ('103', 'Math', '90', '2023-01-15');
insert into Scores (student_id, subject, score, exam_date) values ('104', 'Physics', '75', '2023-01-15');
insert into Scores (student_id, subject, score, exam_date) values ('104', 'Physics', '85', '2023-02-15');

-- @block
SELECT
    s1.student_id
    , s1.subject
    , s1.score AS first_score
    , s2.score AS latest_score
FROM Scores AS s1
INNER JOIN Scores AS s2
ON s1.student_id = s2.student_id 
AND s1.subject = s2.subject
AND s1.score < s2.score
AND s1.exam_date < s2.exam_date
;

-- @block
SELECT
    student_id, subject
    , MIN(exam_date) AS mn
    , MAX(exam_date) AS mx
FROM Scores
GROUP BY student_id, subject
;

-- @block
WITH
tmp AS (
    SELECT
        student_id, subject
        , MIN(exam_date) AS mn
        , MAX(exam_date) AS mx
    FROM Scores
    GROUP BY student_id, subject
)
SELECT 
    s.student_id
    , s.subject
    , s.score
    , s.exam_date
FROM Scores AS s
INNER JOIN tmp AS t
ON s.student_id = t.student_id
AND s.subject = t.subject
AND (s.exam_date = t.mn OR s.exam_date = t.mx)
;

-- @block
WITH
tmp AS (
    SELECT
        student_id, subject
        , MIN(exam_date) AS mn
        , MAX(exam_date) AS mx
    FROM Scores
    GROUP BY student_id, subject
),
ss AS (
    SELECT 
        s.student_id
        , s.subject
        , s.score
        , s.exam_date
    FROM Scores AS s
    INNER JOIN tmp AS t
    ON s.student_id = t.student_id
    AND s.subject = t.subject
    AND (s.exam_date = t.mn OR s.exam_date = t.mx)
)
SELECT
    s1.student_id
    , s1.subject
    , s1.score AS first_score
    , s2.score AS latest_score
FROM ss AS s1
INNER JOIN ss AS s2
ON s1.student_id = s2.student_id 
AND s1.subject = s2.subject
AND s1.score < s2.score
AND s1.exam_date < s2.exam_date
ORDER BY student_id, subject
;

-- @block
WITH
tmp AS (
    SELECT
        student_id, subject
        , MIN(exam_date) AS mn
        , MAX(exam_date) AS mx
    FROM Scores
    GROUP BY student_id, subject
)
SELECT
    t.student_id
    , t.subject
    , s1.score AS first_score 
    , s2.score AS latest_score 
FROM tmp AS t
INNER JOIN Scores AS s1
ON t.student_id = s1.student_id
AND t.subject = s1.subject
AND t.mn = s1.exam_date
INNER JOIN Scores AS s2
ON t.student_id = s2.student_id
AND t.subject = s2.subject
AND t.mx = s2.exam_date
WHERE s1.score < s2.score
ORDER BY t.student_id, t.subject
;