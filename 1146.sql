Create table If Not Exists Products (product_id int, new_price int, change_date date);
Truncate table Products;
insert into Products (product_id, new_price, change_date) values ('1', '20', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('2', '50', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('1', '30', '2019-08-15');
insert into Products (product_id, new_price, change_date) values ('1', '35', '2019-08-16');
insert into Products (product_id, new_price, change_date) values ('2', '65', '2019-08-17');
insert into Products (product_id, new_price, change_date) values ('3', '20', '2019-08-18');

-- @block
SELECT product_id, MAX(change_date)
FROM Products
WHERE change_date <= "2019-08-16"
GROUP BY product_id
;

-- @block
SELECT DISTINCT product_id
FROM Products
;

-- @block
WITH
mx AS (
    SELECT product_id, MAX(change_date) AS max_date
    FROM Products
    WHERE change_date <= "2019-08-16"
    GROUP BY product_id
),
dis AS (
    SELECT DISTINCT product_id
    FROM Products
)
SELECT
-- *
dis.product_id
-- , mx.product_id
-- , p.new_price
,
CASE
    WHEN new_price IS NULL THEN 10
    ELSE new_price
END AS price
-- , mx.max_date
FROM dis
LEFT JOIN mx
ON mx.product_id = dis.product_id
LEFT JOIN Products AS p
ON p.product_id = dis.product_id
AND p.change_date = mx.max_date
;

-- @block
-- nope
WITH
mx AS (
    SELECT product_id, MAX(change_date) AS max_date
    FROM Products
    WHERE change_date <= "2019-08-16"
    GROUP BY product_id
),
dis AS (
    SELECT DISTINCT product_id
    FROM Products
)
SELECT DISTINCT p.product_id
, p.new_price
-- , mx.product_id
-- , p.change_date
, mx.max_date
FROM Products AS p

-- LEFT JOIN mx
-- ON mx.product_id = p.product_id
-- AND mx.max_date = p.change_date
;