-- create database ELITE_EAGLES -----------------------------------------------------------------------

-- 1. TRIG_ INSERT. Write a trigger to update the table DEFAULTER when a new registration is 
-- made in the table REGISTERED. The trigger checks if the member did not pay (Registration_fee is 0) 
--and creates a new row in the table DEFAULTER.

----------------------------------Insert the following data in the table REGISTERED:
create or alter trigger TRIG_INSERT
on REGISTERED
after INSERT
as begin
	declare @id int =(select IdMember from inserted)
	declare @sport varchar(8)=(select sport from inserted)
	declare @fee bit=(select Registration_fee from inserted)

	if @fee=0
	begin
		insert into DEFAULTER
		values (@id,@sport)
	end
end

insert into REGISTERED values(1, 'Tennis',0)
-- select*from DEFAULTER

----------------------------------The table DEFAULTER will be:
create or alter trigger TRIG_INSERT
on REGISTERED
after UPDATE
as begin
	declare @id int =(select IdMember from inserted)
	declare @sport varchar(8)=(select sport from inserted)
	declare @fee_old bit=(select Registration_fee from deleted)
	declare @fee_new bit=(select Registration_fee from inserted)

	if @fee_old=0 and @fee_new=1
	begin
		delete
		from DEFAULTER
		where IdMember=@id and Sport=@sport
	end
end

update REGISTERED
set Registration_fee=1
where IdMember = 1 and Sport = 'Tennis'

-- select * from DEFAULTER
-- select * from REGISTERED

-------------------------------------------------------------------------------------------------------
-- 2.

-------------------------------------------------------------------------------------------------------
-- create database CHAMPIONSHIP -----------------------------------------------------------------------
-- 9. TRIG_RANKING. Write a trigger that checks if the home team won and give 3 points to it and 0 to 
--the away team, if the away team won, give 3 points to it and 0 to the home team and if the two teams 
--tied, give them 1 point each.
create or alter trigger TRIG_RANKING
on MATCH
after INSERT
as begin
    declare @day int = (select DayMatch  from inserted)
    declare @home varchar(50) = (select HomeTeam  from inserted)
    declare @away varchar(50) = (select AwayTeam  from inserted)
    declare @homeGoal int = (select HomeGoal  from inserted)
    declare @awayGoal int = (select AwayGoal  from inserted)

    if @homeGoal > @awayGoal
    begin
        insert into STANDING values (@day, @home, 3)
        insert into STANDING values (@day, @away, 0)
    end
    else if @awayGoal > @homeGoal
    begin
        insert into STANDING values (@day, @away, 3)
        insert into STANDING values (@day, @home, 0)
    end
    else
    begin
        insert into STANDING values (@day, @home, 1)
        insert into STANDING values (@day, @away, 1)
    end
end

insert into MATCH values (1, 'Madrid', 'Barça', 2, 0)
insert into MATCH values (2, 'Valencia', 'Sevilla', 1, 1)
insert into MATCH values (3, 'Betis', 'Atlético', 0, 1)

-- select * from STANDING

-------------------------------------------------------------------------------------------------------
-- create database PHONE_BILL -------------------------------------------------------------------------
-- 10. TRIG_UPDATE_BILL. Write a trigger that after each phone call updates the customer’s bill. 
--Use the command MERGE to check if you need to INSERT or UPDATE.                       -- CORREGIDO
create or alter trigger TRIG_UPDATE_BILL
on PHONECALL
after INSERT
as begin
    declare @dni varchar(20)=(select DNI from inserted)
    declare @seconds int = (select Seconds from inserted)
    declare @month int = (select month(DateCall) from inserted)
    declare @year int = (select year(DateCall) from inserted)

    declare @codePlan int = (select CodePlan from CUSTOMER where DNI = @dni)
    declare @connFee decimal(10,4) = (select ConnectionFee from PRICINGPLAN where Code = @codePlan)
    declare @pricePerSec decimal(10,4) = (select PricePerSecond from PRICINGPLAN where Code = @codePlan)

    declare @cost decimal(10,4) = @connFee + (@seconds * @pricePerSec)

    merge BILL as target
    using (select @dni as DNI, @month as MonthCall, @year as YearCall) as source
    on (target.DNI = source.DNI and target.MonthCall = source.MonthCall and target.YearCall = source.YearCall)
    when matched then
        update set Amount = Amount + @cost
    when not matched then
        insert values (@dni, @month, @year, @cost);
