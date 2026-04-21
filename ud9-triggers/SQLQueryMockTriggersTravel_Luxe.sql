create database TRAVEL_LUXE
create or alter trigger FIND_VEHICLE
ON ROUTE
after Insert
as begin
	declare @idroute int =(select idroute from inserted)
	declare @numsear tinyint =(select SeatsRequired from inserted)
	declare @level tinyint = (select LevelRequired from inserted)
	declare @IdDriver int 
	declare @IdVehicle int 
	
	 -- find vehicle
	 Select top 1 @IdVehicle=IDVehicle, @IdDriver=IDDriver
	 from VEHICLES, DRIVERS
	 where StatusVeh = 'Available' 
		and Capacity=@numsear+1
		and Status = 'Available'
		and
		LevelDriver = @level

	if @IdDriver is NULL or @IdVehicle is Null
		begin
			print 'There is not a driver or vehicle available for the required'
			rollback transaction
			return
		end
	else
		begin
			update ROUTE
			set idvehicle=@IdVehicle
			where IDRoute=@idroute

			update DRIVERS
			set Status='Ocupied'
			where IDDriver = @IdDriver

			update VEHICLES
			SET StatusVeh = 'Ocupied'
			where IDVehicle = @IdVehicle

		end
end

--2.
create or alter trigger CALCULATE_TIME
on ROUTE
after UPDATE
as
begin
    declare @idroute int=(select idroute from inserted)
    declare @endtimeold time=(select endtime from deleted)
    declare @endtimenew time=(select endtime from inserted)
    declare @starttime time=(select starttime from inserted)
    declare @iddriver int=(select iddriver from inserted)
    declare @idvehicle int=(select idvehicle from inserted)
    declare @km int=(select km from inserted)
    declare @hourlyrate smallmoney=(select hourlyrate from drivers where iddriver=@iddriver)
    declare @date date=(select dateroute from inserted)
    declare @totaltime decimal(6,2)
    declare @hoursworking decimal(4,2)

    if @endtimenew is not NULL  --endtime is updated
    begin
        --car and driver are available
        update DRIVERS
        set status='Available'
        where iddriver=@iddriver

        update VEHICLES
        set statusveh='Available'
        where idvehicle=@idvehicle

        --update the time
        if @starttime<@endtimenew   --the driver arrived before midnight
            set @totaltime=datediff(minute,@starttime,@endtimenew)
        else    --the driver arrived after midnight
            begin
                set @totaltime=datediff(minute,@starttime,@endtimenew)+1440
            end

        --update totaltime in the table ROUTE
        update route
        set totaltime=@totaltime
        where idroute=@idroute

        --calculate salary --> la ida al precio hora y la vuelta a la mitad
        if @iddriver in (select iddriver from salaries
                where monthsal=month(@date) and yearsal=year(@date))
        begin
            update SALARIES
            set salary=salary+(@totaltime/120)*@hourlyrate+
                (@totaltime/120)*(@hourlyrate/2)
            where iddriver=@iddriver and monthsal=month(@date) and
                yearsal=year(@date)
        end

        else
        begin
            insert into SALARIES
            values (month(@date), year(@date), @iddriver,
                (@totaltime/120)*@hourlyrate+(@totaltime/120)*(@hourlyrate/2))
        end

        --update the km in the table KILOMETERS
        if @idvehicle in (select idvehicle from kilometers)
        begin
            update KILOMETERS
            set TotalKm=TotalKm+@km
            where idvehicle=@idvehicle
        end
        else
        begin
            insert into KILOMETERS
            values (@idvehicle, @km)
        end

    end
end