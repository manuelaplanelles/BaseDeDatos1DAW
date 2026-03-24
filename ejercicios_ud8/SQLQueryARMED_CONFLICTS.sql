---create database ARMED_CONFLICTS  -----------------------------------------------------------------------------------------------------------------------
--1. COUNTRY_CONFLICTS. Create a procedure to display the conflicts that every country were involved in.
create or alter procedure COUNTRY_CONFLICTS
as begin
	declare @country varchar (30), @countryID char(5)
	declare @list varchar(max)=''
	declare cursor_conflicts cursor
	for select NameCountry, CountryID
		from COUNTRY
	
	open cursor_conflicts
	fetch next from cursor_conflicts into @country, @countryID
	while @@FETCH_STATUS=0
	begin
		print replicate('-', 50)
		print 'COUNTRY: ' + @country
		print 'CONFRICT'+space(30)+'DATE STARTED'
		print replicate ('-',50)
		select @list=@list+
			cast(NameConflict as char(40))+cast(DateStarted as char)+char(10)
		from CONFLICT,COUNTRY_CONFLICT
		where CONFLICT.ConflictID=COUNTRY_CONFLICT.ConflictID
			and CountryID = @countryID

		print @list
		set @list=''
		print ''
		fetch next from cursor_conflicts into @country, @countryID
	end
	close cursor_conflicts
	deallocate cursor_conflicts
end
--exec COUNTRY_CONFLICTS

--2.LIST_CONFLICTS. Create a procedure to display the conflicts and the type of conflict they were. 
-- Sort the result-set by the date when the conflicts started.
create or alter procedure LIST_CONFLICTS
as begin
	declare @nameConflict varchar(30), @conflictID char(6), @date date
	declare @list varchar(max)=''
	
	declare cursor_typeconflicts cursor
	for select NameConflict, ConflictID, DateStarted
		from CONFLICT
	
	open cursor_typeconflicts
	fetch next from cursor_typeconflicts into @nameConflict, @conflictID, @date

	while @@FETCH_STATUS=0
	begin
		print 'CONFLICT'+space(30)+'DATE STARTED'
		print cast(@nameConflict as char(40))+cast(@date as char)
		print ''
		
		select @list=@list+Religion+CHAR(10)+space(12)
		from RELIGIOUS
		where ConflictID=@conflictID
			if @list<>''
				begin
					print char(10)+'Religion: '+@list
					set @list=''
				end
		
		select @list=@list+Region+CHAR(10)+space(12)
		from TERRITORIAL
		where ConflictID=@conflictID
			if @list <>''
				begin
					print char(10)+'Territorial: '+@list
					set @list=''
				end
		
		select @list=@list+Raw_Mat+CHAR(10)+space(12)
		from ECONOMIC
		where ConflictID=@conflictID
			if @list<>''
				begin
					print char(10)+'Economic: '+@list
					set @list = ''
				end

		select @list=@list+Etnic+CHAR(10)+space(12)
		from RACIAL
		where ConflictID=@conflictID
			if @list<>''
				begin
					print char(10)+'Racial: '+@list
					set @list=''
				end

		print replicate ('-',50)
		fetch next from cursor_typeconflicts into @nameConflict, @conflictID, @date
	end
	close cursor_typeconflicts
	deallocate cursor_typeconflicts


end
-- exec LIST_CONFLICTS

--3. LIST_ORGANIZATIONS. Create a procedure to display the organizations and the conflicts they participated in. 
-- If the total of casualties is higher than one million, ‘massive casualties’, if it is higher than one hundred thousand, 
-- ‘moderated casualties’, if it is lower than one hundred thousand ‘limited casualties’
create or alter procedure LIST_ORGANIZATIONS
as begin
	declare @nameOrg varchar(60), @orgID char(7)
	declare @list varchar(max)=''
	
	declare cursor_organizations cursor
	for select NameOrg, OrgID
		from MEDIATION_ORG

	open cursor_organizations
	fetch next from cursor_organizations into @nameOrg, @orgID

	while @@FETCH_STATUS=0
	begin
		print 'ORGANIZATION:'+@nameOrg
		print replicate ('-',50)
		select @list=@list + 
			'Conflict: ' + NameConflict +''+
			case
				when sum(N_Deaths)>1000000 then '(massive casualties)'
				when sum(N_Deaths)>100000 then '(moderated casualties)'
				else '(limited casualties)'
			end + char(10)+
			'Type Assistance: '+TypeAssistance +char(10)+char(10)
		from CONFLICT, COUNTRY_CONFLICT,MED_ORG_CONFLICT
		where CONFLICT.ConflictID=COUNTRY_CONFLICT.ConflictID
			and CONFLICT.ConflictID=MED_ORG_CONFLICT.ConflictID
			and OrgID=@orgID
		group by NameConflict, TypeAssistance

		print @list
		set @list=''
		print ''
		print replicate('*',50)
		fetch next from cursor_organizations into @nameOrg, @orgID
	end
	close cursor_organizations
	deallocate cursor_organizations

