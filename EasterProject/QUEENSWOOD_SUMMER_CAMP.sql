create database QUEENSWOOD_SUMMER_CAMP
use QUEENSWOOD_SUMMER_CAMP

create table PARENT(
Id tinyint identity primary key
, Name varchar (20) not null
, Surname varchar (20) not null
, N_Phone char(9) not null
, Gender char(1) not null
, check (N_Phone like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
, check (Gender in ('M','F'))
)
create table EMPLOYEE(
Id tinyint identity primary key
, Name varchar(30) not null
, Email varchar(100) not null unique
, N_phone char (9) not null
, Position varchar(7) not null
, Salary smallmoney not null
, Bonus_activity smallmoney not null default 0
, Bonus_tutor smallmoney not null default 0
, check (Email like ('_%@_%._%'))
, check (N_phone like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
, check (Position in ('Manager','Coach','Cook'))
, check (Salary > 0)
)
create table CABIN(
Num tinyint identity primary key
, Name varchar(10) not null
, Type char(1) not null
, Num_spot tinyint not null
, IdEmployee tinyint
, foreign key (IdEmployee) references EMPLOYEE (Id)
, check (Type in ('F','M'))
, check (Num_spot >= 3 and Num_spot <= 6)
)
create table CHILD(
Id tinyint identity primary key
, Name varchar (30) not null
, Gender char(1) not null
, D_birth date not null
, IdParent1 tinyint not null
, IdParent2 tinyint 
, Num tinyint
, foreign key (IdParent1) references PARENT (Id)
, foreign key (IdParent2) references PARENT (Id)
, foreign key (Num) references CABIN (Num)
, check (Gender in ('M','F'))
)
create table MEDICAL_ISSUE(
Number tinyint not null 
, IdChild tinyint not null
, Issue_description varchar(50) not null
, Medication varchar(30) not null
, Special_needs varchar(40) not null
, primary key (Number,IdChild)
, foreign key (IdChild) references CHILD (Id)
)
create table ACTIVITY(
Id tinyint identity primary key
, Name_activity varchar(25) not null
, Description varchar(60) not null
, Days_takes_place varchar(11) not null
, Time_slot varchar(11) not null
, Type_activity varchar(12) not null
, Num_available_spot tinyint not null
, IdEmployee1 tinyint
, IdEmployee2 tinyint
, foreign key (IdEmployee1) references EMPLOYEE (Id)
, foreign key (IdEmployee2) references EMPLOYEE (Id)
, check (Days_takes_place in ('Mon-Wed-Fri','Tue-Thu-Sat'))
, check (Time_slot in ('10:00-12:00','16:00-18:00','19:00-21:00'))
, check (Type_activity in ('Physical','Recreational'))
, check (Num_available_spot >= 10 and Num_available_spot <= 25)
)
create table REGISTER(
IdChild tinyint not null
, IdActivity tinyint not null
, primary key (IdChild, IdActivity)
, foreign key (IdChild) references CHILD (Id)
, foreign key (IdActivity) references ACTIVITY (Id)
)

-- EMPLOYEE
insert into EMPLOYEE (Name, Email, N_phone, Position, Salary) values
('Carlos Martínez', 'carlos@queenswood.com', '612345678', 'Manager', 2200)
insert into EMPLOYEE (Name, Email, N_phone, Position, Salary) values
('Emma Johnson', 'emma@queenswood.com', '611223344', 'Coach', 1500)
insert into EMPLOYEE (Name, Email, N_phone, Position, Salary) values
('Lucía Gómez', 'lucia@queenswood.com', '622334455', 'Coach', 1500)
insert into EMPLOYEE (Name, Email, N_phone, Position, Salary) values
('Daniel Smith', 'daniel@queenswood.com', '633445566', 'Coach', 1500)
insert into EMPLOYEE (Name, Email, N_phone, Position, Salary) values
('María López', 'maria@queenswood.com', '644556677', 'Coach', 1500)
insert into EMPLOYEE (Name, Email, N_phone, Position, Salary) values
('James Brown', 'james@queenswood.com', '655667788', 'Coach', 1500)
insert into EMPLOYEE (Name, Email, N_phone, Position, Salary) values
('Laura Torres', 'laura@queenswood.com', '666778899', 'Coach', 1500)
insert into EMPLOYEE (Name, Email, N_phone, Position, Salary) values
('Michael Taylor', 'michael@queenswood.com', '677889900', 'Coach', 1500)
insert into EMPLOYEE (Name, Email, N_phone, Position, Salary) values
('Carmen Ruiz', 'carmen@queenswood.com', '688990011', 'Coach', 1500)
insert into EMPLOYEE (Name, Email, N_phone, Position, Salary) values
('David Wilson', 'david@queenswood.com', '699001122', 'Coach', 1500)
insert into EMPLOYEE (Name, Email, N_phone, Position, Salary) values
('Ana Herrera', 'ana@queenswood.com', '600112233', 'Cook', 1600)

-- PARENT
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Laura', 'García', '611111111', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Michael', 'Smith', '611111112', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Ana', 'López', '611111113', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('David', 'Johnson', '611111114', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Marta', 'Sánchez', '611111115', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('James', 'Brown', '611111116', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Daniel', 'Martínez', '611111117', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Raquel', 'Flores', '611111118', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Andrew', 'Moore', '611111119', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Patricia', 'Romero', '611111120', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('John', 'Miller', '611111121', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Robert', 'Davis', '611111122', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Sofía', 'Castro', '611111123', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Clara', 'Jiménez', '611111124', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Thomas', 'Anderson', '611111125', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Charles', 'Jackson', '611111126', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Cristina', 'León', '611111127', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Irene', 'Ferrer', '611111128', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Kevin', 'Harris', '611111129', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Verónica', 'Herrera', '611111130', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Brian', 'Martin', '611111131', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Noelia', 'Cabrera', '611111132', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('George', 'Thompson', '611111133', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Natalia', 'Rubio', '611111134', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Steven', 'White', '611111135', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('William', 'Wilson', '611111136', 'M')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Lucía', 'Molina', '611111137', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Beatriz', 'Morales', '611111138', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Eva', 'Gil', '611111139', 'F')
insert into PARENT (Name, Surname, N_Phone, Gender) values
('Mark', 'Taylor', '611111140', 'M')

-- CABIN
insert into CABIN (Name, Type, Num_spot) values
('Willow', 'F', 3)
insert into CABIN (Name, Type, Num_spot) values
('Cherry', 'F', 3)
insert into CABIN (Name, Type, Num_spot) values
('Birch', 'F', 3)
insert into CABIN (Name, Type, Num_spot) values
('Elm', 'F', 6)
insert into CABIN (Name, Type, Num_spot) values
('Linden', 'F', 5)
insert into CABIN (Name, Type, Num_spot) values
('Oak', 'M', 4)
insert into CABIN (Name, Type, Num_spot) values
('Pine', 'M', 4)
insert into CABIN (Name, Type, Num_spot) values
('Cedar', 'M', 6)
insert into CABIN (Name, Type, Num_spot) values
('Maple', 'M', 6)

-- CHILD
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Emily Smith', 'F', '2010-05-14', 1, 2)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Sophia López', 'F', '2011-09-22', 3, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Olivia Johnson', 'F', '2012-01-30', 4, 5)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Amelia Davis', 'F', '2009-12-19', 12, 13)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Charlotte Wilson', 'F', '2010-04-27', 26, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Evelyn Anderson', 'F', '2012-08-15', 14, 15)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Ava Brown', 'F', '2009-11-03', 6, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Isabella Miller', 'F', '2010-07-17', 10, 11)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Mia Molina', 'F', '2011-03-10', 27, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Harper Morales', 'F', '2011-06-09', 28, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Luna Martínez', 'F', '2009-10-03', 7, 8)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Ella Moore', 'F', '2010-01-25', 9, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Scarlett Taylor', 'F', '2011-11-12', 29, 30)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Grace Rubio', 'F', '2012-02-04', 24, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Chloe Jackson', 'F', '2009-06-18', 16, 17)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Camila White', 'F', '2010-10-29', 25, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Layla Harris', 'F', '2011-07-08', 18, 19)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Riley Herrera', 'F', '2012-05-02', 20, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Lily Martin', 'F', '2010-03-15', 21, 22)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Zoe Thompson', 'F', '2009-08-20', 23, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Liam Smith', 'M', '2012-06-11', 1, 2)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Noah López', 'M', '2010-09-01', 3, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Elijah Johnson', 'M', '2011-02-20', 4, 5)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('James Brown', 'M', '2009-12-13', 6, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Benjamin Miller', 'M', '2010-05-05', 10, 11)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Lucas Molina', 'M', '2011-08-25', 27, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Henry Davis', 'M', '2012-01-16', 12, 13)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Alexander Wilson', 'M', '2009-03-11', 26, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Sebastian Anderson', 'M', '2010-07-08', 14, 15)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Jackson Morales', 'M', '2011-04-19', 28, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Mateo Martínez', 'M', '2012-10-26', 7, 8)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Levi Moore', 'M', '2009-05-22', 9, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Daniel Taylor', 'M', '2010-09-09', 29, 30)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Logan Rubio', 'M', '2011-01-04', 24, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Jacob Jackson', 'M', '2012-12-08', 16, 17)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Ethan White', 'M', '2009-06-30', 25, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('David Harris', 'M', '2010-02-14', 18, 19)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Joseph Herrera', 'M', '2011-11-28', 20, NULL)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Samuel Martin', 'M', '2012-03-06', 21, 22)
insert into CHILD (Name, Gender, D_birth, IdParent1, IdParent2) values
('Owen Thompson', 'M', '2009-07-17', 23, NULL)

