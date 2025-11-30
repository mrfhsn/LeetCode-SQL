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
insert into ProductPurchases (user_id, product_id, quantity) values ('1', '201', '3');
insert into ProductPurchases (user_id, product_id, quantity) values ('1', '301', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('2', '101', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('2', '102', '2');
insert into ProductPurchases (user_id, product_id, quantity) values ('2', '103', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('2', '201', '5');
insert into ProductPurchases (user_id, product_id, quantity) values ('3', '101', '2');
insert into ProductPurchases (user_id, product_id, quantity) values ('3', '103', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('3', '301', '4');
insert into ProductPurchases (user_id, product_id, quantity) values ('3', '401', '2');
insert into ProductPurchases (user_id, product_id, quantity) values ('4', '101', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('4', '201', '3');
insert into ProductPurchases (user_id, product_id, quantity) values ('4', '301', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('4', '401', '2');
insert into ProductPurchases (user_id, product_id, quantity) values ('5', '102', '2');
insert into ProductPurchases (user_id, product_id, quantity) values ('5', '103', '1');
insert into ProductPurchases (user_id, product_id, quantity) values ('5', '201', '2');
insert into ProductPurchases (user_id, product_id, quantity) values ('5', '202', '3');
Truncate table ProductInfo;
insert into ProductInfo (product_id, category, price) values ('101', 'Electronics', '100');
insert into ProductInfo (product_id, category, price) values ('102', 'Books', '20');
insert into ProductInfo (product_id, category, price) values ('103', 'Books', '35');
insert into ProductInfo (product_id, category, price) values ('201', 'Clothing', '45');
insert into ProductInfo (product_id, category, price) values ('202', 'Clothing', '60');
insert into ProductInfo (product_id, category, price) values ('301', 'Sports', '75');
insert into ProductInfo (product_id, category, price) values ('401', 'Kitchen', '50');


-- @block
SELECT DISTINCT
    p1.category
    -- , p1.product_id
    , p2.category
    -- , p2.product_id
FROM ProductInfo AS p1
INNER JOIN ProductInfo AS p2   
ON p1.category < p2.category
;

-- @block
SELECT
    user_id
    , pp.product_id
    , pi.category
FROM ProductPurchases AS pp
INNER JOIN ProductInfo AS pi
ON pp.product_id = pi.product_id
;

-- @block
SELECT
    pi1.category AS category1
    , pi2.category AS category2
    , COUNT(DISTINCT p1.user_id) AS customer_count
FROM ProductPurchases AS p1
INNER JOIN ProductPurchases AS p2
ON p1.user_id = p2.user_id
INNER JOIN ProductInfo AS pi1
ON p1.product_id = pi1.product_id
INNER JOIN ProductInfo AS pi2
ON p2.product_id = pi2.product_id
AND pi1.category < pi2.category
GROUP BY pi1.category, pi2.category
HAVING COUNT(DISTINCT p1.user_id) >= 3
ORDER BY customer_count DESC, category1, category2
;