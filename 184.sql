DROP TABLE IF EXISTS Employee;
Create table If Not Exists Employee (id int, name varchar(255), salary int, departmentId int);
Create table If Not Exists Department (id int, name varchar(255));
Truncate table Employee;
insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '70000', '1');
insert into Employee (id, name, salary, departmentId) values ('2', 'Jim', '90000', '1');
insert into Employee (id, name, salary, departmentId) values ('3', 'Henry', '80000', '2');
insert into Employee (id, name, salary, departmentId) values ('4', 'Sam', '60000', '2');
insert into Employee (id, name, salary, departmentId) values ('5', 'Max', '90000', '1');
Truncate table Department;
insert into Department (id, name) values ('1', 'IT');
insert into Department (id, name) values ('2', 'Sales');

-- @block
-- @block
SELECT
departmentId
, MAX(salary) AS mx
FROM Employee
GROUP BY departmentId
;

-- @block
WITH
mxs AS
(
    SELECT
    departmentId
    , MAX(salary) AS mx
    FROM Employee
    GROUP BY departmentId
)
SELECT
d.name AS Department
, e.name AS Employee
, salary AS Salary
FROM Employee AS e
INNER JOIN mxs AS m
ON e.departmentId = m.departmentId
AND e.salary = m.mx
LEFT JOIN Department AS d
ON e.departmentId = d.id
;