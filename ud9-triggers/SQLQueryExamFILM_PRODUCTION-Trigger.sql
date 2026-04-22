create database FILM_PRODUCTION

--1. UPDATE_PROP When a purchase is made from a supplier (insert into ORDERS_DETAILS), the trigger must 
--perform the following actions:
-- * Increase the stock of the prop (PROP)
-- * Update the retail price by increasing it by 20% in relation to the purchase price
create or alter trigger UPDATE_PROP
on ORDERS_DETAILS
after INSERT
as begin
	declare @IdProp smallint =(select IdProp from inserted)
	declare @quantitu smallint =(select Quantity from inserted)
	declare @price smallmoney =(select UnitPrice from inserted)

	update PROP
	set Stock = Stock+@quantitu,RetailPrice = @price*1.20
	where IdProp = @IdProp

end
select * from ORDERS
select * from ORDERS_DETAILS
select * from PROP

-- insert into SUPPLIER values ('Atrezzo Madrid', '666123456')
-- insert into PROP values (1, 'Espada medieval', 50, 10, 0, null)
-- insert into ORDERS values (1, getdate())
-- insert into ORDERS_DETAILS values (3, 1, 10, 25.00)

-------------------------------------------------------------------------------------------------------
--2. UPDATE_SCENE_STATUS When a scene date is updated, if the new date is in the past, the trigger must 
--update the StatusScene to 'filmed'.
create or alter trigger UPDATE_SCENE_STATUS
on SCENE
after UPDATE
as begin
    declare @IdScene tinyint =( select IdScene from inserted)
    declare @IdMovie int =(select IdMovie from inserted)
    declare @DateOld date =(select DateScene from deleted)
    declare @DateNew date =(select DateScene from inserted)

    if @DateNew < getdate() and @DateOld >= getdate()
        begin
            UPDATE SCENE
            set StatusScene = 'filmed'
            where IdScene = @IdScene and IdMovie = @IdMovie
        end
end

-- insert into SCENE values (2, 1, 'Escena final', 'pending', '01/12/2026')

update SCENE
set DateScene = '01/01/2026'
where IdScene = 2 and IdMovie = 1

-- select * from SCENE

-------------------------------------------------------------------------------------------------------
--3. CHECK_PROP_STOCK When a prop is assigned to a scene (insert into SCENE_PROP), the trigger must 
--perform the following actions:
-- * Decrease the stock of the prop in PROP
-- * If the new stock is lower than or equal to FlagStock, set Flag to 1
create or alter trigger CHECK_PROP_STOCK
on SCENE_PROP
after insert
as
begin
    declare @idprop smallint = (select IdProp from inserted)
    declare @quantity smallint = (select Quantity from inserted)

    update PROP
    set Stock = Stock - @quantity
    where IdProp = @idprop

    if (select Stock from PROP where IdProp = @idprop)
        <= (select FlagStock from PROP where IdProp = @idprop)
    begin
        update PROP
        set Flag = 1
        where IdProp = @idprop
    end
end
-------------------------------------------------------------------------------------------------------
-- 4. UPDATE_SALARY_PREP When an employee works on a scene preparation (insert into PREPARATION), 
--the trigger must perform the following actions:
-- * Calculate the salary for that preparation (HoursPrep * Hourly_Rate)
-- * If there is already a record in SALARY for that employee, month and year, add the amount
-- * If there is no record, insert a new row
create or alter trigger UPDATE_SALARY_PREP
on PREPARATION
after INSERT
as begin
	declare @IdEmployee char(5) =(select IdEmployee from inserted)
	declare @dateprep date =(select DatePrep from inserted)
	declare @hoursPrep tinyint =(select HoursPrep from inserted)
	declare @salary smallmoney
	
	select @salary = Hourly_Rate*@hoursPrep from EMPLOYEE where IdEmployee = @idemployee

	if exists (select IdEmployee from SALARY where IdEmployee = @IdEmployee and YearSal = year(@dateprep) and MonthSal = month(@dateprep))
		begin
			UPDATE SALARY
			set Salary = Salary + @salary
			where IdEmployee = @IdEmployee
		end
	else
		begin
			insert into SALARY values (@IdEmployee, year(@dateprep), Month(@dateprep), @salary)
		end
