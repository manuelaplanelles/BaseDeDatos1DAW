--mocK exam--MEDITECH
create or alter procedure STAYS_MONT_YEAR (@month tinyint, @year char(4))
as begin

	declare @patient varchar(50)
	declare @pcp int
	declare @start date
	declare @finis date
	declare @total_day tinyint
	declare @primId int, @ultId int

	set @primId = (select MIN(PatientSSN)from PATIENT)
    set @ultId = (select MAX(PatientSSN)from PATIENT)

    while @primId <= @ultId
		set @patient =(select NamePatient from PATIENT where NamePatient=@patient)
		set @pcp =(select PCP from PATIENT where PCP=@pcp)
		set @start =(select Start from HOSPITALIZE where Start=@start)
		set @finis =(select Finish from HOSPITALIZE where Finish=@finis)
		set @total_day =(select datediff(dd, Start, Finish)as Total from HOSPITALIZE where =@total_day)

		print 'PATIENT: '+@patient+'        PCP: '+@


end
--exec STAYS_MONT_YEAR @month=6, @year='2008'

------------------------------------------------------------------------------
--PATIENT_APPOINTMENTS. Create a procedure to display the appointments of the patients give as parameter. 
--Display all the medicines as well prescribed in every appointment.
create or alter procedure PATIENT_APPOINTMENTS (@SSN int)
as begin
	declare @list as varchar(max)=''
	declare @patient varchar(50)

	if not exists (select PatientSSN from PATIENT where PatientSSN=@SSN)
		begin
	
			select @patient=NamePatient from PATIENT where PatientSSN=@SSN
			print 'PATIENT: '+@patient
	
			select @list=@list+char(10)
				+'DATE: '+CAST(DateAppointment as char(10))
				+replicate('-',28)+char(10)
				+space(10)+'PRESCRIOTIONS'+char(10)
				+space(10)+replicate('*',17)+char(10)
				+STRING_AGG(concat(space(10),cast(NameMediccation as char(15)),dose),
				char(10))+char(10)
			from APPOINTMENT,PRESCRIPTION,MEDICATION
			where APPOINTMENT.PatientSSN=@ssn 
				and APPOINTMENT.AppointmentID=PRESCRIPTION.AppointmentID
				and PRESCRIPTION.CodeMed=MEDICATION.CodeMed
			group by DateAppointment
				print @list
		end
	else print 'THIS SSN IS NOT CORRECT'
end

--exec PATIENT_APPOINTMENTS 100000010

------------------------------------------------------------------------------
--4.NEW_ON_CALL
CREATE OR ALTER PROCEDURE NEW_ON_CALL 
	(@name varchar(30),@bloockfloor int,@blockcode int,@startDate date,@startTime date,@finishDay date,@finishTime date)
as begin
	if exists (select NameNurse from NURSE where NameNurse=@name)
		print 'The name ' @name+ ' has been added'
		return
	else
		begin
			insert into NURSE
			values (@name)
			print 'The customer ' +@name+' has been created'
		end

end
-- exec NEW_ON_CALL 'Carla Espinosa', 1, 3, '14/03/2024', '11:00', '14/03/2024', '19:00'
--------------------------------------------------------------
--create database VIDEO_GAMES
create or alter procedure PLAYERS_RATING