-- MEDICAL_ISSUE
insert into MEDICAL_ISSUE (Number, IdChild, Issue_description, Medication, Special_needs) values
(1, 7, 'Seasonal allergies with frequent sneezing', 'Loratadine', 'Avoid grass exposure')
insert into MEDICAL_ISSUE (Number, IdChild, Issue_description, Medication, Special_needs) values
(2, 7, 'Mild asthma episodes during physical activity', 'Salbutamol inhaler', 'Monitor during sports')
insert into MEDICAL_ISSUE (Number, IdChild, Issue_description, Medication, Special_needs) values
(3, 7, 'Skin rash due to detergent allergy', 'Hydrocortisone cream', 'Use hypoallergenic detergents')
insert into MEDICAL_ISSUE (Number, IdChild, Issue_description, Medication, Special_needs) values
(1, 6, 'Lactose intolerance diagnosed at age 9', 'None', 'Lactose-free meals required')
insert into MEDICAL_ISSUE (Number, IdChild, Issue_description, Medication, Special_needs) values
(2, 6, 'Mild anxiety in unfamiliar environments', 'Rescue medication if needed', 'Daily emotional check-in')
insert into MEDICAL_ISSUE (Number, IdChild, Issue_description, Medication, Special_needs) values
(1, 18, 'Sensitive digestive system', 'Probiotics', 'Avoid spicy food')

