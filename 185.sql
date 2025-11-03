DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;
Create table If Not Exists Employee (id int, name varchar(255), salary int, departmentId int);
Create table If Not Exists Department (id int, name varchar(255));
Truncate table Employee;
insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '85000', '1');
insert into Employee (id, name, salary, departmentId) values ('2', 'Henry', '80000', '2');
insert into Employee (id, name, salary, departmentId) values ('3', 'Sam', '60000', '2');
insert into Employee (id, name, salary, departmentId) values ('4', 'Max', '90000', '1');
insert into Employee (id, name, salary, departmentId) values ('5', 'Janet', '69000', '1');
insert into Employee (id, name, salary, departmentId) values ('6', 'Randy', '85000', '1');
insert into Employee (id, name, salary, departmentId) values ('7', 'Will', '70000', '1');
Truncate table Department;
insert into Department (id, name) values ('1', 'IT');
insert into Department (id, name) values ('2', 'Sales');

-- @block
WITH
sal AS 
(
    SELECT
    name
    , salary
    , DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS rnk
    , departmentId
    FROM Employee
)
SELECT 
d.name AS Department 
, s.name AS Employee
, s.salary AS Salary
FROM sal AS s
INNER JOIN Department AS d
ON s.departmentId = d.id
WHERE s.rnk <= 3
;