end

insert into PHONECALL values ('012.456.223-A', '20/02/2022', '20:25', '666999999', 120)

-- select * from BILL
-- select * from PHONECALL
-- select * from CUSTOMER
-- select * from BILL

-- otra opcion 
create or alter trigger TRIG_UPDATE_BILL
on PHONECALL
after INSERT
as begin
    declare @dni varchar(20)=(select DNI from inserted)
    declare @seconds int = (select Seconds from inserted)
    declare @month int = (select month(DateCall) from inserted)
    declare @year int = (select year(DateCall) from inserted)
    declare @codePlan int = (select CodePlan from CUSTOMER where DNI = @dni)
    declare @amount money=(
                select @seconds*PricePerSecond+ConnectionFree
                from pricingplan where code=@codePlan)

    if @dni in (select dni from Bill where monthcall=@month and yearcall=@year)
        begin
            update bill
            set amount=amount+@amount
            where dni=@dni and monthcall=@month and yearcall=@year
        end

    else
        begin
            insert into bill values (@dni, @month, @year, @amount)
        end
end

-------------------------------------------------------------------------------------------------------
-- create database VOLLEYBALL -------------------------------------------------------------------------
-- 11.TRIG_WONGAMES. Write a trigger that keeps the value of WonGames after insertions in MATCH 
--considering that WonGames is relative to the entire history of the team, not only the current 
--tournament, and that a team wins a game when it wins 3 sets.
create or alter trigger TRIG_WONGAMES                                          
on MATCH
after INSERT
as begin
    declare @team1 varchar(50) = (select Team1 from inserted)
    declare @team2 varchar(50) = (select Team2 from inserted)
    declare @wonSet1 int  = (select WonSetTeam1 from inserted)
    declare @wonSet2 int = (select WonSetTeam2 from inserted)

    if @wonSet1 = 3
    begin
        update TEAM
        set WonGames = WonGames + 1
        where Team = @team1
    end
    else if @wonSet2 = 3
    begin
        update TEAM
        set WonGames = WonGames + 1
        where Team = @team2
    end
end

insert into MATCH values (1, '01/01/2024', 'Valencia', 'Madrid', 3, 1, 'Pérez')
select * from TEAM 

insert into MATCH values (2, '02/01/2024', 'Barça', 'Sevilla', 0, 3, 'García')
select * from TEAM 

-------------------------------------------------------------------------------------------------------
-- 12.TRIG_UPDATE_PLAYED. Write a trigger that keeps PlayedMatches updated after insertions in PLAYED.
create or alter trigger TRIG_UPDATE_PLAYED
on PLAYED
after INSERT
as begin
    declare @playerID int = (select PlayerID from inserted)

    update PLAYER
    set PlayedMatches = PlayedMatches + 1
    where PlayerID = @playerID
end

insert into PLAYED values (1, 1, 'Libero', 5)
select * from PLAYER 
-- create database BLUEPLANET_TRADER -----------------------------------------------------------------------------------------------------
-- 13.TRIG_UPDATE_ORDER_ORDERITEM. Write a trigger that updates the price of a product in the Orderitem 
-- table and updates the total amount of the order in the order table. 

-- create database AMX -----------------------------------------------------------------------------------------------------