end
--exec LIST_ORGANIZATIONS

--4. COUNTRY_GROUPS Muestra todos los países y los grupos armados que participaron en sus conflictos. Para cada país muestra el nombre del grupo y sus bajas.
create or alter procedure COUNTRY_GROUPS
as begin
	declare @conuntry varchar(30), @countryID char(5)
	declare @list varchar(max)=''

	declare cursor_countrygroups cursor
	for select NameCountry, CountryID
		from COUNTRY
	open cursor_countrygroups
	fetch next from cursor_countrygroups into @conuntry, @countryID

	while @@FETCH_STATUS=0
	begin
		print 'COUNTRY: '+@conuntry
		print space(5)+'Group'+space(20)+'Casualties'
		print space(5)+replicate ('=',50)
		
		select @list=@list+
			space(5)+cast(NameGroup as char(30))+cast(sum(Casualties) as char)+char(10)
		from ARMED_GROUP, ARMEDGROUP_CONFLICT,CONFLICT, COUNTRY_CONFLICT
		where ARMED_GROUP.GroupID=ARMEDGROUP_CONFLICT.GroupID
			and ARMEDGROUP_CONFLICT.ConflictID=CONFLICT.ConflictID
			and CONFLICT.ConflictID=COUNTRY_CONFLICT.ConflictID
			and CountryID=@countryID
		group by NameGroup, Casualties

		print @list
		set @list=''
		fetch next from cursor_countrygroups into @conuntry, @countryID
	end
	close cursor_countrygroups
	deallocate cursor_countrygroups
end
-- exec COUNTRY_GROUPS

--5.CONFLICT_DETAILS Muestra los conflictos y las organizaciones mediadoras que participaron, con el tipo de asistencia y número de personas ayudadas. Parámetro: 
-- tipo de organización.
create or alter procedure CONFLICT_DETAILS (@typeOrg varchar(16))
as begin
	declare @nameConflict varchar(30), @conflictID char(6), @date date
	declare @list varchar(max)=''

	declare cursor_details cursor
	for select NameConflict, CONFLICT.ConflictID, DateStarted
		from CONFLICT, MED_ORG_CONFLICT,MEDIATION_ORG
		where CONFLICT.ConflictID=MED_ORG_CONFLICT.ConflictID
			and MED_ORG_CONFLICT.OrgID=MEDIATION_ORG.OrgID
			and TypeOrg=@typeOrg

	open cursor_details
	fetch next from cursor_details into @nameConflict, @conflictID, @date

	while @@FETCH_STATUS=0
	begin
		print 'CONFLICT: '+@nameConflict
		print space(5) + 'DATE STARTED: '+cast(@date as char)
		print space(5)+replicate('=',70)
		print space(5)+'Organization'+space(50)+'Type'+space(10)+'NumPeople'
		
		select @list=@list+space(5)+
			cast(NameOrg as char(60))+cast(TypeOrg as char(15))+cast(sum(NumPeople)as char)+char(10)
		from MED_ORG_CONFLICT, MEDIATION_ORG
		where MED_ORG_CONFLICT.OrgID=MEDIATION_ORG.OrgID
			and ConflictID=@conflictID
		group by NameOrg, TypeOrg

		print @list
		set @list=''
		print ''
		fetch next from cursor_details into @nameConflict, @conflictID, @date
	end
	close cursor_details
	deallocate cursor_details

end 

-- exec CONFLICT_DETAILS 'International'

--select TypeOrg from MEDIATION_ORG

