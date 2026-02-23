--1. Create a table named TOTALS_CENTERS. The table must have the following fields: 19 points
--NameCenter
--Subtotal
--Discount
--Total
--This table will store the totals spent for every Relief Center
create table TOTALS_CENTERS(
NameCente varchar(100)
,Subtotal money
,Discount money
,Total money
)
insert into TOTALS_CENTERS
select NameCenter, sum(UnitPrice*Quantity)as Subtotal, sum(UnitPrice*Quantity*Discount/100) as Discount,
		sum(unitprice*quantity*(100-discount)/100) as Total
from RELIEF_CENTER, ORDERS, ORDERS_DETAILS
where RELIEF_CENTER.CenterId=ORDERS.CenterId 
 and ORDERS.IdOrder=ORDERS_DETAILS.IdOrder
group by NameCenter

--------------------------------
--2.An NGO decides to donate resources but only has certain types available. For hygiene products, 
--it donates 2000 units of each type; for medical supplies, it donates 1000 units of each type; and 
--for clothing and textiles, it donates 20% of the current stock available. Update the stock of the 
--resources with the units given by the NGO.
update RESOURCES
set Stock = Stock + 
	case 
		when TypeRes = 'hygiene products' then 2000
		when TypeRes ='medical supplies' then 1000
		when TypeRes ='clothing and textiles' then Stock*0.20
		else 0
	end
where TypeRes in ('hygiene products','medical supplies','clothing and textiles')
--------------------------------
--3.According to tax regulations, we are required to keep invoices from the last three years. We want 
--to delete all invoices that are three years old or older, as they are taking up unnecessary space 
--in the database.

Delete from ORDERS
where DATEDIFF(year, DateOrder,GETDATE())>=3

--------------------------------
--4.The RESOURCES table contains potential resources that can be used in disasters. It has been 
--identified that some of these resources have never been bought for any disaster. The resources 
--and the supplier who supply them are occupying unnecessary space in the database and are not 
--expected to be used in the future. Therefore, they should be deleted.
delete from SUPPLIER
where IdSupplier in(
	select IdSupplier 
	from RESOURCES
	where not exists(
		select 1
		from ORDERS_DETAILS
		where ORDERS_DETAILS.IdRes=RESOURCES.IdRes
		)
	)
delete from RESOURCES
where not exists(
	select 1
	from ORDERS_DETAILS,RESOURCES
	where ORDERS_DETAILS.IdRes=RESOURCES.IdRes
)
--------------------------------
--5. It has been detected that some disaster victims are taking advantage of the situation and 
--requesting too many resources. From now on, only 3 donations are allowed per beneficiary. 
--Verify that the beneficiary exists.
--Verify that the resource exists.
--Ensure that the beneficiary has not received 3 or more donations.
--Try the transact for: beneficiary: John Doe, Resource: Bandages, 20 units.


--------------------------------
--6.Create a table named REWARD_VOLUNTEERS. The table must have the following fields: 30 points
--NameVolunteer
--TotalHoursWorking
--Reward
--This table will store the volunteers who have worked on more than two projects, who have worked for 
--14 days or more, and who have worked at least 4 hours every single day. Those who meet the above 
--conditions will receive a bonus of 10€ for each hour worked.
create table REWARD_VOLUNTEERS (
	NameVolunteer varchar (50)
	,TotalHours decimal(3,2)
	,Reward decimal(5,2)
)
insert into REWARD_VOLUNTEERS(NameVolunteer,TotalHours,Reward)
select NameVol, sum(HoursWork) as TotalHoursWorking,sum(HoursWork)*10 as Reward
from VOLUNTEER_HOURS
join VOLUNTEER on VOLUNTEER_HOURS.NumVol=VOLUNTEER.NumVol
group by NameVol,HoursWork
having count(distinct IdProject)>2
	and count(distinct DateWork)>=14
	and min(HoursWork)>=4

--------------------------------
--Update the volunteers’ level based on the total number of hours.
update VOLUNTEER
SET LevelVolunteer = (
	select sum(HoursWork)
	from VOLUNTEER_HOURS, VOLUNTEER
	where VOLUNTEER_HOURS.NumVol=VOLUNTEER.NumVol
)

