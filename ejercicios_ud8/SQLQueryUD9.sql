-- create database ELITE_EAGLES -------------------------------------------------------------
-- 1.
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
insert into REGISTERED
values(1, 'Tennis',1)
select*from DEFAULTER
-------------------------------------------------------------
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
where
-- 2.
