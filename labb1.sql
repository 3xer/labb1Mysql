
 create table successful_mission as
 (select * from moon_mission where outcome = 'successful');
 alter table successful_mission add primary key (mission_id);
 select operator from moon_mission;
 select replace(operator, ' ', '') from successful_mission;
 select replace(operator, ' ', '') from moon_mission;




 delete from successful_mission where launch_date < '2009-12-31';
 select launch_date from successful_mission;
 select * from account;
 ALTER TABLE account
    ADD COLUMN GENDER VARCHAR(6);


UPDATE account
SET GENDER = CASE
                 WHEN SUBSTRING(ssn, LENGTH(ssn)-1, 1) % 2 = 0 THEN 'female'
ELSE 'male'
END
where GENDER IS NULL;
select * FROM account;

DELETE FROM account
       WHERE GENDER = 'female' AND LEFT(ssn, 2)<70;
SELECT * FROM account;

SELECT GENDER, AVG(YEAR(CURRENT_DATE) - (1900 + CAST(LEFT(ssn, 2) AS SIGNED))) AS average_age
from account
GROUP BY GENDER;