-- ACTIVITY
insert into ACTIVITY (Name_activity, Description, Days_takes_place, Time_slot, Type_activity, Num_available_spot) values
('Yoga for Teens', 'Morning yoga session to improve flexibility', 'Mon-Wed-Fri', '10:00-12:00', 'Physical', 15)
insert into ACTIVITY (Name_activity, Description, Days_takes_place, Time_slot, Type_activity, Num_available_spot) values
('Team Sports', 'Group games like football and basketball', 'Tue-Thu-Sat', '16:00-18:00', 'Physical', 25)
insert into ACTIVITY (Name_activity, Description, Days_takes_place, Time_slot, Type_activity, Num_available_spot) values
('Dance Class', 'Hip hop and freestyle dance session', 'Mon-Wed-Fri', '16:00-18:00', 'Physical', 15)
insert into ACTIVITY (Name_activity, Description, Days_takes_place, Time_slot, Type_activity, Num_available_spot) values
('Evening Hike', 'Nature walks around the campsite area', 'Tue-Thu-Sat', '19:00-21:00', 'Physical', 12)
insert into ACTIVITY (Name_activity, Description, Days_takes_place, Time_slot, Type_activity, Num_available_spot) values
('Drama Workshop', 'Creative theatre games and roleplay', 'Mon-Wed-Fri', '10:00-12:00', 'Recreational', 20)
insert into ACTIVITY (Name_activity, Description, Days_takes_place, Time_slot, Type_activity, Num_available_spot) values
('Photography Basics', 'Learn to take great photos with smartphones', 'Tue-Thu-Sat', '10:00-12:00', 'Recreational', 10)
insert into ACTIVITY (Name_activity, Description, Days_takes_place, Time_slot, Type_activity, Num_available_spot) values
('Board Game Club', 'Strategy and fun with classic board games', 'Tue-Thu-Sat', '16:00-18:00', 'Recreational', 15)
insert into ACTIVITY (Name_activity, Description, Days_takes_place, Time_slot, Type_activity, Num_available_spot) values
('Movie Night', 'Watch and discuss family-friendly films', 'Tue-Thu-Sat', '19:00-21:00', 'Recreational', 15)
insert into ACTIVITY (Name_activity, Description, Days_takes_place, Time_slot, Type_activity, Num_available_spot) values
('Campfire Stories', 'Storytelling and games around the fire', 'Mon-Wed-Fri', '19:00-21:00', 'Recreational', 15)

