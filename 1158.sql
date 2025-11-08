DROP Table If Exists Users;
DROP Table If Exists Orders;
DROP Table If Exists Items;
Create table If Not Exists Users (user_id int, join_date date, favorite_brand varchar(10));
Create table If Not Exists Orders (order_id int, order_date date, item_id int, buyer_id int, seller_id int);
Create table If Not Exists Items (item_id int, item_brand varchar(10));
Truncate table Users;
insert into Users (user_id, join_date, favorite_brand) values ('1', '2018-01-01', 'Lenovo');
insert into Users (user_id, join_date, favorite_brand) values ('2', '2018-02-09', 'Samsung');
insert into Users (user_id, join_date, favorite_brand) values ('3', '2018-01-19', 'LG');
insert into Users (user_id, join_date, favorite_brand) values ('4', '2018-05-21', 'HP');
Truncate table Orders;
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('1', '2019-08-01', '4', '1', '2');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('2', '2018-08-02', '2', '1', '3');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('3', '2019-08-03', '3', '2', '3');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('4', '2018-08-04', '1', '4', '2');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('5', '2018-08-04', '1', '3', '4');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('6', '2019-08-05', '2', '2', '4');
Truncate table Items;
insert into Items (item_id, item_brand) values ('1', 'Samsung');
insert into Items (item_id, item_brand) values ('2', 'Lenovo');
insert into Items (item_id, item_brand) values ('3', 'LG');
insert into Items (item_id, item_brand) values ('4', 'HP');

-- @block
SELECT
DISTINCT buyer_id
, join_date
FROM Users AS u
INNER JOIN Orders AS o
ON o.buyer_id = u.user_id
;

-- @block
SELECT
buyer_id
, COUNT(buyer_id)
FROM Orders
WHERE LEFT(order_date, 4) = 2019
GROUP BY buyer_id
;

-- @block
WITH
tmp AS (
    SELECT
    buyer_id
    , COUNT(buyer_id) AS cnt
    FROM Orders
    WHERE LEFT(order_date, 4) = 2019
    GROUP BY buyer_id
)
SELECT
DISTINCT u.user_id AS buyer_id
, join_date
,
CASE
    WHEN cnt IS NULL THEN 0
    ELSE cnt
END AS orders_in_2019
FROM Users AS u
LEFT JOIN Orders AS o
ON o.buyer_id = u.user_id
LEFT JOIN tmp
ON tmp.buyer_id = u.user_id
;