create database EXPERT_LOGISTICS
-- 1. EMPLOYEES_HIRE_YEAR. Write a SQL procedure to create a list of the employees who were hired in the year 
-- given as a parameter. For example, for 1993, the procedure will show the output:
create or alter procedure EMPLOYEES_HIRE_YEAR (@year as int)
as
begin
	select EMPLOYEE.FirstName, EMPLOYEE.LastName, EMPLOYEE.Title, format(EMPLOYEE.HireDate,'dd/MM/yyyy') as HireDate ,
		EMPLOYEE.HomePhone, boss.FirstName + ' '+boss.LastName as Boss
	from EMPLOYEE
		join EMPLOYEE as boss on EMPLOYEE.ReportsTo = boss.EmployeeID
	where year(EMPLOYEE.HireDate) = @year
	order by EMPLOYEE.ReportsTo
end

--exec EMPLOYEES_HIRE_YEAR @year = 1993

-- 2. EMPLOYEES_TERRITORY. Write a SQL procedure to create a list of the territories of the employee given as a parameter 
-- works. For example, EXEC EMPLOYEES_TERRITORY 'Andrew','Fuller', will show the output:
create or alter procedure EMPLOYEES_TERRITORY (@firstname as varchar(10), @lastname as varchar(20))
as
begin
	select FirstName, LastName, Title, TerritoryDescription
	from EMPLOYEE, EMPLOYEE_TERRITORY, TERRITORY
	where EMPLOYEE.EmployeeID=EMPLOYEE_TERRITORY.EmployeeID
		and EMPLOYEE_TERRITORY.TerritoryID=TERRITORY.TerritoryID
		and FirstName = @firstname
		and LastName = @lastname
end
-- exec EMPLOYEES_TERRITORY @firstname = 'Andrew', @lastname = 'Fuller'

-- 3. CUST_ORDER_HISTORY. Write a SQL procedure to create a list of the products (name) and total of the products 
-- ordered by the id of the customer given as a parameter. For example, for the customer ALFKI, the procedure will 
-- show the output:

create or alter procedure CUST_ORDER_HISTORY @customer varchar(30)
as
begin
	select ProductName, Quantity as Total
	from PRODUCT, ORDER_DETAILS, ORDERS
	where PRODUCT.ProductID=ORDER_DETAILS.ProductID
		and ORDER_DETAILS.OrderID=ORDERS.OrderID
		and ORDERS.CustomerID = @customer
	order by ProductName
end
-- exec CUST_ORDER_HISTORY @customer = 'ALFKI'