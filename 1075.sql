Create table If Not Exists Project (project_id int, employee_id int);
Create table If Not Exists Employee (employee_id int, name varchar(10), experience_years int);
Truncate table Project;
insert into Project (project_id, employee_id) values ('1', '1');
insert into Project (project_id, employee_id) values ('1', '2');
insert into Project (project_id, employee_id) values ('1', '3');
insert into Project (project_id, employee_id) values ('2', '1');
insert into Project (project_id, employee_id) values ('2', '4');
Truncate table Employee;
insert into Employee (employee_id, name, experience_years) values ('1', 'Khaled', '3');
insert into Employee (employee_id, name, experience_years) values ('2', 'Ali', '2');
insert into Employee (employee_id, name, experience_years) values ('3', 'John', '1');
insert into Employee (employee_id, name, experience_years) values ('4', 'Doe', '2')


-- @block
SELECT project_id
-- , p.employee_id
-- , e.employee_id, name
-- , experience_years
-- , SUM(experience_years)
-- , COUNT(project_id)
-- , SUM(experience_years) / COUNT(project_id) AS average_years
, ROUND(SUM(experience_years) / COUNT(project_id), 2) AS average_years
FROM Project AS p
INNER JOIN Employee AS e
ON e.employee_id = p.employee_id
GROUP BY project_id
;