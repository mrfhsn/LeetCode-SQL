DROP TABLE IF Exists employees;
DROP TABLE IF Exists performance_reviews;
CREATE TABLE employees (
    employee_id INT,
    name VARCHAR(255)
);
CREATE TABLE performance_reviews (
    review_id INT,
    employee_id INT,
    review_date DATE,
    rating INT
);
Truncate table employees;
insert into employees (employee_id, name) values ('1', 'Alice Johnson');
insert into employees (employee_id, name) values ('2', 'Bob Smith');
insert into employees (employee_id, name) values ('3', 'Carol Davis');
insert into employees (employee_id, name) values ('4', 'David Wilson');
insert into employees (employee_id, name) values ('5', 'Emma Brown');
Truncate table performance_reviews;
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('1', '1', '2023-01-15', '2');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('2', '1', '2023-04-15', '3');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('3', '1', '2023-07-15', '4');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('4', '1', '2023-10-15', '5');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('5', '2', '2023-02-01', '3');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('6', '2', '2023-05-01', '2');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('7', '2', '2023-08-01', '4');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('8', '2', '2023-11-01', '5');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('9', '3', '2023-03-10', '1');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('10', '3', '2023-06-10', '2');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('11', '3', '2023-09-10', '3');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('12', '3', '2023-12-10', '4');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('13', '4', '2023-01-20', '4');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('14', '4', '2023-04-20', '4');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('15', '4', '2023-07-20', '4');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('16', '5', '2023-02-15', '3');
insert into performance_reviews (review_id, employee_id, review_date, rating) values ('17', '5', '2023-05-15', '2');

-- @block
SELECT
    employee_id
    , review_date
    , rating
    , RANK() OVER(PARTITION BY employee_id ORDER BY review_date DESC) AS rnk
FROM performance_reviews
;

-- @block
WITH
tmp AS ( 
    SELECT
        employee_id
        , review_date
        , rating
        , RANK() OVER(PARTITION BY employee_id ORDER BY review_date DESC) AS rnk
    FROM performance_reviews
)
SELECT
    t1.employee_id
    , t1.rating
    , t1.rnk
    , t2.rating
    , t2.rnk
    , t3.rating
    , t3.rnk
FROM tmp AS t1
INNER JOIN tmp AS t2
ON t1.employee_id = t2.employee_id
AND (t1.rnk = 1 AND t2.rnk = 2)
AND t1.rating > t2.rating
INNER JOIN tmp AS t3
ON t1.employee_id = t3.employee_id
AND (t1.rnk = 1 AND t3.rnk = 3)
AND t2.rating > t3.rating
;

-- @block
WITH
tmp AS ( 
    SELECT
        employee_id
        , review_date
        , rating
        , RANK() OVER(PARTITION BY employee_id ORDER BY review_date DESC) AS rnk
    FROM performance_reviews
)
SELECT
    t1.employee_id
    , name
    , (t1.rating - t3.rating) improvement_score 
FROM tmp AS t1
INNER JOIN tmp AS t2
ON t1.employee_id = t2.employee_id
AND (t1.rnk = 1 AND t2.rnk = 2)
AND t1.rating > t2.rating
INNER JOIN tmp AS t3
ON t1.employee_id = t3.employee_id
AND (t1.rnk = 1 AND t3.rnk = 3)
AND t2.rating > t3.rating
INNER JOIN employees AS e
ON t1.employee_id = e.employee_id
ORDER BY improvement_score DESC, name ASC
;
