create database UrbanArtRestoration_trig
-- 1
create or alter trigger TRIG_SALARY_RESTORER
on RESTORATION_TASK
after insert
as begin
    declare @idtask char(7)=(select IDTask from inserted)
    declare @idrestorer char(5)=(select IDRestorer from inserted)
    declare @projectid int=(select ArtworkID from inserted)
    declare @cost money=(select Cost from inserted)

    declare @idproject int=(select ProjectID from ARTWORK where ArtworkID=@projectid)

    if @idrestorer in (select IDRestorer from SALARY where IDRestorer=@idrestorer and ProjectID=@idproject)
        begin
            update SALARY
            set Salary=Salary+@cost
            where IDRestorer=@idrestorer and ProjectID=@idproject
        end
    else
        begin
            insert into SALARY
            values (@idrestorer, @idproject, @cost)
        end

    update PROJECT
    set Expenses=Expenses+@cost
    where ProjectID=@idproject
end

-- 2
create or alter trigger TRIG_DONATION
on DONATION
after insert
as
begin
    declare @projectid int=(select ProjectID from inserted)
    declare @amount money=(select Amount from inserted)

    update PROJECT
    set TotalBudget=TotalBudget+@amount
    where ProjectID=@projectid
end

-- 3
-- 4
-- 5
create or alter trigger TRIG_UPDATE_POINTS
on PROJECT
after update
as
begin
    declare @projectid int=(select ProjectID from inserted)
    declare @enddatereal date=(select EndDateReal from inserted)
    declare @enddate date=(select EndDate from inserted)
    declare @expenses money=(select Expenses from inserted)
    declare @totalbudget money=(select TotalBudget from inserted)

    declare @donorID int

    if @enddate is not null
        begin
            declare cursor_donor cursor
             for select DonorID 
                from DONATION 
                where ProjectID=@projectid
            open cursor_donor
            fetch next from cursor_donor into @donorID

            while @@FETCH_STATUS = 0
                begin
                    if @enddatereal<= @enddate
                        begin
                            update DONOR
                            set Points=Points+10
                            where DonorID = @donorID
                        end
                    else
                        begin
                            update DONOR
                            set Points=Points+3
                            where DonorID = @donorID
                        end
                    if @expenses<= @totalbudget
                        begin
                            update DONOR
                            set Points=Points+4
                            where DonorID = @donorID
                        end
                    fetch next from cursor_donor into @donorID
                end
                close cursor_donor
                deallocate cursor_donor
        end

end