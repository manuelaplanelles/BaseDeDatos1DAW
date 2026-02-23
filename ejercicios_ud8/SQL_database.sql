--2.EMPLOYEES_TERRITORY. Write a SQL procedure to create a list of the territories of 
--the employee given as a parameter works. For example, EXEC EMPLOYEES_TERRITORY 
--'Andrew','Fuller', will show the output:
create or alter procedure EMPLOYEES_TERRITORY
@firstname varchar(10), @lastname varchar(20)
as
begin
	select FirstName, LastName, TerritoryDescription
	from EMPLOYEE,TERRITORY,EMPLOYEE_TERRITORY
	where EMPLOYEE.EmployeeID=EMPLOYEE_TERRITORY.EmployeeID
		and EMPLOYEE_TERRITORY.TerritoryID=TERRITORY.TerritoryID
		and FirstName=@firstname and LastName=@lastname
end

--EXC EMPLOYEES_TERRITORY 'Margaret', 'Peacoocl'

--3.CUST_ORDER_HISTORY. Write a SQL procedure to create a list of the products (name) 
--and total of the products ordered by the id of the customer given as a parameter. 
--For example, for the customer ALFKI, the procedure will show the output:

create or alter procedure CUST_ORDER_HISTORY @customerID as char(5)
as
begin
	select ProductName, sum(quantity) as Total_products
	from PRODUCT, ORDER_DETAILS,ORDERS
	where ORDERS.OrderID=ORDER_DETAILS.OrderID
		and ORDER_DETAILS.ProductID=PRODUCT.ProductID
	group by ProductName
end
--EXC CUST_ORDER_HISTORY 'ANTON'