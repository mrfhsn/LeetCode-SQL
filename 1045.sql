Create table If Not Exists Customer (customer_id int, product_key int);
Create table If Not Exists Product (product_key int);
Truncate table Customer;
insert into Customer (customer_id, product_key) values ('1', '5');
insert into Customer (customer_id, product_key) values ('1', '5');
insert into Customer (customer_id, product_key) values ('2', '6');
insert into Customer (customer_id, product_key) values ('2', '6');
insert into Customer (customer_id, product_key) values ('3', '5');
insert into Customer (customer_id, product_key) values ('3', '5');
insert into Customer (customer_id, product_key) values ('3', '6');
insert into Customer (customer_id, product_key) values ('3', '6');
insert into Customer (customer_id, product_key) values ('1', '6');
insert into Customer (customer_id, product_key) values ('1', '6');
Truncate table Product;
insert into Product (product_key) values ('5');
insert into Product (product_key) values ('6');

-- @block
-- WITH
-- cnt AS (
--     SELECT COUNT(product_key)
--     FROM Product
--     GROUP BY product_key
-- )
SELECT customer_id
-- , product_key
-- , COUNT(product_key)
FROM Customer
GROUP BY customer_id
HAVING COUNT(product_key) = (
    SELECT COUNT(*)
    FROM Product
)
;

-- @block
SELECT COUNT(*)
FROM Product;


-- @block
WITH
crs AS (
    SELECT DISTINCT customer_id
    , p.product_key
    FROM Customer
    CROSS JOIN Product AS p
)
SELECT customer_id
FROM (
    SELECT DISTINCT c.customer_id
    -- , c.product_ke/y
    , crs.product_key
    FROM Customer AS c
    INNER JOIN crs
    ON c.customer_id = crs.customer_id
    AND c.product_key = crs.product_key
) AS prd
GROUP BY customer_id
HAVING COUNT(product_key) = (
    SELECT COUNT(*)
    FROM Product
)
;

-- @block
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (
    SELECT COUNT(*)
    FROM Product
)
-- @block