end

select * from EMPLOYEE
select * from SCENE
select * from SALARY
select * from PREPARATION
select * from MOVIE
-- insert into EMPLOYEE values ('EMP01', 'Ana García', 'Director', 25.00)
-- insert into EMPLOYEE values ('EMP02', 'Juan López', 'Cameraman', 20.00)
-- insert into MOVIE values ('Mi Película', null, 120, 'Spanish', 'Spain')
-- insert into SCENE values (1, 1, 'Escena apertura', 'pending', '01/06/2026')
-- insert into PREPARATION values ('EMP01', 1, 1, getdate(), 5)
-------------------------------------------------------------------------------------------------------
-- 5. UPDATE_PROP_PRICE When a new order detail is inserted (insert into ORDERS_DETAILS), the trigger 
--must perform the following actions:
-- * Increase the stock of the prop
-- * Update the retail price to 20% above the purchase price
-- * If the new stock is greater than FlagStock, set Flag to 0
create or alter trigger UPDATE_PROP_PRICE
on ORDERS_DETAILS
after INSERT
as begin
    declare @idprop smallint =(select IdProp from inserted)
    declare @quantity smallint =(select Quantity from inserted)
    declare @unitprice smallmoney =(select UnitPrice from inserted)

    UPDATE PROP
    set Stock = Stock + @quantity, 
        RetailPrice = @unitprice * 1.20
    where IdProp = @idprop
    
    if (select Stock from PROP where IdProp = @idprop)
        > (select FlagStock from PROP where IdProp = @idprop)
        begin
            UPDATE PROP
            set Flag = 0
            where IdProp = @idprop
        end
end
-------------------------------------------------------------------------------------------------------
-- 6. CHECK_SCENE_PREP When a new preparation is inserted, the trigger must check that the scene exists 
--and belongs to the movie. If not, display a message and rollback.
create or alter trigger CHECK_SCENE_PREP
on PREPARATION
after insert
as
begin
    declare @idemployee char(5) = (select IdEmployee from inserted)
    declare @idscene tinyint = (select IdScene from inserted)
    declare @idmovie int = (select IdMovie from inserted)

    if not exists (select IdScene from SCENE
                   where IdScene = @idscene and IdMovie = @idmovie)
    begin
        print 'Error: the scene does not belong to this movie'
        rollback
    end
end
-------------------------------------------------------------------------------------------------------
-- 7. UPDATE_SALARY_SCENE When the status of a scene is updated to 'filmed', the trigger must perform 
--the following actions:
-- * Calculate the salary for each employee who prepared that scene (HoursPrep * Hourly_Rate)
-- * If there is already a record in SALARY for that employee, month and year, add the amount
-- * If there is no record, insert a new row
create or alter trigger UPDATE_SALARY_SCENE
on SCENE
after update
as begin
    declare @IdScene tinyint = (select IdScene from inserted)
    declare @IdMovie int = (select IdMovie from inserted)
    declare @StatusOld varchar(20) = (select StatusScene from deleted)
    declare @StatusNew varchar(20) = (select StatusScene from inserted)

    declare @IdEmployee char(5)
    declare @hoursprep tinyint
    declare @date date
    declare @hourlyrate smallmoney
    declare @salary smallmoney

    if @StatusOld <> 'filmed' and @StatusNew = 'filmed'
    begin
        declare cursor_salary cursor
        for select IdEmployee, HoursPrep, DatePrep
            from PREPARATION
            where IdScene = @IdScene and IdMovie = @IdMovie

        open cursor_salary
        fetch next from cursor_salary into @IdEmployee, @hoursprep, @date

        while @@FETCH_STATUS = 0
        begin
            set @hourlyrate = (select Hourly_Rate from EMPLOYEE
                               where IdEmployee = @IdEmployee)
            set @salary = @hoursprep * @hourlyrate

            if exists (select IdEmployee from SALARY
                       where IdEmployee = @IdEmployee
                       and YearSal = year(@date)
                       and MonthSal = month(@date))
            begin
                update SALARY
                set Salary = Salary + @salary
                where IdEmployee = @IdEmployee
                and YearSal = year(@date)
                and MonthSal = month(@date)
            end
            else
            begin
                insert into SALARY
                values (@IdEmployee, year(@date), month(@date), @salary)
            end

            fetch next from cursor_salary into @IdEmployee, @hoursprep, @date
        end

        close cursor_salary
        deallocate cursor_salary
    end
