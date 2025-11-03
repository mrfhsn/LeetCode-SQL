Create table If Not Exists Patients (patient_id int, patient_name varchar(30), conditions varchar(100));
Truncate table Patients;
insert into Patients (patient_id, patient_name, conditions) values ('1', 'Daniel', 'YFEV COUGH');
insert into Patients (patient_id, patient_name, conditions) values ('2', 'Alice', '');
insert into Patients (patient_id, patient_name, conditions) values ('3', 'Bob', 'DIAB100 MYOP');
insert into Patients (patient_id, patient_name, conditions) values ('4', 'George', 'ACNE DIAB100');
insert into Patients (patient_id, patient_name, conditions) values ('5', 'Alain', 'DIAB201');
insert into Patients (patient_id, patient_name, conditions) values ('6', 'Dell', 'SADIAB100');

-- @block
SELECT patient_id, patient_name, conditions
FROM Patients
-- WHERE conditions LIKE '%DIAB1%'
-- WHERE conditions LIKE 'DIAB1%'
WHERE conditions LIKE '% DIAB1%'
OR conditions LIKE 'DIAB1%'
;