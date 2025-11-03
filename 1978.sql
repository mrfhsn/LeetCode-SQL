Create table If Not Exists Employees (employee_id int, name varchar(20), manager_id int, salary int);
Truncate table Employees;
insert into Employees (employee_id, name, manager_id, salary) values ('3', 'Mila', '9', '60301');
insert into Employees (employee_id, name, manager_id, salary) values ('12', 'Antonella', NULL, '31000');
insert into Employees (employee_id, name, manager_id, salary) values ('13', 'Emery', NULL, '67084');
insert into Employees (employee_id, name, manager_id, salary) values ('1', 'Kalel', '11', '21241');
insert into Employees (employee_id, name, manager_id, salary) values ('9', 'Mikaela', NULL, '50937');
insert into Employees (employee_id, name, manager_id, salary) values ('11', 'Joziah', '6', '28485');
insert into Employees (employee_id, name, manager_id, salary) values ('17', 'Joziah', '7', '28485');

-- @block
WITH
fl AS (
    SELECT employee_id, manager_id
    FROM Employees
    WHERE salary < 30000
    AND manager_id IS NOT NULL
)
SELECT fl.employee_id
-- e.employee_id, e.manager_id
-- , fl.employee_id, fl.manager_id
FROM Employees AS e
-- LEFT JOIN fl
RIGHT JOIN fl
ON fl.manager_id = e.employee_id
-- AND fl.employee_id = e.manager_id
WHERE e.employee_id IS NULL
ORDER BY fl.employee_id
;
