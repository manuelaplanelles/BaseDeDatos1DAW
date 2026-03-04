create database MEDITECH

--56.
create or alter procedure PHYSICIAN_TRAINED_IN
as
begin
declare @list varchar(max)=''
select @list=@list+'PHYSICIAN: '+NamePhysician+char(10)+replicate('*', 30)+char(10)
from PHYSICIAN,TRAINED_IN, TREATMENT
where PHYSICIAN.PhysicianID=TRAINED_IN.PhysicianID
	and TRAINED_IN.CodeTreatment=TREATMENT.CodeTreatment
group by NamePhysician
order by NamePhysician

print @list
end
--exc PHYSICIAN_TRAINED_IN