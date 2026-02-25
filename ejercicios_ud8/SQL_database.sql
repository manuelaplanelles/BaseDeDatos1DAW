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

--8.SALES_CUSTOMER_COUNTRY_YEAR. Write a SQL procedure to show a list of the customers and 
--the total purchased of the customers from the country and year given as parameters. Spain, 1996

create or alter procedure SALES_CUSTOMER_COUNTRY_YEAR (@country as varchar(15), @year_order as char(4))
as
begin
	select CompanyName, 
		cast(sum(UnitPrice*Quantity*(1-Discount)) as money) as TotalPurchased
	from CUSTOMER, ORDER_DETAILS,ORDERS
	where CUSTOMER.CustomerID=ORDERS.CustomerID
		and ORDERS.OrderID=ORDER_DETAILS.OrderID
		and year(OrderDate) =@year_order
		and Country =@country
	group by CompanyName, Year(OrderDate)
end
--ECEC SALES_CUSTOMER_COUNTRY_YEAR 'Spain', '1996'

--9. SALES_BETWEEN_DATES. Write a SQL procedure to create a list of the orders ordered between the dates 
--given as parameters. For example, for the dates 01/01/1997 and 05/01/1997, the procedure will show the output:
create or alter procedure SALES_BETWEEN_DATES (@beginning as deletime, @eding as datetime)
as
begin
	select orders.OrderID,
		convert(varchar ShippedDate, 3)
