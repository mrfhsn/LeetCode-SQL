DROP table if Exists drivers;
DROP table if Exists trips;
CREATE TABLE drivers (
    driver_id INT,
    driver_name VARCHAR(255)
);
CREATE TABLE trips (
    trip_id INT,
    driver_id INT,
    trip_date DATE,
    distance_km DECIMAL(8, 2),
    fuel_consumed DECIMAL(6, 2)
);
Truncate table drivers;
insert into drivers (driver_id, driver_name) values ('1', 'Alice Johnson');
insert into drivers (driver_id, driver_name) values ('2', 'Bob Smith');
insert into drivers (driver_id, driver_name) values ('3', 'Carol Davis');
insert into drivers (driver_id, driver_name) values ('4', 'David Wilson');
insert into drivers (driver_id, driver_name) values ('5', 'Emma Brown');
Truncate table trips;
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('1', '1', '2023-02-15', '120.5', '10.2');
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('2', '1', '2023-03-20', '200.0', '16.5');
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('3', '1', '2023-08-10', '150.0', '11.0');
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('4', '1', '2023-09-25', '180.0', '12.5');
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('5', '2', '2023-01-10', '100.0', '9.0');
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('6', '2', '2023-04-15', '250.0', '22.0');
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('7', '2', '2023-10-05', '200.0', '15.0');
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('8', '3', '2023-03-12', '80.0', '8.5');
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('9', '3', '2023-05-18', '90.0', '9.2');
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('10', '4', '2023-07-22', '160.0', '12.8');
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('11', '4', '2023-11-30', '140.0', '11.0');
insert into trips (trip_id, driver_id, trip_date, distance_km, fuel_consumed) values ('12', '5', '2023-02-28', '110.0', '11.5');

-- @block
SELECT
    driver_id
    , ROUND(AVG(CASE
        WHEN MONTH(trip_date) <= 6 THEN distance_km
    END /
    CASE
        WHEN MONTH(trip_date) <= 6 THEN fuel_consumed
    END), 2)
    AS first_half_avg
    , ROUND(AVG(CASE
        WHEN MONTH(trip_date) > 6 THEN distance_km
    END /
    CASE
        WHEN MONTH(trip_date) > 6 THEN fuel_consumed
    END), 2)
    AS second_half_avg
FROM trips
GROUP BY driver_id
;

-- @block
WITH
tmp AS (
    SELECT
        driver_id
        , AVG(CASE
            WHEN MONTH(trip_date) <= 6 THEN distance_km
        END /
        CASE
            WHEN MONTH(trip_date) <= 6 THEN fuel_consumed
        END)
        AS first_half_avg
        , AVG(CASE
            WHEN MONTH(trip_date) > 6 THEN distance_km
        END /
        CASE
            WHEN MONTH(trip_date) > 6 THEN fuel_consumed
        END)
        AS second_half_avg
    FROM trips
    GROUP BY driver_id
)
SELECT
    t.driver_id
    , d.driver_name
    , ROUND(first_half_avg, 2) AS first_half_avg
    , ROUND(second_half_avg, 2) AS second_half_avg
    , ROUND((second_half_avg - first_half_avg), 2) AS efficiency_improvement
FROM tmp AS t
INNER JOIN drivers AS d
ON t.driver_id = d.driver_id
AND t.first_half_avg IS NOT NULL
AND t.second_half_avg IS NOT NULL
AND second_half_avg > first_half_avg
ORDER BY efficiency_improvement DESC, driver_name
;