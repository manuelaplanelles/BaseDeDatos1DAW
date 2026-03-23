create database ARMED_CONFLICTS

create or alter procedure LIST_GROUPS (@casualties int)
as begin
	declare @nameGroup varchar(30), @groupID char(5)
	declare @list varchar(max)=''
	declare @totalShips int, @totalThanks int, @totalPlanet int

	declare cursor_conflict cursor
	
	for select NameGroup, GroupID, Casualties
		from ARMED_GROUP
		where Casualties > @casualties
	
	open cursor_conflict
	fetch next from cursor_conflict into @nameGroup, @groupID, @casualties

	while @@FETCH_STATUS=0
	begin
		print replicate ('*',50)
		print 'GROUP: '+cast(@nameGroup as char(25))+'CASUALTIES: '+cast(@casualties as char(10))
		print replicate('*',50)
		print space(5)+'Division'+space(5)+'Ships'+space(5)+'Tanks'+space(5)+'Planes'
		print space(5)+replicate('-',45)
		select @list=@list+
			space(10)+cast(NumDivision as char(10))+
			cast(N_ships as char(10))+
			cast(N_tanks as char(10))+
			cast(N_planes as char(10))+char(10)
		from DIVISION
		where GroupID=@groupID
		group by NumDivision, N_ships, N_tanks, N_planes
		
		select @totalShips = sum(N_ships),
			   @totalThanks = sum(N_tanks),
			   @totalPlanet = sum(N_planes)
		from DIVISION
		where GroupID = @groupID

		print space(10) + 'Total: ' + cast(@totalShips as varchar) + 
			  space(5) + cast(@totalThanks as varchar) + 
			  space(5) + cast(@totalPlanet as varchar)				
		print ''
		
		print @list
		set @list = ''
		fetch next from cursor_conflict into @nameGroup, @groupID, @casualties
	end
	close cursor_conflict
	deallocate cursor_conflict

end
-- exec LIST_GROUPS 500000

--- COUNTRY_CONFLICTS. Create a procedure to display the conflicts that every country were involved in
create or alter procedure COUNTRY_CONFLICTS
as begin
	declare @nameCountry varchar(30), @countryID char(5)
	declare @list varchar(max)=''
	
	declare cursor_conflicts cursor
	for select NameCountry, CountryID
		from COUNTRY
	open cursor_conflicts
	fetch next from cursor_conflicts into @nameCountry, @countryID

	while @@FETCH_STATUS = 0
	begin
		print replicate ('-',50)
		print 'COUNTRY: ' + @nameCountry
		print 'CONFLICT'+space(30)+'DATE STARTED'
		print replicate('-', 50)
		select @list=@list+
			cast(NameConflict as char(40))+cast(DateStarted as char(10))+char(10)
		from CONFLICT, COUNTRY_CONFLICT
		where CONFLICT.ConflictID=COUNTRY_CONFLICT.ConflictID
			and CountryID = @countryID


		print @list
		set @list = ''
		fetch next from cursor_conflicts into @nameCountry, @countryID
	end
	close cursor_conflicts
	deallocate cursor_conflicts
end
-- exec COUNTRY_CONFLICTS

-- LIST_ORGANIZATIONS.Create a procedure to display the organizations and the conflicts they participated in for the organizations of the type given as parameter
create or alter procedure LIST_ORGANIZATIONS (@typeOrg varchar(16))
as begin
	declare @nameOrg varchar(60), @orgID char(7)
	declare @list varchar(max)=''
	declare cursor_organization cursor
	
	for select NameOrg, TypeOrg, OrgID
		from MEDIATION_ORG
		where TypeOrg=@typeOrg

	open cursor_organization
	fetch next from cursor_organization into @nameOrg,@typeOrg, @orgID
	while @@FETCH_STATUS=0
	begin
		print 'ORGANIZACION: ' + @nameOrg
		print 'TYPE: ' + @typeOrg
		print replicate ('-', 50)
		print 'Conflict'+space(20)+'Type Assistant'
		print replicate ('-', 50)
		
		select @list=@list+ 
			cast(NameConflict as char(30))+TypeAssistance+ char(10)
		from CONFLICT, MED_ORG_CONFLICT
		where CONFLICT.ConflictID=MED_ORG_CONFLICT.ConflictID
			and OrgID=@orgID
					
		print @list
		set @list = ''
		print replicate ('*', 50)
		fetch next from cursor_organization into @nameOrg,@typeOrg, @orgID
	end
	close cursor_organization
	deallocate cursor_organization
end 
-- exec LIST_ORGANIZATIONS 'Non-Governmental'