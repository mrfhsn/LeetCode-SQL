DROP TABLE Users;
Create table If Not Exists Users (user_id int, name varchar(30), mail varchar(50));
Truncate table Users;
insert into Users (user_id, name, mail) values ('1', 'Winston', 'winston@leetcode.com');
insert into Users (user_id, name, mail) values ('2', 'Jonathan', 'jonathanisgreat');
insert into Users (user_id, name, mail) values ('3', 'Annabelle', 'bella-@leetcode.com');
insert into Users (user_id, name, mail) values ('4', 'Sally', 'sally.come@leetcode.com');
insert into Users (user_id, name, mail) values ('5', 'Marwan', 'quarz#2020@leetcode.com');
insert into Users (user_id, name, mail) values ('6', 'David', 'david69@gmail.com');
insert into Users (user_id, name, mail) values ('7', 'Shapiro', '.shapo@leetcode.com');
insert into Users (user_id, name, mail) values ('8', 'Winston', 'winston@leetcode?com');
insert into Users (user_id, name, mail) values ('9', 'Brock', 'B@leetcode.com');
insert into Users (user_id, name, mail) values ('10', 'Win', 'winston@leetcode.COM');

-- @block
SELECT *
FROM Users
-- WHERE mail REGEXP '^[A-Za-z][A-Za-z0-9_.-]*(@leetcode\\.com)$'
-- WHERE mail REGEXP '^[A-Za-z][A-Za-z0-9_.-]*(@leetcode[.]com)$'
-- WHERE mail COLLATE utf8mb4_bin REGEXP '^[A-Za-z][A-Za-z0-9_.-]*@leetcode\\.com$'
-- WHERE REGEXP_LIKE(mail, '^[A-Za-z][A-Za-z0-9_.-]*(@leetcode\\.com)$', 'c')
WHERE REGEXP_LIKE(mail, '^[A-Za-z][A-Za-z0-9_.-]*(@leetcode[.]com)$', 'c')
;