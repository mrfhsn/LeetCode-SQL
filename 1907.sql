Create table If Not Exists Accounts (account_id int, income int);
Truncate table Accounts;
insert into Accounts (account_id, income) values ('3', '108939');
insert into Accounts (account_id, income) values ('2', '12747');
insert into Accounts (account_id, income) values ('8', '87709');
insert into Accounts (account_id, income) values ('6', '91796');

-- @block
SELECT 'Low Salary' AS category
UNION
SELECT 'Average Salary' AS category
UNION
SELECT 'High Salary' AS category
;

-- @block
WITH
cat AS (
    SELECT 'Low Salary' AS category
    UNION
    SELECT 'Average Salary' AS category
    UNION
    SELECT 'High Salary' AS category
),
salary_cat AS (
    SELECT
    CASE
        WHEN income < 20000 THEN 'Low Salary'
        WHEN income BETWEEN 20000 AND 50000 THEN 'Average Salary'
        ELSE 'High Salary'
    END AS category
    FROM Accounts
)
SELECT
c.category
, COUNT(sc.category) AS accounts_count
FROM cat AS c
LEFT JOIN salary_cat AS sc
ON c.category = sc.category
GROUP BY c.category
;