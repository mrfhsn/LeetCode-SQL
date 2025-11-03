Create Table If Not Exists Insurance (pid int, tiv_2015 float, tiv_2016 float, lat float, lon float);
Truncate table Insurance;
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('1', '10', '5', '10', '10');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('2', '20', '20', '20', '20');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('3', '10', '30', '20', '20');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('4', '10', '40', '40', '40');

-- @block
-- mistake: duplicate i1.pid as of cross join
Truncate table Insurance;
INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon)
VALUES
(1, 224.17, 952.73, 32.4, 20.2),
(2, 224.17, 900.66, 52.4, 32.7),
(3, 824.61, 645.13, 72.4, 45.2),
(4, 424.32, 323.66, 12.4, 7.7),
(5, 424.32, 282.9, 12.4, 7.7),
(6, 625.05, 243.53, 52.5, 32.8),
(7, 424.32, 968.94, 72.5, 45.3),
(8, 624.46, 714.13, 12.5, 7.8),
(9, 425.49, 463.85, 32.5, 20.3),
(10, 624.46, 776.85, 12.4, 7.7),
(11, 624.46, 692.71, 72.5, 45.3),
(12, 225.93, 933.00, 12.5, 7.8),
(13, 824.61, 786.86, 32.6, 20.3),
(14, 824.61, 935.34, 52.6, 32.8);

-- @block
-- mistake: ??
Truncate table Insurance;
INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon) VALUES
(1, 224.17, 952.73, 32.4, 20.2),
(2, 224.17, 900.66, 52.4, 32.7),
(3, 824.61, 645.13, 72.4, 45.2),
(4, 424.32, 323.66, 12.4, 7.7),
(5, 424.32, 282.9, 12.4, 7.7),
(6, 625.05, 243.53, 52.5, 32.8),
(7, 424.32, 968.94, 72.5, 45.3),
(8, 624.46, 714.13, 12.5, 7.8),
(9, 425.49, 463.85, 32.5, 20.3),
(10, 624.46, 776.85, 12.4, 7.7),
(11, 624.46, 692.71, 72.5, 45.3),
(12, 225.93, 933, 12.5, 7.8),
(13, 824.61, 786.86, 32.6, 20.3),
(14, 824.61, 935.34, 52.6, 32.8),
(15, 826.37, 516.1, 12.4, 7.7),
(16, 824.61, 374.5, 12.6, 7.9),
(17, 824.61, 924.19, 32.6, 20.4),
(18, 626.81, 897.47, 52.6, 32.9),
(19, 224.76, 714.79, 72.6, 45.4),
(20, 224.76, 681.53, 12.4, 7.7),
(21, 427.25, 263.27, 32.7, 20.4),
(22, 224.76, 671.8, 52.7, 32.9),
(23, 424.9, 769.18, 72.7, 45.4),
(24, 227.69, 830.5, 12.7, 7.9),
(25, 424.9, 844.97, 12.4, 7.7),
(26, 424.9, 733.35, 52.7, 32.9),
(27, 828.13, 931.83, 72.8, 45.5),
(28, 625.05, 659.13, 12.8, 8),
(29, 625.05, 300.16, 32.8, 20.5);

-- @block
Truncate table Insurance;
INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon) VALUES
(1, 100, 10, 10, 20),
(2, 100, 10, 20, 30),
(3, 200, 10, 20, 80),
(4, 200, 10, 40, 60),
(5, 200, 10, 40, 60),
(6, 300, 10, 45, 65);

-- @block
WITH
dup AS 
(
    SELECT
    DISTINCT i1.pid AS dpid
    FROM Insurance AS i1
    CROSS JOIN Insurance AS i2
    ON i1.pid != i2.pid
    AND (i1.lat = i2.lat AND i1.lon = i2.lon)
),
un AS
(
    SELECT
    DISTINCT i1.pid AS upid
    FROM Insurance AS i1
    CROSS JOIN Insurance AS i2
    ON i1.tiv_2015 = i2.tiv_2015
    AND i1.pid != i2.pid
    WHERE i1.pid NOT IN (SELECT dpid FROM dup)
    AND i2.pid NOT IN (SELECT dpid FROM dup)
)
SELECT 
-- pid
-- , tiv_2016
ROUND(SUM(tiv_2016), 2) AS tiv_2016 
FROM Insurance as i
INNER JOIN un
ON i.pid = un.upid
;

-- @block
SELECT
DISTINCT i1.pid
-- i1.pid
-- , i2.pid
-- , i1.lat
-- , i2.lat
-- , i1.lon
-- , i2.lon
FROM Insurance AS i1
CROSS JOIN Insurance AS i2
ON i1.pid != i2.pid
AND (i1.lat = i2.lat AND i1.lon = i2.lon)
;

-- @block
WITH
dup AS 
(
    SELECT
    DISTINCT i1.pid AS dpid
    FROM Insurance AS i1
    CROSS JOIN Insurance AS i2
    ON i1.pid != i2.pid
    AND (i1.lat = i2.lat AND i1.lon = i2.lon)
)
SELECT
-- DISTINCT i1.pid AS upid
i1.pid
, i2.pid
, i1.tiv_2015
, i2.tiv_2015
, i1.tiv_2016
, i1.lat
, i2.lat
, i1.lon
, i2.lon
FROM Insurance AS i1
CROSS JOIN Insurance AS i2
ON i1.tiv_2015 = i2.tiv_2015
AND i1.pid != i2.pid
WHERE i1.pid NOT IN (SELECT dpid FROM dup)
AND i2.pid NOT IN (SELECT dpid FROM dup)
;

-- @block
SELECT
pid
-- , lat
-- , lon
, COUNT(lat) OVER(PARTITION BY lat, lon) AS cnt
FROM Insurance
;

-- @block
SELECT
pid
-- , tiv_2015
, COUNT(tiv_2015) OVER(PARTITION BY tiv_2015) AS cnt
FROM Insurance
;

-- @block
-- THE RIGHT ONE ---------------------------
WITH
dup AS
(
    SELECT
    pid
    , COUNT(lat) OVER(PARTITION BY lat, lon) AS cnt
    FROM Insurance
),
un AS
(
    SELECT
    pid
    , tiv_2016
    , COUNT(tiv_2015) OVER(PARTITION BY tiv_2015) AS cnt
    FROM Insurance
)
SELECT
-- *
ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM un
INNER JOIN dup
ON un.pid = dup.pid
WHERE un.cnt > 1
AND dup.cnt = 1
;