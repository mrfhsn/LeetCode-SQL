DROP table if Exists restaurant_orders;
CREATE TABLE restaurant_orders (
    order_id INT,
    customer_id INT,
    order_timestamp DATETIME,
    order_amount DECIMAL(10,2),
    payment_method VARCHAR(10),
    order_rating INT
);
Truncate table restaurant_orders;
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('1', '101', '2024-03-01 12:30:00', '25.5', 'card', '5');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('2', '101', '2024-03-02 19:15:00', '32.0', 'app', '4');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('3', '101', '2024-03-03 13:45:00', '28.75', 'card', '5');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('4', '101', '2024-03-04 20:30:00', '41.0', 'app', NULL);
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('5', '102', '2024-03-01 11:30:00', '18.5', 'cash', '4');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('6', '102', '2024-03-02 12:00:00', '22.0', 'card', '3');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('7', '102', '2024-03-03 15:30:00', '19.75', 'cash', NULL);
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('8', '103', '2024-03-01 19:00:00', '55.0', 'app', '5');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('9', '103', '2024-03-02 20:45:00', '48.5', 'app', '4');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('10', '103', '2024-03-03 18:30:00', '62.0', 'card', '5');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('11', '104', '2024-03-01 10:00:00', '15.0', 'cash', '3');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('12', '104', '2024-03-02 09:30:00', '18.0', 'cash', '2');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('13', '104', '2024-03-03 16:00:00', '20.0', 'card', '3');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('14', '105', '2024-03-01 12:15:00', '30.0', 'app', '4');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('15', '105', '2024-03-02 13:00:00', '35.5', 'app', '5');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('16', '105', '2024-03-03 11:45:00', '28.0', 'card', '4');

-- @block
SELECT
    customer_id
    , order_rating
    , COUNT(customer_id) OVER(PARTITION BY customer_id)
    , ROUND(AVG(order_rating) OVER(PARTITION BY customer_id), 2)
FROM restaurant_orders
;

-- @block
SELECT
    customer_id
    , AVG(order_rating)
    , COUNT(customer_id)
    , SUM(
        CASE
            WHEN order_rating IS NOT NULL THEN 1
        END
    ) / COUNT(customer_id)
    , SUM(
        CASE
            WHEN (TIME(order_timestamp) BETWEEN "11:00:00" AND "14:00:00") OR (TIME(order_timestamp) BETWEEN "18:00:00" AND "21:00:00") THEN 1
        END
    ) / COUNT(customer_id)
FROM restaurant_orders
GROUP BY customer_id
;

-- @block
WITH
tmp AS (
    SELECT
        customer_id
        , COUNT(customer_id) AS total_orders
        , ROUND(SUM(
            CASE
                WHEN (TIME(order_timestamp) BETWEEN "11:00:00" AND "14:00:00") OR (TIME(order_timestamp) BETWEEN "18:00:00" AND "21:00:00") THEN 1
            END
        ) * 100 / COUNT(customer_id), 0) AS peak_hour_percentage 
        , SUM(
            CASE
                WHEN order_rating IS NOT NULL THEN 1
            END
        ) / COUNT(customer_id) AS rating_percentage 
        , ROUND(AVG(order_rating), 2) average_rating 
    FROM restaurant_orders
    GROUP BY customer_id
)
SELECT
    customer_id
    , total_orders
    , peak_hour_percentage
    , average_rating
FROM tmp
WHERE total_orders >= 3
AND peak_hour_percentage >= 60
AND average_rating >= 4
AND rating_percentage >= 0.5 
ORDER BY average_rating DESC, customer_id DESC
;