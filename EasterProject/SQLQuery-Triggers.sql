-- *** TRIGGERS ***

--- ASSIGN_CABIN. Create a trigger that automatically assigns a cabin to a child when their data is inserted. 
--Take into account the child's gender and ensure that the number of available spots for each cabin is not exceeded.



--====================================================================================================================================
-- UPDATE_EMPLOYEE_ACTIVITY. Create a trigger to randomly assign the employees who will be in charge when a new activity is inserted. 
--Take into account the following:
----- * An employee cannot be in charge of more than one activity that takes place during the same time slot and on the same days as 
------- another activity they have already been assigned to.
----- * Each activity must have two different employees in charge.
----- * A 50€ bonus will be added to each employee's salary for every activity they are assigned to.
----- * Check the coaches that do not have activities or are not in charge of a lot of activities and assigned them to be in charge 
------- of the cabins (update).



--====================================================================================================================================
--- UPDATE_BONUS_TUTOR. Write a trigger to update the salary with the tutor bonus every time that a tutor is assigned to the tutor 
--of a cabin (when the data of the cabin is updated). Keep in mind that a tutor can lead several cabins.
create or alter trigger UPDATE_BONUS_TUTOR
on CABIN
after UPDATE
as begin
	declare @tutor_new tinyint = (select IdEmployee from inserted)
    declare @tutor_old tinyint = (select IdEmployee from deleted)

    if @tutor_old is null or @tutor_old <> @tutor_new
    begin
        update EMPLOYEE
        set Bonus_tutor = Bonus_tutor + 40
        where Id = @tutor_new
    end
end


UPDATE CABIN SET IdEmployee = 3 WHERE Num = 9
UPDATE CABIN SET IdEmployee = 3 WHERE Num = 1
UPDATE CABIN SET IdEmployee = 9 WHERE Num = 3
UPDATE CABIN SET IdEmployee = 9 WHERE Num = 2
UPDATE CABIN SET IdEmployee = 10 WHERE Num = 4
UPDATE CABIN SET IdEmployee = 10 WHERE Num = 5
UPDATE CABIN SET IdEmployee = 4 WHERE Num = 6
UPDATE CABIN SET IdEmployee = 6 WHERE Num = 7
UPDATE CABIN SET IdEmployee = 8 WHERE Num = 8

SELECT * FROM EMPLOYEE
SELECT * FROM CABIN

--====================================================================================================================================
--- APPLY_ACTIVITY. Create a trigger that is fired each time a child signs up for an activity (insert). Take into account the 
--following:
----- * Check the number of available spots for the activity. If there are not enough spots, print a message and roll back the 
------- insertion. 'There are not places enough'
----- * Verify that the child is not already enrolled in another activity that takes place during the same time slot and on the same 
------- days. If this is the case, print a message and roll back the insertion. Name 'already applied for an activity at the same time and days'
----- * Ensure that the child is not already enrolled in 4 activities. If this limit has been reached, print a message and roll back 
------- the insertion. Name 'already applied for 4 activities'
create or alter trigger APPLY_ACTIVITY
on REGISTER
after INSERT
as begin
    declare @child tinyint = (select IdChild from inserted)
    declare @activity tinyint = (select IdActivity from inserted)

    declare @inscritos int = (select count(*) from REGISTER where IdActivity = @activity)
    declare @plazas int = (select Num_available_spot from ACTIVITY where Id = @activity)

    declare @days varchar(11) = (select Days_takes_place from ACTIVITY where Id = @activity)
    declare @slot varchar(11) = (select Time_slot from ACTIVITY where Id = @activity)

    declare @inscritos_child int = (select count(*) from REGISTER where IdChild = @child)
    declare @name varchar(30) = (select Name from CHILD where Id = @child)
    
    --Comprueba el número de plazas disponibles para la actividad
    if @inscritos > @plazas
        begin
            print 'There are not places enough'
            rollback transaction
            return
        end

    --Verifica que el niño no esté ya inscrito en otra actividad que tenga lugar durante el mismo horario
    if exists (select * from REGISTER, ACTIVITY
                 where REGISTER.IdActivity = ACTIVITY.Id 
                   and REGISTER.IdChild = @child 
                   and Days_takes_place = @days 
                   and Time_slot = @slot 
                   and ACTIVITY.Id <> @activity)
        begin
             print @name + ' already applied for an activity at the same time and days'
            rollback transaction
            return
        end

    --Asegúrate de que el niño no esté ya inscrito en 4 actividades
    if @inscritos_child >= 4
        begin
            print @name + ' already applied for 4 activities'
            rollback transaction
            return
        end
end

-- insert into REGISTER values (1, 9)
-- insert into REGISTER values (3, 5)