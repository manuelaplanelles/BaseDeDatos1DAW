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