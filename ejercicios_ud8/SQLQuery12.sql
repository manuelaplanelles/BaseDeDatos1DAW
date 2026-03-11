--mocK exam--MEDITECH
--1.STAYS_MONT_YEAR. Create a procedure to display the patients who were hospitalized the month and year given as parameter. PCP: médico de cabecera 
create or alter procedure STAYS_MONTH_YEAR @month tinyint, @year char(4) 
as begin 
	declare @list as varchar(max)='' 
	declare @total as money=0
	
	select @list=@list+char(10)+'PATIENT: '+
		cast(NamePatient as char(30))+ 
		'PCP: '+PHYSICIAN.NamePhysician+char(10)+ 
		'START: '+cast(start as char(15))+'FINISH: '+
		cast(finish as char(15))+ 'TOTAL DAYS: '+
		cast(datediff(day, start, finish) as varchar)+char(10)+ 
		replicate('-',60)+char(10)+ 'PHYSICIAN TREATMENT COST'+char(10)+ 
		replicate('-',60)+char(10)+ 
		STRING_AGG(concat(cast(B.NamePhysician as char(20)), 
		cast(TREATMENT.NameTreatment as char(30)), 
		cast(cost as char(10))), char(10))+char(10)+ char(10)+'TOTAL COST TREATMENTS: '+ 
		cast(sum(cost) as varchar)+char(10)+ 
		replicate('=',60)+char(10), @total=@total+
		sum(cost) 
		
	from PATIENT, HOSPITALIZE, TAKE_TREATMENT, PHYSICIAN, PHYSICIAN as B, TREATMENT 
	where PATIENT.PatientSSN=HOSPITALIZE.PatientSSN 
		and TAKE_TREATMENT.StayID=HOSPITALIZE.StayID 
		and PHYSICIAN.PhysicianID=PATIENT.PCP 
		and month(start)=@month 
		and year(start)=@year 
		and B.PhysicianID=TAKE_TREATMENT.PhysicianID 
		and TAKE_TREATMENT.CodeTreatment=TREATMENT.CodeTreatment 
	group by NamePatient, PHYSICIAN.NamePhysician, start, finish 
	order by start 
	
	print @list 
	print 'TOTAL MONTH: '+cast(@total as varchar)
end
--EXEC STAYS_MONTH_YEAR 6, 2008

------------------------------------------------------------------------------
--2. PATIENT_APPOINTMENTS. Create a procedure to display the appointments of 
-- the patients given as parameter. Display all the medicines as well prescribed 
-- in every appointment.
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
--3. DEPARTMENT_TREATMENTS. Create a procedure to display the departments, head 
-- of the department, the total physicians are affiliated to the department and 
-- the total cost of all the procedures that the physicians of the department are 
-- able to proceed.
create or alter procedure DEPARTMENT_TREATMENTS 
as begin 
	declare @cont as int=1 
	declare @total as int 
	declare @list as varchar(max)='' 
	declare @totalcost as money=0 
	declare @totaltreat as money=0

	select @total=max(departmentid) from DEPARTMENT
	print 'DEPARTMENT'+space(10)+'HEAD'+
		space(10)+'N_PHYSICIANS'+ 
		space(3)+'T_COST_TREATMENTS' 
	print replicate('-',66);
	while @cont<=@total 
		begin 
			select @list=cast(NameDepart as char(20))+ 
				cast(NamePhysician as char(20))+ 
				cast(count(AFFILIATED_DEP.physicianid) as char(13)) 
			from DEPARTMENT, PHYSICIAN, AFFILIATED_DEP 
			where PHYSICIAN.PhysicianID=DEPARTMENT.Head 
				and DEPARTMENT.departmentId=AFFILIATED_DEP.DepartmentID 
				and PrimaryAffiliation=1 
				and DEPARTMENT.DepartmentID=@cont 
			group by NameDepart, NamePhysician
	
			select @totalcost=sum(cost) 
			from TRAINED_IN, TREATMENT, AFFILIATED_DEP 
			where AFFILIATED_DEP.DepartmentID=@cont 
				and PrimaryAffiliation=1 
				and AFFILIATED_DEP.PhysicianID=TRAINED_IN.PhysicianID 
				and TRAINED_IN.CodeTreatment=TREATMENT.CodeTreatment
			if @totalcost is NULL 
				set @totalcost=0 
				set @list=@list+cast(@totalcost as char(10))+' €' 
				set @totaltreat=@totaltreat+@totalcost 
			
				print @list set @cont=@cont+1 
		end 
		
		print char(10)+'TOTAL: '+cast(@totaltreat as varchar)+' €' 
end 
--EXEC DEPARTMENT_TREATMENTS

------------------------------------------------------------------------------
--4. NEW_ON_CALL. Create a procedure to insert a new shift in the table ON_CALL, 
-- the parameters are: name of the nurse, bloockfloor, blockcode, start day, 
-- start time, finish day and finish time.
create or alter procedure NEW_ON_CALL 
	@name as varchar(30), 
	@floor as int, 
	@code as int,
	@daystart as char(10), 
	@hourstart as char(5), 
	@dayfinish as char(10), 
	@hourfinish as char(5) 
as begin 
	declare @nurseid as int 
	declare @start as char(16)=@daystart+' '+@hourstart 
	declare @finish as char(16)=@dayfinish+' '+@hourfinish 
	
	if @name in (select NameNurse from NURSE) 
		begin 
			select @nurseid=NurseID 
			from nurse 
			where NameNurse like '%'+@name+'%' 
			
			insert into ON_CALL 
			values 
			(@nurseid, @floor, @code, cast(@start as datetime), cast(@finish as datetime)) 
		end 
	else print 'The name of the nurse is not correct'
end
-- exec NEW_ON_CALL 'Carla Espinosa', 1, 3, '14/03/2024', '11:00', '14/03/2024', '19:00'
--------------------------------------------------------------
--create database VIDEO_GAMES
create or alter procedure PLAYERS_RATING

--- create database EMERGENCY_RESCUE ------------------------------------------------------------------------------
--1. DONORS_BY_OPERATION. Crea un procedimiento que reciba el nombre de una operación (@operation) y muestre los 
-- donantes que financiaron esa operación, con el tipo de donante y el importe donado. Verifica que la operación 
-- existe. Muestra el total recaudado al final.