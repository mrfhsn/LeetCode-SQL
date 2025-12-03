DROP TABLE IF exists stores;
DROP TABLE IF exists inventory;
CREATE TABLE if not exists stores (
    store_id INT,
    store_name VARCHAR(255),
    location VARCHAR(255)
);
CREATE TABLE if not exists inventory (
    inventory_id INT,
    store_id INT,
    product_name VARCHAR(255),
    quantity INT,
    price DECIMAL(10, 2)
);
Truncate table stores;
insert into stores (store_id, store_name, location) values ('1', 'Downtown Tech', 'New York');
insert into stores (store_id, store_name, location) values ('2', 'Suburb Mall', 'Chicago');
insert into stores (store_id, store_name, location) values ('3', 'City Center', 'Los Angeles');
insert into stores (store_id, store_name, location) values ('4', 'Corner Shop', 'Miami');
insert into stores (store_id, store_name, location) values ('5', 'Plaza Store', 'Seattle');
Truncate table inventory;
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('1', '1', 'Laptop', '5', '999.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('2', '1', 'Mouse', '50', '19.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('3', '1', 'Keyboard', '25', '79.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('4', '1', 'Monitor', '15', '299.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('5', '2', 'Phone', '3', '699.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('6', '2', 'Charger', '100', '25.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('7', '2', 'Case', '75', '15.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('8', '2', 'Headphones', '20', '149.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('9', '3', 'Tablet', '2', '499.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('10', '3', 'Stylus', '80', '29.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('11', '3', 'Cover', '60', '39.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('12', '4', 'Watch', '10', '299.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('13', '4', 'Band', '25', '49.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('14', '5', 'Camera', '8', '599.99');
insert into inventory (inventory_id, store_id, product_name, quantity, price) values ('15', '5', 'Lens', '12', '199.99');

-- @block
SELECT
    store_id
    , inventory_id
    , product_name
    , quantity
    , price
    , RANK() OVER(PARTITION BY store_id ORDER BY price DESC) AS rnk
    , COUNT(*) OVER(PARTITION BY store_id) AS cnt
FROM inventory
;

-- @block
WITH
tmp AS (
    SELECT
        store_id
        , inventory_id
        , product_name
        , quantity
        , price
        , RANK() OVER(PARTITION BY store_id ORDER BY price DESC) AS rnk
        , COUNT(*) OVER(PARTITION BY store_id) AS cnt
    FROM inventory
)
SELECT
    store_id
    , inventory_id
    , product_name
    , quantity
    , price
FROM tmp
WHERE (rnk = 1 OR rnk = cnt) AND cnt >= 3
;

-- @block
WITH
tmp AS (
    SELECT
        store_id
        , inventory_id
        , product_name
        , quantity
        -- , price
        , RANK() OVER(PARTITION BY store_id ORDER BY price DESC) AS rnk
        , COUNT(*) OVER(PARTITION BY store_id) AS cnt
    FROM inventory
)
SELECT
    t1.store_id
    , s.store_name
    , s.location
    , t1.product_name AS most_exp_product
    , t2.product_name AS cheapest_product
    , ROUND((t2.quantity / t1.quantity), 2) AS imbalance_ratio
    -- , t1.price
    -- , t2.price
    -- , t1.rnk
    -- , t2.rnk
FROM tmp AS t1
INNER JOIN tmp AS t2
ON t1.store_id = t2.store_id
AND t1.rnk = 1
AND t2.rnk = t2.cnt
AND t1.quantity < t2.quantity
AND t1.cnt >= 3
INNER JOIN stores AS s
ON t1.store_id = s.store_id
ORDER BY imbalance_ratio DESC, s.store_name
;
