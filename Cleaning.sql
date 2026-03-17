create database end_to_end_project3;
use end_to_end_project3;
show tables;
select * from customer;

alter table `banking-realtionships`
rename column ï»¿BRId to BRId;

select * from `banking-realtionships`;

alter table gender
rename column ï»¿GenderId to GenderId;
select * from gender;

alter table `investment-advisiors`
rename column ï»¿IAId to IAId;

select * from `investment-advisiors`;

select * from customer;
create table customer2 like customer;
insert into customer2 select * from customer;




select * from(
select clientId,name,row_number() over (partition by clientId order by clientId) as ranks from customer2
)t
where ranks>1;
;

drop table customer2;
update customer2 set clientId=clientId+87380
where clientid in(select clientId from(
select clientId,row_number() over (partition by clientId order by clientId) as ranks from customer2
)t
where ranks>1
);

select count(*)
from customer2
group by clientId
having count(*)>1 ;

select min(clientid),max(ClientId) from customer2;

select * from customer2 where clientId='IND15088';

select ClientID,count(*) from customer2
group by ClientID
having count(*)>1;

select * from customer 
order by ClientID;

select count(ClientID) from customer2;

select * from customer2;
create table Banking as
select c.*,b.`Banking Relationship`,g.Gender,i.`Investment Advisor` 
from customer2 as c
left join `banking-realtionships` b
on c.BRId=b.BRId
left join gender g
on  c.GenderId=g.GenderId
left join `investment-advisiors` i
on c.IAId=i.IAId;

select * from banking;

alter table banking drop column  BRId;
alter table banking drop column   GenderId;
alter table banking drop column IAId;

select * from banking;
select count(distinct(clientId)) from banking;

with cte as(
 select *,row_number() over(partition by ClientId order by ClientId) as rn
from banking)
select * from cte where rn>1;

update banking 
set clientId=ClientId+1000
where clientId in(
select clientId from (SELECT ClientID,
        ROW_NUMBER() OVER (PARTITION BY ClientID ORDER BY ClientID) AS rn
        FROM banking
    ) t
    WHERE rn > 1
);

select count(*),clientId from banking 
group by clientId
having count(*)!=1;

select min(clientId),max(ClientId) from banking;

select * from banking where clientId =2000;

create table banking like customer2;
insert into banking select * from customer2;


WITH dup AS (
    SELECT 
           ClientID,
           ROW_NUMBER() OVER (PARTITION BY ClientID ORDER BY clientid) rn
    FROM customer2
)

UPDATE customer2 c
JOIN dup d
ON c.clientid = d.clientid
SET c.ClientID = CONCAT('IND', @max_id + d.rn)
WHERE d.rn > 1;


drop table banking;

select min(clientId),max(clientId) from customer2;
select clientId,count(*) from customer2  group by clientId  having count(*)>1;
select * from customer2 where clientId='IND35589';

select * from
customer;
drop table customer2;
drop table banking;

create table customer2 as 
select c.*,b.`Banking Relationship`,g.Gender,i.`Investment Advisor` from customer as c
left join `banking-realtionships`as b
on c.BRId=b.BRId
left join gender g
on c.GenderId=g.GenderId
left join `investment-advisiors` i 
on c.IAId=i.IAId;

alter table customer2 drop column IAId ;

select * from customer2;

drop table customer;


rename table csutomer to customer;

alter table customer rename column `ï»¿Client ID` to ClientID;

select clientId,count(*)
 from customer2
 group by clientId
 having count(*)>1;

select * from customer2;

alter table customer2 add column temp_id int auto_increment primary key;
select * from customer2;

WITH cte AS (
    SELECT temp_id, ClientID,
           ROW_NUMBER() OVER (PARTITION BY ClientID ORDER BY ClientID) rn
    FROM customer2
),
max_id AS (
    SELECT MAX(CAST(TRIM(LEADING 'IND' FROM ClientID) AS UNSIGNED)) max_val
    FROM customer2
)
UPDATE customer2 c
JOIN cte t ON c.temp_id = t.temp_id
CROSS JOIN max_id m
SET c.ClientID = CONCAT('IND', m.max_val + t.rn)
WHERE t.rn > 1;


select * from customer2;

select ClientID,count(*) from customer2
group by clientId
having count(*)>1;


select * from customer2;


