# Queenswood Summer Camp — Database Project

Database design and implementation project for a summer camp management system, developed as part of the **Database** module (1st year DAW) at IES Mutxamel.

## About the project

Queenswood is a summer camp for teenagers aged 12–15. The database manages children enrollments, parent records, medical issues, cabin assignments, activity registrations, and employee management including automatic bonus calculations.

## What I learned

- Designing an **ER Diagram** from a real-world scenario using Chen notation (entities, relationships, cardinalities, weak entities, multivalued attributes)
- Transforming an ER Diagram into a **Relational Model** (identifying PKs, FKs, M:N relationships requiring intermediate tables)
- Writing **DDL scripts** in SQL Server with proper data types, constraints (CHECK, FOREIGN KEY, UNIQUE, DEFAULT), and creation order based on dependencies
- Populating the database with realistic **sample data** following foreign key constraints
- Creating **triggers** (AFTER INSERT, AFTER UPDATE, INSTEAD OF INSERT) for business logic automation:
  - Automatic cabin assignment based on gender and availability
  - Random coach assignment with schedule conflict validation
  - Automatic bonus calculation for tutors and activity coaches
  - Activity registration validation (capacity, schedule overlap, max activities per child)
- Writing **stored procedures** with cursors to generate formatted reports

## Database structure

| Table | Description |
|-------|-------------|
| PARENT | Parent/guardian information |
| CHILD | Camper details with cabin and parent references |
| MEDICAL_ISSUE | Medical records (weak entity, composite PK) |
| EMPLOYEE | Staff with position, salary, and bonus tracking |
| CABIN | Cabin details with tutor assignment |
| ACTIVITY | Camp activities with schedule and coach assignments |
| REGISTER | Child-Activity enrollment (M:N relationship) |

## Deliverables

```
├── easter_project-ManuelaPlanelles.docx   # Full project documentation
├── 01_tables_constraints.sql              # DDL - CREATE TABLE scripts
├── 02_data.sql                            # DML - INSERT scripts
├── 03_triggers.sql                        # Trigger scripts
├── 04_procedures.sql                      # Stored procedure scripts
└── ER_Diagram.png                         # Entity-Relationship Diagram
```

## Tech stack

- **SQL Server** — Database engine
- **T-SQL** — Stored procedures, triggers, and queries
- **Draw.io** — ER Diagram design

## Key business rules implemented

- Each child must register for 3–4 activities (enforced via trigger)
- Activities have capacity limits of 10–25 spots (enforced via trigger)
- Children cannot enroll in activities with overlapping schedules (enforced via trigger)
- Cabins are gender-specific with 3–6 spots (enforced via CHECK + trigger)
- Coach employees receive a 50€ bonus per activity assigned (enforced via trigger)
- Tutor employees receive a 40€ bonus per cabin assigned (enforced via trigger)
- Only coaches can be assigned to activities (enforced via trigger)

## Author

**Manuela Planelles Lucas**  
1st year DAW student — IES Mutxamel  
Database module — Teacher: Mª Victoria Fraile Antón

---

*Project completed: April 2026*