-- 14.TRIG_INSERT_JOB_HISTORY. Write a trigger that inserts a new row in the job_history table when an employee changes his position. 
-- For example, when the employee 177 changes his current position (SA_REP) to SA_MAN, there will be an insertion in job_history:
-------------------------------------------------------------------------------------------------------

-- 15.
-------------------------------------------------------------------------------------------------------


-- create database WEST_END_MUSIC -----------------------------------------------------------------------------------------------------
-- 17. TRIG_INSERT_EMPLOYEE. Write a trigger that will not be allowed to insert employees younger than 25 years old.
create or alter trigger TRIG_INSERT_EMPLOYEE                                                            -- CORREGIDO
on Employee
after INSERT
as begin
    declare @datebirth date=(select birthdate from inserted)
    declare @age tinyint=(select datediff(day, @datebirth, getdate()))/365
    if @age<25
    begin
        print 'the employee is younger than 25. The employee will not be inserted'
        rollback transaction
    end
end

insert into Employee values ('García', 'Pepe', 'IT Staff', 6, '10/01/2000', GETDATE(), null, 'Alicante',
'CV', 'Spain', '03007', '(+34)666454545', null, 'pepegarcia@gmail.com')

select * from Employee
-------------------------------------------------------------------------------------------------------
-- 23. TRIG_INSERT_ORDERS_DETAILS. Write a trigger to do the following actions after a new insertion 
-- in orders details:


-------------------------------------------------------------------------------------------------------
-- 24. TRIG_SHIPPED_PRODUCTS. Write a trigger that update UnitsOnOrder when the shippedDate (orders) 
-- is updated.
-------------------------------------------------------------------------------------------------------
-- 25. TRIG_UPDATE_SALARY. Write a trigger that gives a 200€ pay rise to an employee every time that 
-- a new child is inserted in the dependents table.
-------------------------------------------------------------------------------------------------------
-- 26. TRIG_CHECK_NUM_TEACHER. Write a trigger that will not be allowed to insert more than 5 teachers 
-- in a department.


-- create database UNIVERSITY -----------------------------------------------------------------------------------------------------
-- 27. TRIG_INSERT_EMPLOYEE. Write a trigger to check if the level of the job is between 10 to 22 after 
-- a new insertion in employees.                                                --CORREGIDO
create or alter trigger TRIG_INSERT_EMPLOYEE
on TEACHER_DEPARTMENT
after INSERT
as begin
    declare @num_teacher tinyint
    declare @iddep int=(select id_depart from inserted)

    select @num_teacher=count(id_depart)
    from TEACHER_DEPARTMENT
    where id_depart=@iddep

    if @num_teacher>5
        begin
            print 'THERE ARE 5 TEACHERS WORKING IN THE DEPARTMENT. IT IS NOT ALLOWERD TO ADD MORE'
            rollback transaction
        end
end

insert into MEMBER
values
('21485621p','Antonio','Pérez','García', 'Alicante', 'C/ Los doscientos, 25', '666259878','23/06/1978','H','profesor')

insert into TEACHER_DEPARTMENT values (29,9)

select * from TEACHER_DEPARTMENT
select * from MEMBER
-- create database PMI_PROJECTS -----------------------------------------------------------------------------------------------------
-- 28. TRIG_INSERT_EMPLOYEE_PROJECT. Write a trigger to check if the level of the employee is enough to work in the project.
create or alter trigger TRIG_INSERT_EMPLOYEE_PROJECT
on employee_project
after insert
as begin
    declare @employeeid bigint=
    declare @projectid
    declare @levelemployee
    declare @levelproject

-------------------------------------------------------------------------------------------------------
-- 29. TRIG_UPDATE_STATUS. Write a trigger to update status to ‘Entregado’ when Delivery_date is update 
-- on the orders table. If the order was delivered before it was expected, the Comment will be ‘La entrega llego antes de lo esperado’


-------------------------------------------------------------------------------------------------------
-- 30. TRIG_INSERT_PRODUCT. Write a trigger to check if the price is lower than cost_price.