end

select * from PREPARATION where IdScene = 1 and IdMovie = 1

update SCENE
set StatusScene = 'filmed'
where IdScene = 1 and IdMovie = 1
select * from SALARY
-------------------------------------------------------------------------------------------------------
-- 8. FILM_SCENE_PROPS When a scene is filmed (StatusScene updated to 'filmed'), the trigger must 
--perform the following actions:
-- * Decrease the stock of all props used in that scene (SCENE_PROP) in the PROP table
-- * For each prop whose stock falls to 5 or fewer, set Flag to 1
create or alter trigger FILM_SCENE_PROPS
on SCENE
after update
as
begin
    declare @idscene tinyint = (select IdScene from inserted)
    declare @idmovie int = (select IdMovie from inserted)
    declare @statusold varchar(8) = (select StatusScene from deleted)
    declare @statusnew varchar(8) = (select StatusScene from inserted)

    if @statusold <> 'filmed' and @statusnew = 'filmed'
    begin
        declare @idprop smallint
        declare @quantity smallint

        declare prop_cursor cursor
        for select IdProp, Quantity
            from SCENE_PROP
            where IdScene = @idscene and IdMovie = @idmovie

        open prop_cursor
        fetch next from prop_cursor into @idprop, @quantity

        while @@FETCH_STATUS = 0
        begin
            update PROP
            set Stock = Stock - @quantity
            where IdProp = @idprop

            if (select Stock from PROP where IdProp = @idprop) <= 5
            begin
                update PROP
                set Flag = 1
                where IdProp = @idprop
            end

            fetch next from prop_cursor into @idprop, @quantity
        end

        close prop_cursor
        deallocate prop_cursor
    end
end
-------------------------------------------------------------------------------------------------------
-- 9. UPDATE_MOVIE_DURATION When a new scene is inserted into SCENE, the trigger must update the 
--DurationMinutes of the movie by adding 5 minutes per scene.
-- Additionally, for each employee who has already prepared a scene of that movie, update their salary adding 50€ bonus.
create or alter trigger UPDATE_MOVIE_DURATION
on SCENE
after INSERT
as begin
    declare @idmovie int =(select IdMovie from inserted)

    UPDATE MOVIE
    set DurationMinutes = DurationMinutes + 5
    where IdMovie = @idmovie
    
    declare @idemployee char(5)

    declare cursor_employee cursor
    for select distinct IdEmployee 
        from PREPARATION
        where IdMovie = @idmovie

    open cursor_employee
    fetch next from cursor_employee into @idemployee
    
    while @@FETCH_STATUS = 0
        begin
            if exists (select IdEmployee from SALARY where IdEmployee=@idemployee and YearSal = year(getdate()) and MonthSal = month(getdate()))
                begin
                    update SALARY
                    set Salary = Salary + 50
                    where IdEmployee = @idemployee
                    and YearSal = year(getdate())
                    and MonthSal = month(getdate())
                end
            else
                begin
                    insert into SALARY values (@idemployee, year(getdate()), month(getdate()), 50)
                end
            
            fetch next from cursor_employee into @idemployee
        end
        close cursor_employee
        deallocate cursor_employee
 
