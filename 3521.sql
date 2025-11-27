DROP TABLE IF Exists ProductPurchases;
DROP TABLE IF Exists ProductInfo;
CREATE TABLE if not exists ProductPurchases (
    user_id INT,
    product_id INT,
    quantity INT
);
CREATE TABLE  if not exists ProductInfo (
    product_id INT,
    category VARCHAR(100),
    price DECIMAL(10, 2)
);
Truncate table ProductPurchases;
insert into ProductPurchases (user_id, product_id, quantity) values ('1', '101', '2');
insert into ProductPurchases (user_id, product_id, quantity) values ('1', '102', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('1', '103', '3');
insert into ProductPurchases (user_id, product_id, quantity) values ('2', '101', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('2', '102', '5');
insert into ProductPurchases (user_id, product_id, quantity) values ('2', '104', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('3', '101', '2');
insert into ProductPurchases (user_id, product_id, quantity) values ('3', '103', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('3', '105', '4');
insert into ProductPurchases (user_id, product_id, quantity) values ('4', '101', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('4', '102', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('4', '103', '2');
insert into ProductPurchases (user_id, product_id, quantity) values ('4', '104', '3');
insert into ProductPurchases (user_id, product_id, quantity) values ('5', '102', '2');
insert into ProductPurchases (user_id, product_id, quantity) values ('5', '104', '1');
Truncate table ProductInfo;
insert into ProductInfo (product_id, category, price) values ('101', 'Electronics', '100');
insert into ProductInfo (product_id, category, price) values ('102', 'Books', '20');
insert into ProductInfo (product_id, category, price) values ('103', 'Clothing', '35');
insert into ProductInfo (product_id, category, price) values ('104', 'Kitchen', '50');
insert into ProductInfo (product_id, category, price) values ('105', 'Sports', '75');

-- @block
SELECT
    p1.user_id
    , p1.product_id
    , p2.product_id
FROM ProductPurchases AS p1
INNER JOIN ProductPurchases AS p2   
ON p1.user_id = p2.user_id
AND p1.product_id < p2.product_id
;

-- @block
SELECT
    p1.product_id
    , p2.product_id
    , COUNT(*)
FROM ProductPurchases AS p1
INNER JOIN ProductPurchases AS p2
ON p1.user_id = p2.user_id
AND p1.product_id < p2.product_id
GROUP BY p1.product_id, p2.product_id
-- HAVING COUNT(*) >= 3
;

-- @block
WITH
pair AS (
    SELECT
        p1.product_id AS product1_id 
        , p2.product_id AS product2_id 
        , COUNT(DISTINCT p1.user_id) AS cnt
    FROM ProductPurchases AS p1
    INNER JOIN ProductPurchases AS p2
    ON p1.user_id = p2.user_id
    AND p1.product_id < p2.product_id
    GROUP BY p1.product_id, p2.product_id
    HAVING COUNT(DISTINCT p1.user_id) >= 3
)
SELECT
    product1_id
    , product2_id
    , pi1.category AS product1_category 
    , pi2.category AS product2_category 
    , cnt AS customer_count 
FROM pair AS p
INNER JOIN ProductInfo AS pi1
ON p.product1_id = pi1.product_id
INNER JOIN ProductInfo AS pi2
ON p.product2_id = pi2.product_id
ORDER BY customer_count DESC, product1_id, product2_id
;
