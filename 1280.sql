Create table If Not Exists Students (student_id int, student_name varchar(20));
Create table If Not Exists Subjects (subject_name varchar(20));
Create table If Not Exists Examinations (student_id int, subject_name varchar(20));
Truncate table Students;
insert into Students (student_id, student_name) values ('1', 'Alice');
insert into Students (student_id, student_name) values ('2', 'Bob');
insert into Students (student_id, student_name) values ('13', 'John');
insert into Students (student_id, student_name) values ('6', 'Alex');
Truncate table Subjects;
insert into Subjects (subject_name) values ('Math');
insert into Subjects (subject_name) values ('Physics');
insert into Subjects (subject_name) values ('Programming');
Truncate table Examinations;
insert into Examinations (student_id, subject_name) values ('1', 'Math');
insert into Examinations (student_id, subject_name) values ('1', 'Physics');
insert into Examinations (student_id, subject_name) values ('1', 'Programming');
insert into Examinations (student_id, subject_name) values ('2', 'Programming');
insert into Examinations (student_id, subject_name) values ('1', 'Physics');
insert into Examinations (student_id, subject_name) values ('1', 'Math');
insert into Examinations (student_id, subject_name) values ('13', 'Math');
insert into Examinations (student_id, subject_name) values ('13', 'Programming');
insert into Examinations (student_id, subject_name) values ('13', 'Physics');
insert into Examinations (student_id, subject_name) values ('2', 'Math');
insert into Examinations (student_id, subject_name) values ('1', 'Math');

-- @block
SELECT st.student_id, student_name
, sb.subject_name 
, ex.subject_name 
-- , COUNT(ex.subject_name) AS attended_exams
FROM Examinations AS ex
INNER JOIN Students AS st
ON st.student_id = ex.student_id
CROSS JOIN Subjects AS sb
-- INNER JOIN Subjects AS sb
-- ON ex.subject_name = sb.subject_name
-- GROUP BY student_id, student_name, subject_name
-- ORDER BY student_id, subject_name;

-- @block
-- ok
SELECT st.student_id, student_name
, sb.subject_name 
-- , ex.subject_name 
, COUNT(ex.subject_name) AS attended_exams
FROM Students AS st
CROSS JOIN Subjects AS sb
LEFT JOIN Examinations AS ex
ON sb.subject_name = ex.subject_name
AND st.student_id = ex.student_id
GROUP BY student_id, student_name, subject_name
ORDER BY student_id, subject_name
;

-- multiply
-- and add

-- @block
-- test
SELECT st.student_id, student_name
, sb.subject_name 
-- , ex.subject_name 
-- , COUNT(ex.subject_name) AS attended_exams
FROM Students AS st
CROSS JOIN Subjects AS sb
-- LEFT JOIN Examinations AS ex
-- ON ex.subject_name = sb.subject_name
-- ON st.student_id = ex.student_id
-- AND st.student_id = ex.student_id
-- GROUP BY student_id, student_name, subject_name
-- ORDER BY student_id, subject_name
;