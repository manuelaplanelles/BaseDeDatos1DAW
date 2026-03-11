create database DISASTER_SUPPORT
--4.NEW_FUNDING. Create a procedure to insert a new record into the FUNDING table. The parameters received by the procedure are: 
-- donor name, operation name, and donated amount. The new record must store the current date
create or alter procedure NEW_FUNDING (@donorname varchar(80), @opname varchar(80), @amount money)
as begin
	declare @donorid int
	declare @opid int

	if @donorname not in (select NameDonor from DONOR)
		begin
			print 'The door does not exist'
			return
		end
	if @opname not in (select NameOperation from RESCUE_OPERATION)
		begin
			print 'The operatio not exist'
			return
		end

		set @donorid= (select DonorId From DONOR where NameDonor=@donorname)
		set @opid= (select OperationID from RESCUE_OPERATION where NameOperation=@opname)

	if exists (select 1 from FUNDING where DonorID = @donorid and OperationID = @opid)
		begin
			print 'this donor has already funded this operation'
			return
		end
		insert into FUNDING (OperationID, DonorID, DateDonation,Amount)
		values (@opid, @donorid, GETDATE(), @amount)

		if @@ERROR =0
			print 'funding record added successfully'
		else

		print 'Insertion failed'
end
--exec NEW_FUNDING 'John Smith', 'Catalonia flood Relief', 200
--exec NEW_FUNDING 'Pepe Ruiz', 'Catalonia flood Relief', 5000

--3.TEAMS_MEMBERS. Create a procedure to display the list of team members whose team type is provided as a parameter. 
-- For each member, display the total number of years they have been a member, calculated from the current year. 
-- Also display the total number of operations in which each team has participated.
S_MEMBERS 'Rescue'