-- REGISTER
insert into REGISTER (IdChild, IdActivity) values (1, 1)
insert into REGISTER (IdChild, IdActivity) values (1, 6)
insert into REGISTER (IdChild, IdActivity) values (1, 2)
insert into REGISTER (IdChild, IdActivity) values (1, 3)
insert into REGISTER (IdChild, IdActivity) values (2, 1)
insert into REGISTER (IdChild, IdActivity) values (2, 3)
insert into REGISTER (IdChild, IdActivity) values (2, 8)
insert into REGISTER (IdChild, IdActivity) values (2, 9)
insert into REGISTER (IdChild, IdActivity) values (3, 1)
insert into REGISTER (IdChild, IdActivity) values (3, 7)
insert into REGISTER (IdChild, IdActivity) values (3, 8)
insert into REGISTER (IdChild, IdActivity) values (4, 5)
insert into REGISTER (IdChild, IdActivity) values (4, 6)
insert into REGISTER (IdChild, IdActivity) values (4, 7)
insert into REGISTER (IdChild, IdActivity) values (5, 7)
insert into REGISTER (IdChild, IdActivity) values (5, 3)
insert into REGISTER (IdChild, IdActivity) values (5, 8)
insert into REGISTER (IdChild, IdActivity) values (6, 5)
insert into REGISTER (IdChild, IdActivity) values (6, 6)
insert into REGISTER (IdChild, IdActivity) values (6, 9)
insert into REGISTER (IdChild, IdActivity) values (7, 1)
insert into REGISTER (IdChild, IdActivity) values (7, 6)
insert into REGISTER (IdChild, IdActivity) values (7, 2)
insert into REGISTER (IdChild, IdActivity) values (8, 1)
insert into REGISTER (IdChild, IdActivity) values (8, 6)
insert into REGISTER (IdChild, IdActivity) values (8, 9)
insert into REGISTER (IdChild, IdActivity) values (9, 3)
insert into REGISTER (IdChild, IdActivity) values (9, 8)
insert into REGISTER (IdChild, IdActivity) values (9, 9)
insert into REGISTER (IdChild, IdActivity) values (10, 6)
insert into REGISTER (IdChild, IdActivity) values (10, 3)
insert into REGISTER (IdChild, IdActivity) values (10, 9)
insert into REGISTER (IdChild, IdActivity) values (11, 5)
insert into REGISTER (IdChild, IdActivity) values (11, 2)
insert into REGISTER (IdChild, IdActivity) values (11, 4)
insert into REGISTER (IdChild, IdActivity) values (11, 9)
insert into REGISTER (IdChild, IdActivity) values (12, 6)
insert into REGISTER (IdChild, IdActivity) values (12, 2)
insert into REGISTER (IdChild, IdActivity) values (12, 3)
insert into REGISTER (IdChild, IdActivity) values (12, 8)
insert into REGISTER (IdChild, IdActivity) values (13, 6)
insert into REGISTER (IdChild, IdActivity) values (13, 7)
insert into REGISTER (IdChild, IdActivity) values (13, 4)
insert into REGISTER (IdChild, IdActivity) values (14, 5)
insert into REGISTER (IdChild, IdActivity) values (14, 7)
insert into REGISTER (IdChild, IdActivity) values (14, 4)
insert into REGISTER (IdChild, IdActivity) values (15, 5)
insert into REGISTER (IdChild, IdActivity) values (15, 2)
insert into REGISTER (IdChild, IdActivity) values (15, 9)
insert into REGISTER (IdChild, IdActivity) values (16, 7)
insert into REGISTER (IdChild, IdActivity) values (16, 8)
insert into REGISTER (IdChild, IdActivity) values (17, 5)
insert into REGISTER (IdChild, IdActivity) values (17, 4)
insert into REGISTER (IdChild, IdActivity) values (17, 9)
insert into REGISTER (IdChild, IdActivity) values (18, 5)
insert into REGISTER (IdChild, IdActivity) values (18, 4)
insert into REGISTER (IdChild, IdActivity) values (18, 9)
insert into REGISTER (IdChild, IdActivity) values (19, 5)
insert into REGISTER (IdChild, IdActivity) values (19, 2)
insert into REGISTER (IdChild, IdActivity) values (19, 8)
insert into REGISTER (IdChild, IdActivity) values (19, 9)
insert into REGISTER (IdChild, IdActivity) values (20, 5)
insert into REGISTER (IdChild, IdActivity) values (20, 2)
insert into REGISTER (IdChild, IdActivity) values (20, 8)
insert into REGISTER (IdChild, IdActivity) values (20, 9)
insert into REGISTER (IdChild, IdActivity) values (21, 5)
insert into REGISTER (IdChild, IdActivity) values (21, 2)
insert into REGISTER (IdChild, IdActivity) values (21, 8)
insert into REGISTER (IdChild, IdActivity) values (22, 5)
insert into REGISTER (IdChild, IdActivity) values (22, 2)
insert into REGISTER (IdChild, IdActivity) values (22, 8)
insert into REGISTER (IdChild, IdActivity) values (23, 6)
insert into REGISTER (IdChild, IdActivity) values (23, 2)
insert into REGISTER (IdChild, IdActivity) values (23, 8)
insert into REGISTER (IdChild, IdActivity) values (24, 1)
insert into REGISTER (IdChild, IdActivity) values (24, 6)
insert into REGISTER (IdChild, IdActivity) values (24, 2)
insert into REGISTER (IdChild, IdActivity) values (25, 5)
insert into REGISTER (IdChild, IdActivity) values (25, 7)
insert into REGISTER (IdChild, IdActivity) values (25, 4)
insert into REGISTER (IdChild, IdActivity) values (26, 5)
insert into REGISTER (IdChild, IdActivity) values (26, 2)
insert into REGISTER (IdChild, IdActivity) values (26, 3)
insert into REGISTER (IdChild, IdActivity) values (27, 7)
insert into REGISTER (IdChild, IdActivity) values (27, 3)
insert into REGISTER (IdChild, IdActivity) values (27, 4)
insert into REGISTER (IdChild, IdActivity) values (28, 5)
insert into REGISTER (IdChild, IdActivity) values (28, 2)
insert into REGISTER (IdChild, IdActivity) values (28, 3)
insert into REGISTER (IdChild, IdActivity) values (29, 1)
insert into REGISTER (IdChild, IdActivity) values (29, 7)
insert into REGISTER (IdChild, IdActivity) values (29, 3)
insert into REGISTER (IdChild, IdActivity) values (30, 5)
insert into REGISTER (IdChild, IdActivity) values (30, 2)
insert into REGISTER (IdChild, IdActivity) values (30, 4)
insert into REGISTER (IdChild, IdActivity) values (31, 1)
insert into REGISTER (IdChild, IdActivity) values (31, 7)
insert into REGISTER (IdChild, IdActivity) values (31, 4)
insert into REGISTER (IdChild, IdActivity) values (32, 1)
insert into REGISTER (IdChild, IdActivity) values (32, 2)
insert into REGISTER (IdChild, IdActivity) values (32, 4)
insert into REGISTER (IdChild, IdActivity) values (32, 9)
insert into REGISTER (IdChild, IdActivity) values (33, 1)
insert into REGISTER (IdChild, IdActivity) values (33, 4)
insert into REGISTER (IdChild, IdActivity) values (34, 5)
insert into REGISTER (IdChild, IdActivity) values (34, 2)
insert into REGISTER (IdChild, IdActivity) values (34, 4)
insert into REGISTER (IdChild, IdActivity) values (35, 1)
insert into REGISTER (IdChild, IdActivity) values (35, 2)
insert into REGISTER (IdChild, IdActivity) values (35, 3)
insert into REGISTER (IdChild, IdActivity) values (35, 9)
insert into REGISTER (IdChild, IdActivity) values (36, 5)
insert into REGISTER (IdChild, IdActivity) values (36, 7)
insert into REGISTER (IdChild, IdActivity) values (36, 3)
insert into REGISTER (IdChild, IdActivity) values (37, 1)
insert into REGISTER (IdChild, IdActivity) values (37, 2)
insert into REGISTER (IdChild, IdActivity) values (37, 3)
insert into REGISTER (IdChild, IdActivity) values (37, 9)
insert into REGISTER (IdChild, IdActivity) values (38, 5)
insert into REGISTER (IdChild, IdActivity) values (38, 7)
insert into REGISTER (IdChild, IdActivity) values (38, 3)
insert into REGISTER (IdChild, IdActivity) values (39, 5)
insert into REGISTER (IdChild, IdActivity) values (39, 7)
insert into REGISTER (IdChild, IdActivity) values (39, 3)
insert into REGISTER (IdChild, IdActivity) values (40, 1)
insert into REGISTER (IdChild, IdActivity) values (40, 2)
insert into REGISTER (IdChild, IdActivity) values (40, 8)