end
-------------------------------------------------------------------------------------------------------
-- 10. ORDER_PROPS_SCENE When a new order detail is inserted (insert into ORDERS_DETAILS), the trigger 
--must perform the following actions:
-- * Increase the stock of the prop in PROP
-- * Update the retail price to 20% above the purchase price
-- * For each scene that uses that prop (SCENE_PROP), if the updated stock covers the quantity needed, set the StatusScene to 'prepared'
create or alter trigger ORDER_PROPS_SCENE
on ORDERS_DETAILS
after insert
as
begin
    declare @idprop smallint = (select IdProp from inserted)
    declare @quantity smallint = (select Quantity from inserted)
    declare @unitprice smallmoney = (select UnitPrice from inserted)

    update PROP
    set Stock = Stock + @quantity,
        RetailPrice = @unitprice * 1.20
    where IdProp = @idprop

    declare @idscene tinyint
    declare @idmovie int
    declare @qtyscene smallint
    declare @stocknow smallint

    declare scene_cursor cursor
    for select IdScene, IdMovie, Quantity
        from SCENE_PROP
        where IdProp = @idprop

    open scene_cursor
    fetch next from scene_cursor into @idscene, @idmovie, @qtyscene

    while @@FETCH_STATUS = 0
    begin
        set @stocknow = (select Stock from PROP where IdProp = @idprop)

        if @stocknow >= @qtyscene
        begin
            update SCENE
            set StatusScene = 'prepared'
            where IdScene = @idscene and IdMovie = @idmovie
            and StatusScene = 'pending'
        end

        fetch next from scene_cursor into @idscene, @idmovie, @qtyscene
    end

    close scene_cursor
    deallocate scene_cursor
end
-------------------------------------------------------------------------------------------------------
-- 11. When the status of a scene is updated to 'filmed', the trigger must perform the following actions:
-- * If the scene was filmed on or before the scheduled date (DateScene), each employee is awarded a 10% 
--increase on their hourly rate for every preparation session they worked on that scene.
-- * If the scene was filmed after the scheduled date, each employee is awarded a 3% increase on their hourly 
--rate for every preparation session they worked on that scene.
create or alter trigger TRIG_UPDATE_SALARY
on SCENE
after update
as
begin
    declare @idscene tinyint = (select IdScene from inserted)
    declare @idmovie int = (select IdMovie from inserted)
    declare @statusold varchar(8) = (select StatusScene from deleted)
    declare @statusnew varchar(8) = (select StatusScene from inserted)

    declare @idemployee char(5)
    declare @hoursprep tinyint
    declare @date date
    declare @hourlyrate smallmoney
    declare @points smallmoney
    declare @numprep tinyint

    declare emp_cursor cursor
    for select IdEmployee
        from PREPARATION
        where IdScene = @idscene and IdMovie = @idmovie
        group by IdEmployee

    open emp_cursor
    fetch next from emp_cursor into @idemployee

    while @@FETCH_STATUS = 0
    begin
        -- si la escena se filmo antes o en la fecha prevista, bonus del 10%
        -- si se filmo despues, bonus del 3%
        if @statusold <> 'filmed' and @statusnew = 'filmed'
        begin
            set @hourlyrate = (select Hourly_Rate from EMPLOYEE
                               where IdEmployee = @idemployee)

            select @numprep = COUNT(*)
            from PREPARATION
            where IdEmployee = @idemployee
            and IdScene = @idscene and IdMovie = @idmovie

            if getdate() <= (select DateScene from inserted)
                set @points = @hourlyrate * 0.10 * @numprep
            else
                set @points = @hourlyrate * 0.03 * @numprep

            update EMPLOYEE
            set Hourly_Rate = Hourly_Rate + @points
            where IdEmployee = @idemployee
        end

        fetch next from emp_cursor into @idemployee
    end

    close emp_cursor
    deallocate emp_cursor
end