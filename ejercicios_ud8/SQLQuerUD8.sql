--create database EXPERT_LOGISTICS
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

--------------------------------------------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------------------------------------------
--4. EMPLOYEE_SALES_BY_DATES. Write a SQL procedure to create a list of the employees and the total sales by 
-- employee between the two dates given as parameters. For example, for the dates 01/07/1996 and 23/07/1996, 
-- the procedure will show the output:

create or alter procedure EMPLOYEE_SALES_BY_DATES (@shippedDate1 date, @shippedDate2 date) 
as begin
	select Country, LastName, FirstName, FORMAT(ShippedDate, 'dd/MM/yyyy') as ShippedDate, ORDERS.OrderID, CAST(SUM(UnitPrice * Quantity * (1 - Discount)) AS DECIMAL(10,2)) AS SaleAmount
	from EMPLOYEE, ORDERS, ORDER_DETAILS
	where EMPLOYEE.EmployeeID=ORDERS.EmployeeID
		and ORDERS.OrderID=ORDER_DETAILS.OrderID
		and ShippedDate between @shippedDate1 and @shippedDate2
	group by Country, LastName, FirstName, ShippedDate, ORDERS.OrderID
	order by ORDERS.OrderID
end
-- exec EMPLOYEE_SALES_BY_DATES @shippedDate1 = '01/07/1996', @shippedDate2 = '23/07/1996'

--------------------------------------------------------------------------------------------------------------------------
--5. CUST_ORDERS_DETAILS. Write a SQL procedure to create a list of the products ordered by the id_order given as a 
-- parameter. For example, for the order 10250, the procedure will show the output:
create or alter procedure CUST_ORDERS_DETAILS (@order int)
as begin
	select ProductName, CAST((ORDER_DETAILS.UnitPrice) as money)as UnitPrice, Quantity, 
		CONCAT((Discount* 100), + '%') as Discount, 
		Cast(Sum(ORDER_DETAILS.UnitPrice*Quantity*(1-Discount))AS REAL)as Final_Price
	from PRODUCT, ORDER_DETAILS
	where PRODUCT.ProductID=ORDER_DETAILS.ProductID
		and OrderID = @order
	group by ProductName,ORDER_DETAILS.UnitPrice, Quantity,Discount
end
--exec CUST_ORDERS_DETAILS @order = 10250
--------------------------------------------------------------------------------------------------------------------------
--6. CUST_ORDERS_SHIPPERS. Write a SQL procedure to create a list of the orders ordered by the customer given as a 
-- parameter. For example, for the customer TOMSP, the procedure will show the output:
-- Change the format of the dates to show the European format.
create or alter procedure CUST_ORDERS_SHIPPERS (@customer char(5))
as begin
	select ORDERS.OrderID, format(OrderDate, 'dd/MM/yyyy')as OrderDate, format(RequiredDate, 'dd/MM/yyyy')as RequiredDate, format(ShippedDate, 'dd/MM/yyyy')as ShippedDate, 
		DATEDIFF(DD, OrderDate, RequiredDate) as Diff_Order_Req, CompanyName 
	from ORDERS, ORDER_DETAILS, PRODUCT, SHIPPER
	where ORDERS.OrderID=ORDER_DETAILS.OrderID
		and ORDER_DETAILS.ProductID=PRODUCT.ProductID
		and ORDERS.ShipVia=SHIPPER.ShipperID
		and CustomerID = @customer
	group by ORDERS.OrderID, OrderDate,RequiredDate,ShippedDate,CompanyName 
end

-- exec CUST_ORDERS_SHIPPERS @Customer = 'TOMSP'
--------------------------------------------------------------------------------------------------------------------------
--7.FIVE_MOST_EXP_PRODUCTS. Write a SQL procedure to show a list of the five most expensive products.
create or alter procedure FIVE_MOST_EXP_PRODUCTS 
as begin
	select Top 5 ProductName as Five_Most_Exp_Products, PRODUCT.UnitPrice
	from PRODUCT
	order by PRODUCT.UnitPrice desc
end
-- exec FIVE_MOST_EXP_PRODUCTS 

--------------------------------------------------------------------------------------------------------------------------
--8. SALES_CUSTOMER_COUNTRY_YEAR. Write a SQL procedure to show a list of the customers and the total purchased of 
-- the customers from the country and year given as parameters. Spain, 1996
create or alter procedure SALES_CUSTOMER_COUNTRY_YEAR (@pais varchar(15), @year char(4))
as begin
	select CompanyName, SUM(UnitPrice * Quantity) AS Total_Purchased
	from ORDER_DETAILS, ORDERS, CUSTOMER
	where ORDER_DETAILS.OrderID=ORDERS.OrderID
		and ORDERS.CustomerID=CUSTOMER.CustomerID
		and Country = @pais
		and YEAR(OrderDate) = @year
	group by CompanyName
	order by CompanyName
end
-- exec SALES_CUSTOMER_COUNTRY_YEAR @pais = 'Spain', @year = 1996

--------------------------------------------------------------------------------------------------------------------------
--9. SALES_BETWEEN_DATES. Write a SQL procedure to create a list of the orders ordered between the dates given as 
-- parameters. For example, for the dates 01/01/1997 and 05/01/1997, the procedure will show the output:
create or alter procedure SALES_BETWEEN_DATES (@date1 date, @date2 date)
as begin
	select ORDERS.OrderID,FORMAT(ShippedDate,'dd/MM/yyyy') as ShippedDate,  
		cast(sum(UnitPrice*Quantity*(1- discount))as DECIMAL(10,2)) as Subtotal
	from ORDER_DETAILS, ORDERS
	where ORDER_DETAILS.OrderID=ORDERS.OrderID
		AND ShippedDate BETWEEN @date1 AND @date2
	group by ORDERS.OrderID, ShippedDate
end
-- exec SALES_BETWEEN_DATES @date1= '01/01/1997', @date2 = '05/01/1997'

--------------------------------------------------------------------------------------------------------------------------
--10. SALES_BETWEEN_YEARS. Write a SQL procedure to show the total amount of money charged between the year given 
-- as parameters. For example, for the years from 1996 to 1998, the procedure will show the output:
create or alter procedure SALES_BETWEEN_YEARS (@year1 char(4), @year2 char(4))
as begin
	select Year(ShippedDate) as ShippedYear, concat(cast(Sum(UnitPrice*Quantity*(1-Discount))as money), '€') as Total
	from ORDER_DETAILS, ORDERS
	where ORDER_DETAILS.OrderID=ORDERS.OrderID
		and YEAR(ShippedDate) BETWEEN @year1 AND @year2
	group by YEAR(ShippedDate)
	order by YEAR(ShippedDate)
end
-- exec SALES_BETWEEN_YEARS @year1 = '1996', @year2 = '1998'

--HOMEWORK--

-- create database  BICICLOS
--14. STOCK_CATEGORY_STORE. Write a SQL procedure to show the bikes name, the brands, the stores where you can find them 
-- and the number of bikes they have, for the category and year given as parameters. For electric and 2016:
create or alter procedure STOCK_CATEGORY_STORE (@category varchar(50), @year char(4))
as begin
	select product_name as product_name, brand_name, store_name, quantity
	from PRODUCT, CATEGORY, BRAND, STOCK, STORE
	where PRODUCT.category_id=CATEGORY.category_id
		and PRODUCT.brand_id=BRAND.brand_id
		and PRODUCT.product_id=STOCK.product_id
		and STOCK.store_id=STORE.store_id
		and category_name = @category
		and model_year= @year
		
	group by product_name, model_year,product_name,brand_name, store_name, quantity
end
--exec STOCK_CATEGORY_STORE @category = 'Electric Bikes', @year = '2016'

--------------------------------------------------------------------------------------------------------------------------
--16. TOTAL_ORDERS_STATE_YEAR. Write a SQL procedure to print the total orders for the year given as a parameter. For the year 2016, the list will be:

create or alter procedure TOTAL_ORDERS_STATE_YEAR (@year char(4))
as begin
	declare @list varchar(max)
	set @list=''
	print 'STATE   T_ORDERS'
	print '================'
	
	select 
	@list=@list+cast(state as char(2))+space(10)+
			cast(count(order_id) as char(3)) + char(10)
	from CUSTOMER, ORDERS
	where CUSTOMER.customer_id=ORDERS.customer_id
		and year(order_date) = @year
	group by state
	order by state
	
	print @list

end
-- exec TOTAL_ORDERS_STATE_YEAR @year='2016'

--------------------------------------------------------------------------------------------------------------------------
--17. AMOUNT_CHARGED_MONTH_YEAR. Write a SQL procedure to print the total amount charged every month for the year given as a parameter. Use the following 
-- functions: SUBSTRING, DATENAME, CAST, MONTH, YEAR. For 2017 the list will be:
create or alter procedure AMOUNT_CHARGED_MONTH_YEAR (@year date)
as begin
	declare @lista varchar(max)
	set @lista = ''

	print 'MONTHS        TOTAL'
	print '====================='

	select @lista=@lista+substring(datename(month, shipped_date),1,3)+space(10)+
		cast(cast(sum(quantity*list_price*(1-discount))as money)as char(10))+char(10)
	from ORDERS, ORDER_ITEM
	where ORDERS.order_id=ORDER_ITEM.order_id
		and Datename(year,shipped_date) = @year
	group by month(shipped_date), datename(month, shipped_date)
	order by month(shipped_date)
	
	print @lista

end
-- exec AMOUNT_CHARGED_MONTH_YEAR @year = '2017'


--------------------------------------------------------------------------------------------------------------------------
--18. TOTAL_ORDERS_EMPLOYEE_YEAR. Write a SQL procedure to print the number of orders per employee for the year given as a parameter. For 2018 the list will be:
create or alter procedure TOTAL_ORDERS_EMPLOYEE_YEAR (@year char(4))
as begin
	declare @lista varchar(max)
	set @lista = ''

	print 'EMPLOYEE              TOTAL'
	print '==========================='

	select @lista=@lista+cast(concat(first_name,' ',last_name) as char(23))+
		cast(count(order_id) as char(5)) + char(10)
	from STAFF, ORDERS
	where STAFF.staff_id=ORDERS.staff_id
		and YEAR(order_date) = @year
	group by first_name, last_name

	print @lista

end
-- exec TOTAL_ORDERS_EMPLOYEE_YEAR @year = '2018'


--IF-ELSE--------------------------------------------------------------------------------------------------------------------------
--19. COMPARE_TWO_NUMBERS. Create a procedure to compare two numbers given as parameters.
create or alter procedure COMPARE_TWO_NUMBERS (@num1 tinyint, @num2 tinyint)
as
begin
	if @num1 > @num2
		begin
			print cast(@num1 as varchar)+ ' is bigger than '+ cast(@num2 as varchar) 
		end
	else if @num1 = @num2
		begin
			print cast(@num1 as varchar)+ ' is equal to '+ cast(@num2 as varchar)
		end
	else
		begin
			print cast(@num2 as varchar)+ ' is bigger than '+ cast(@num1 as varchar)
		end
end
-- exec COMPARE_TWO_NUMBERS @num1 = 5, @num2 = 3

--------------------------------------------------------------------------------------------------------------------------
--20. COMPARE_TWO_LETTERS. Create a procedure to compare two letters given as parameters.
create or alter procedure COMPARE_TWO_LETTERS (@letter1 char(1), @letter2 char(1))
as
begin
	if @letter1 = @letter2
		begin
			print 'The two letters are equal'
		end
	else
		begin
			print 'The two letters are different'
		end
end
-- exec COMPARE_TWO_LETTERS @letter1 = A, @letter2 = B
--------------------------------------------------------------------------------------------------------------------------
--21. COMPARE_THREE_NUMBERS. Create a procedure to compare three numbers given as parameters.
create or alter procedure COMPARE_THREE_NUMBERS (@num1 tinyint, @num2 tinyint, @num3 tinyint)
as
begin
	if @num1 > @num2 and @num1> @num3
		begin
			print cast(@num1 as varchar)+ ' is higher than '+ cast(@num2 as varchar) + ' and ' + cast(@num3 as varchar)
		end
	else if @num2 > @num1 and @num2> @num3
		begin
			print cast(@num2 as varchar)+ ' is higher than '+ cast(@num1 as varchar) + ' and ' + cast(@num3 as varchar)
		end
	else
		begin
			print cast(@num3 as varchar)+ ' is higher than '+ cast(@num1 as varchar) + ' and ' + cast(@num2 as varchar)
		end
end
-- exec COMPARE_THREE_NUMBERS @num1 = 3, @num2 = 2, @num3 =1
--------------------------------------------------------------------------------------------------------------------------
--22. COLOUR_CODE. Create a procedure to print the name of the colour depending on the code (R=red, B=blue, G=green, other letter→ The code does not exist).
create or alter procedure COLOUR_CODE (@code char(1))
as
begin
	if @code='R'
		begin
			print 'The color is red'
		end
	else if @code='B'
		begin
			print 'The color is blue'
		end
	else if @code='G'
		begin
			print 'The color is green' 
		end
	else 
		begin
			print 'The code does not exist' 
		end
end
--exec COLOUR_CODE @code = 'B'
--------------------------------------------------------------------------------------------------------------------------
--23. CALCULATOR. Create a procedure to create a calculator for two numbers and four operations (ADDITION, SUBSTRACTION, MULTIPLICATION, DIVISION)
create or alter procedure CALCULATOR (@op varchar(20), @n1 real, @n2 real)
as
BEGIN
	if @op='ADDITION'
		begin
		print cast(@n1 as varchar)+'+'+cast(@n2 as varchar)+'='+cast(@n1+@n2 as varchar)
		end
	else if @op='SUBSTRACTION'
		begin
		print cast(@n1 as varchar)+'-'+cast(@n2 as varchar)+'='+cast(@n1-@n2 as varchar)
		end
	else if @op='MULTIPLICATION'
		begin
		print cast(@n1 as varchar)+'*'+cast(@n2 as varchar)+'='+cast(@n1*@n2 as varchar)
		end
	else if @op='DIVISION'
		begin
		print cast(@n1 as varchar)+'/'+cast(@n2 as varchar)+'='+cast(@n1/@n2 as varchar)
		end
	else
		print 'I DO NOT UNDERSTAND'
END
-- exec CALCULATOR @op='DIVISION', @n1 = 5, @n2=2
--------------------------------------------------------------------------------------------------------------------------
--24. TYPE TAXES. Create a procedure to calculate the total of a bill depending on the type of the VAT (1=0%, 2=10%, 3=15%, other=20%). The parameters will be price, quantity, type_tax
-- For example: EXEC TYPE_TAXES, 10,30,4
create or alter procedure TYPE_TAXES (@price money, @quantity tinyint, @type tinyint)
as
BEGIN
	declare @subtotal money, @total money
	set @subtotal=@price*@quantity
	if @type=1
		begin
			set @total=@subtotal
		end
	else if @type=2
		begin
			set @total=@subtotal*1.1
		end
	else if @type=3
		begin
			set @total=@subtotal*1.15
		end
	else 
		begin
			set @total=@subtotal*1.2
		end
	print 'subtotal= '+cast(@subtotal as varchar)+' total= '+cast(@total as varchar)
END
-- exec TYPE_TAXES @price= 10, @quantity =30, @type = 4

-------BICICLOS database-------------------------------------------------------------------------------------------------------------------
--25. Create a program to print a sentence depending on if the number of the customers from New York is bigger,
-- equal, or lower than the customers from California. Show the actual date at the end of the sentence.

create or alter procedure NUM_CUSTOMERS
as begin
	
	declare @ny int, @ca int
		select @ny =count(customer_id) from CUSTOMER where state='NY'
		select @ca =count(customer_id) from CUSTOMER where state='CA'

	if (@ny > @ca)
		begin
			print 'There are more customers fom New York than from California------' + cast(getdate() as varchar)
		end
	else if (@ny < @ca)
		begin
			print 'There are more customers fom California than from New York------' + cast(getdate() as varchar)
		end
	else
		begin
			print 'New York and California have the same number of customers------' + cast(getdate() as varchar)
		end

end

-- exec NUM_CUSTOMERS

--------------------------------------------------------------------------------------------------------------------------
--26. EMPLOYEE_ORDERS. Create a procedure to compare the total orders of the employees given as parameters.
-- For example: EXEC EMPLOYEE_ORDERS 'Genna', 'Mireya'
create or alter procedure EMPLOYEE_ORDERS (@employ1 varchar(50), @employ2 varchar(50))
as begin
 declare @total_order_employ1 int
	select @total_order_employ1 = COUNT(order_id) from ORDERS, STAFF where ORDERS.store_id=STAFF.staff_id and first_name like '%'+@employ1+'%'
 
 declare @total_order_employ2 int
	select @total_order_employ2 = COUNT(order_id) from ORDERS, STAFF where ORDERS.store_id=STAFF.staff_id and first_name=@employ2 
	
	if (@total_order_employ1> @total_order_employ2)
		begin
			print char(10) + 'The employee: ' + @employ1+' sold more than: ' + @employ2
		end
	else
		begin
			print char(10) + 'The employee: ' + @employ2+' sold more than: ' + @employ1
		end
	print char(10) + @employ1 + ' sold ' + cast(@total_order_employ1 as varchar) + ' orders'
	print char(10) + @employ2 + ' sold ' + cast(@total_order_employ2 as varchar) + ' orders'
end

-- exec EMPLOYEE_ORDERS @employ1 = 'Genna' , @employ2 = 'Mireya'

--------------------------------------------------------------------------------------------------------------------------
		--27.
--------------------------------------------------------------------------------------------------------------------------
--28.INCENTIVE. Create a procedure to give an incentive for the staffs who sold more than the amount given as parameter. 
-- The parameters will be the employee and the amount of money they need to exceed.
-- For example: EXEC INCENTIVE 'Kali Vargas', 500000
-- For example: EXEC INCENTIVE 'Genna Serrano', 500000
	create or alter procedure INCENTIVE (@name varchar(50), @lastname varchar(50), @sold int)
	as begin
		 declare @total_sold_employ int
		 set @total_sold_employ = (select cast(sum(quantity * list_price * (1-discount))as money)
									from ORDERS, STAFF, ORDER_ITEM 
									where ORDERS.staff_id =STAFF.staff_id 
										and ORDERS.order_id=ORDER_ITEM.order_id
										and first_name = @name
										and last_name = @lastname)
		 if (@total_sold_employ < @sold)
			 begin
				print @name + ' '+ @lastname + ' does not obtein an incentive'
			 end
		else 
			begin
				print @name + ' '+ @lastname + ' obtains an incentive of 200€'
			end

	end
	--exec INCENTIVE @name ='Genna', @lastname= 'Serrano', @sold= 500000

--------------------------------------------------------------------------------------------------------------------------
--29. BILLS_HIGHER_THAN. Create a procedure to show a list of the bills which exceeded the amount given as a parameter.
-- For example: EXEC BILLS_HIGHER_THAN 25000
create or alter procedure BILLS_HIGHER_THAN (@bills money)
as begin
	declare @lista varchar(max)
	set @lista=''

	print ' NUM_ORDER    DATE           CLIENTE            TOTAL BILL'
	print '==========================================================='

	select @lista = @lista + space(4)+
		cast(ORDERS.order_id as char(10)) +
		cast(order_date as char(15)) +
		cast(concat(first_name, ' ', last_name) as char(20)) +
		cast(cast(sum(quantity * list_price * (1-discount)) as decimal(10,2)) as char(12)) + char(10)
	from ORDERS, ORDER_ITEM, CUSTOMER
	where ORDERS.order_id = ORDER_ITEM.order_id
		and CUSTOMER.customer_id = ORDERS.customer_id
	group by ORDERS.order_id, order_date, first_name, last_name
	having sum(quantity * list_price * (1-discount)) > @bills
	order by ORDERS.order_id
	print @lista
end
--exec BILLS_HIGHER_THAN @bills = 25000



--INSERT------------------------------------------------------------------------------------------------------------------------
		--31. Create a list to display the orders and the customers who made them in February 1997. The orders were carried out by Janet Leverling.

-----create database CLIENT_PROVINCE---------------------------------------------------------------------------------------------------------------------
--32. INSERT_NEW_PROVINCE2. Create a procedure to insert a new province checking if the province had been previously added. For example:
-- EXEC INSERT_NEW_PROVINCE2 'Cordoba'
-- EXEC INSERT_NEW_PROVINCE2 'Sevilla'
create or alter procedure INSERT_NEW_PROVINCE2 (@province varchar(20))
as begin
	if exists(select NameProvince  from province where NameProvince=@province)
		begin 
			print 'The province ' + @province+' is already in the database'
			return
		end
	else
		begin
			insert into province 
			values (@province)
			print 'The province ' + @province+' has been added'
		end
end
--exec INSERT_NEW_PROVINCE2 @province='Sevilla'
	select * from province
--------------------------------------------------------------------------------------------------------------------------
--33. INSERT_NEW_CLIENT1. Create a procedure to insert a new client.
-- EXEC INSERT_NEW_CLIENT1 'Fraile Antonio', 'Alona, 25','Rosario',2,'666552233'
create or alter procedure INSERT_NEW_CLIENT1 (@name varchar(30), @address varchar(30), @city varchar(20), @idprov tinyint, @phone char(9))
as begin
	if exists (select Nameclient, Address,City,Idprovince, Phone from client where Nameclient=@name and Address=@address and City=@city and Idprovince=@idprov and Phone=@phone)
		 begin
			 print 'The client ' + @name + ' has been added'
			 return
		 end
	else
		begin
			insert into client
			values (@name, @address, @city, @idprov, @phone)
			print 'The customer ' +@name+' has been created'
		end
	
end
-- exec INSERT_NEW_CLIENT1 @name='Fraile Antonio', @address='Alona, 25', @city='Rosario', @idprov=2, @phone='666552233'

--------------------------------------------------------------------------------------------------------------------------
--34. INSERT_NEW_CLIENT2. Create a procedure to insert a new client checking if the number of the province is right.
-- EXEC INSERT_NEW_CLIENT2 'Pérez Rosa', 'Alona, 32', 'Rosario',10,'608525252'
-- EXEC INSERT_NEW_CLIENT2 'Pérez Rosa', 'Alona, 32', 'Rosario',2,'608525252'
create or alter procedure INSERT_NEW_CLIENT2 (@name varchar(30), @address varchar(30), @city varchar(20), @idprov tinyint, @phone char(9))
as begin
	if not exists (select Idprovince from province where Idprovince=@idprov)
		begin
			print 'The province ' + cast(@idprov as varchar(3)) + ' does not exist'
			return
		end
	
	if exists (select Nameclient, Address,City,Idprovince, Phone from client where Nameclient=@name and Address=@address and City=@city and Idprovince=@idprov and Phone=@phone)
		 begin
			 print 'The client ' + @name + ' has been added'
			 return
		 end
	else
		begin
			insert into client
			values (@name, @address, @city, @idprov, @phone)
			print 'The customer ' +@name+' has been created'
		end
	
end
-- exec INSERT_NEW_CLIENT2 @name='Pérez Rosa', @address='Alona, 32', @city='Rosario', @idprov=2, @phone='608525252'
--------------------------------------------------------------------------------------------------------------------------
		--35. INSERT_NEW_CLIENT3. Create a procedure to insert a new client checking if the number of the province is right and the format of the phone number is right
		-- EXEC INSERT_NEW_CLIENT3 'Juarez Pedro', 'San Martin, 2', 'Rosario',2,'2345'


--------------------------------------------------------------------------------------------------------------------------
--36. NEW_PRODUCT. Create a procedure to insert a new product checking if the brand and the category exist.
-- EXEC NEW_PRODUCT 'BMX Subwoofer', 'Electra', 'Children Bicycles', 2019, 429.99


--------------------------------------------------------------------------------------------------------------------------
--37. NEW_STOCK. Create a procedure to insert a product and the stock in a shop checking if the product and the shop exist.
-- EXEC NEW_STOCK 'Santa Cruz Bikes', 'BMX Subwoofer', 32


--------------------------------------------------------------------------------------------------------------------------
		--38. NEW_ORDER. Create a procedure to insert an order. Check if the customer, the store, and the employee exist.
		-- EXEC NEW_ORDER 'Corene', 'Wall', 1, '04/04/2022','06/04/2022', null, 'Santa Cruz Bikes', 'Mireya'
--------------------------------------------------------------------------------------------------------------------------
		--39. NEW_ORDER_ITEM. Create a procedure to insert a new line in an order. Check if the product and the order exist. Remember to update the stock.
		-- EXEC NEW_ORDER_ITEM 1616, 1, 1,1,0.10
		-- EXEC NEW_ORDER_ITEM 1616, 2, 2,3,0.20
		-- EXEC NEW_ORDER_ITEM 1616, 3, 4,3,0.05
--------------------------------------------------------------------------------------------------------------------------
		--40. SHOW BILL. Create a procedure to display the bill for a customer, order and date given as parameters.
		-- EXEC BILL 24,1616,'04/04/2022'

--------------------------------------------------------------------------------------------------------------------------
		--41. MINIMUM_STOCK. Create a procedure to display the shops which have less stock than the number given as parameter.
		-- EXEC MINIMUM_STOCK 3

--------------------------------------------------------------------------------------------------------------------------
--42. NEW_STUDENT. Create a procedure to add a new student.
-- EXEC NEW_STUDENT '85.236.125P','Armando', 'Casitas', 'Rojas', 'Los Luceros, 10', 'Alicante', '666585696','10/10/1990','C.Valenciana'
-- EXEC NEW_STUDENT '12.123.123C','José', 'Ruiz', 'Pérez', 'C/Mayor,6', 'San Vicente', '666454545','23/06/1989','C.Valenciana'

--------------------------------------------------------------------------------------------------------------------------
--43. DELETE_STUDENT. Create a procedure to delete a student.
-- EXEC DELETE_STUDENT '85.236.125P'
-- EXEC DELETE_STUDENT '88.888.125P'


--44
--45
--46
--47

---- database  DVD_CORNER ------------------------------------------------------------------------------------------------------------------------
--48. ACTOR_FILMS. Create a procedure to display the actors and the films. Sort the result set by Actor_id.
create or alter procedure ACTOR_FILMS
as begin
	declare @lista varchar(max)
	set @lista = ''

	print 'ACTOR                      FILM'
	print '============================================='

	select @lista=@lista+ cast(concat(first_name,' ',last_name) as char(23))+
		cast(Title as char(255)) + char(10)
	from Actor, Film_actor, Film
	where Actor.Actor_id=Film_actor.Actor_id
		and Film_actor.Film_id=Film.Film_id
	order by Actor.Actor_id

	print @lista

end
-- exec ACTOR_FILMS

--------------------------------------------------------------------------------------------------------------------------
--49. COUNTRY_CITIES. Create a procedure to display the countries and the number of cities of them. Sort the result set by id, then country.
create or alter procedure COUNTRY_CITIES
as begin
	declare @lista varchar(max)
	set @lista = ''
	print 'COUNTRY                   CITIES'
	print '================================='
		select @lista=@lista+ cast(cast(Country as varchar(50)) as char(30))+
		cast(count(City) as char(10))+char(10)
	from Country, City
	where Country.Country_id=City.Country_id
	group by Country, Country.Country_id
	order by Country.Country_id

	print @lista
end
-- exec COUNTRY_CITIES

-----MEDITECH database---------------------------------------------------------------------------------------------------------------------
--50. PHYSICIAN_TOTAL_TREATMENTS. Create a procedure to display the physicians and the total treatments they are able to proceed.
create or alter procedure PHYSICIAN_TOTAL_TREATMENTS
as begin
	declare @lista varchar(max)
	set @lista = ''
	print 'PHYSICIAN                   T_TREATMENTS'
	print '-----------------------------------------'
		select @lista=@lista+
			cast(NamePhysician as char(30))+
			cast(count(CodeTreatment) as char(5))+ char(10)
		from PHYSICIAN
			LEFT JOIN TRAINED_IN on PHYSICIAN.PhysicianID = TRAINED_IN.PhysicianID
		group by NamePhysician


	print @lista
end
--exec PHYSICIAN_TOTAL_TREATMENTS

--------------------------------------------------------------------------------------------------------------------------
--51. APPOINTMENT_PATIENT. Create a procedure to display the dates of the appointments for every patient and total medicines that were prescribed.
create or alter procedure APPOINTMENT_PATIENT
as begin
	declare @lista varchar(max)
	set @lista = ''
	print 'DATE             PATIENT               NUM_MEDS'
	print '-----------------------------------------------'

	select @lista=@lista+
		cast(DateAppointment as char(12)) + space(5) + 
		cast(NamePatient as char(25)) + 
		cast(count(PRESCRIPTION.AppointmentID) as char(5))+ char(10)
	from APPOINTMENT
		LEFT JOIN PRESCRIPTION on APPOINTMENT.AppointmentID = PRESCRIPTION.AppointmentID
		JOIN PATIENT on PATIENT.PatientSSN = APPOINTMENT.PatientSSN
	group by DateAppointment, NamePatient
	order by DateAppointment

	print @lista
end
--exec APPOINTMENT_PATIENT

--52
--53
--54


--STRING_AGG------------------------------------------------------------------------------------------------------------------------
-----create database OLYMPIC_GAMES---------------------------------------------------------------------------------------------------------------------
--55. SPORT_EVENTS. Create a procedure to display the sports and the events for every single sport.

create or alter procedure SPORT_EVENTS
as begin
    declare @primId int, @ultId int
    declare @sport varchar(50)
    declare @events varchar(max)

    set @primId = (select MIN(sport_id) from SPORT)
    set @ultId = (select MAX(sport_id) from SPORT)

    while @primId <= @ultId
		begin
			set @sport = (select sport_name from SPORT where sport_id = @primId)
			set @events = (select STRING_AGG(event_name, char(10)) 
						   from EVENT 
						   where sport_id = @primId)

			if @sport is not null
			begin
				print 'SPORT NAME: ' + @sport
				print '-------------------------'
				print @events
				print ''
		end

      set @primId = @primId + 1
    end
end
--exec SPORT_EVENTS


-----create database MEDITECH ---------------------------------------------------------------------------------------------------------------------
--56. PHYSICIAN_TRAINED_IN. Create a procedure to display the doctors and the treatments they were trained for.
create or alter procedure PHYSICIAN_TRAINED_IN
as begin
    declare @primId int, @ultId int
    declare @doctor varchar(50)
    declare @treat varchar(50)

    set @primId = (select MIN(PhysicianID) from TAKE_TREATMENT)
    set @ultId = (select MIN(PhysicianID) from TAKE_TREATMENT)

    while @primId <= @ultId
		begin
			set @doctor = (select NamePhysician from PHYSICIAN where PhysicianID = @primId)
			set @treat = (select STRING_AGG(NameTreatment, char(10)) 
						from TREATMENT, TAKE_TREATMENT
						where TREATMENT.CodeTreatment = TAKE_TREATMENT.CodeTreatment
							and TAKE_TREATMENT.PhysicianID = @primId)

			print 'PHYSICIAN: ' + @doctor
			print '-------------------------'
			print @treat
			print ''
		end

      set @primId = @primId + 1
end
-- exec PHYSICIAN_TRAINED_IN

--------------------------------------------------------------------------------------------------------------------------
--57. APPOINTMENTS_MONTH_YEAR. Create a procedure to display the appointment for the month and year given as parameter.
-- EXEC APPOINTMENTS_MONTH_YEAR 5, 2008


--------------------------------------------------------------------------------------------------------------------------
		--58.
--------------------------------------------------------------------------------------------------------------------------
		--59.
--------------------------------------------------------------------------------------------------------------------------
		--60.
--------------------------------------------------------------------------------------------------------------------------
--61. ACTOR_FILMS2. Create a procedure to display the actors and all the films they participated in. Sort the result set by actor_id.


--------------------------------------------------------------------------------------------------------------------------
		--62.
--------------------------------------------------------------------------------------------------------------------------
--63. COUNTRY_CITIES_2. Create a procedure to display the country and the cities for every country.


--------------------------------------------------------------------------------------------------------------------------
		--64.
--------------------------------------------------------------------------------------------------------------------------
		--65.
--------------------------------------------------------------------------------------------------------------------------
		--66.
--------------------------------------------------------------------------------------------------------------------------
		--67.
--------------------------------------------------------------------------------------------------------------------------
		--68.
--------------------------------------------------------------------------------------------------------------------------
--69. RANGE_PRODUCTS_PRICE. Create a procedure to display ranges and the products of every range that the price is bigger or equal to the price given as parameter.
-- EXEC RANGE_PRODUCTS_PRICE 90


--WHILE------------------------------------------------------------------------------------------------------------------------
--70
--------------------------------------------------------------------------------------------------------------------------
		--71
--------------------------------------------------------------------------------------------------------------------------
--72
--------------------------------------------------------------------------------------------------------------------------
--73.
--------------------------------------------------------------------------------------------------------------------------
--74
--------------------------------------------------------------------------------------------------------------------------
--76
--------------------------------------------------------------------------------------------------------------------------
		--77


--CURSOR------------------------------------------------------------------------------------------------------------------------
--First, declare two variables to hold product name and list price, and a cursor to hold the result of a query that retrieves 
-- product name and list price from the products table:

DECLARE @product_name VARCHAR(100)
DECLARE @list_price MONEY
DECLARE cursor_product CURSOR
FOR SELECT product_name, list_price
    FROM PRODUCT
	OPEN cursor_product
	FETCH NEXT FROM cursor_product INTO @product_name, @list_price
	
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			PRINT CAST(@product_name AS CHAR(60)) +
					cast(CAST(@list_price AS money) as char(10))
			FETCH NEXT FROM cursor_product INTO @product_name, @list_price
		END
CLOSE cursor_product
DEALLOCATE cursor_product

----EXPERT_LOGISTICS----------------------------------------------------------------------------------------------------------------------
-- 78. CUSTOMERS_TOTALORDERS_YEAR. Create a procedure to display all the customers and the total orders for every year.
CREATE OR ALTER PROCEDURE CUSTOMERS_TOTALORDERS_YEAR
AS BEGIN
    DECLARE @customer VARCHAR(100), @customerID char(5)
	declare @list varchar(max)=''
    DECLARE @year INT
    DECLARE @total MONEY

	DECLARE cursor_orders CURSOR
    
	FOR SELECT ContactName, CustomerID
        FROM CUSTOMER

		OPEN cursor_orders
		FETCH NEXT FROM cursor_orders INTO @customer, @customerID

		WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT 'CUSTOMER: ' + @customer 
				PRINT replicate ('*',30) 
				PRINT 'Year'+space(10)+'Total'+char(10)
				PRINT replicate ('-',20)
				select @list=@list+cast(Year(OrderDate) as char(7)) + 
					CAST(CAST(SUM(UnitPrice*Quantity*(1-Discount)) AS MONEY) AS CHAR(10))+char(10)
				from ORDERS, ORDER_DETAILS
				where ORDERS.OrderID=ORDER_DETAILS.OrderID
					and ORDERS.CustomerID = @customerID
				group by CustomerID, YEAR(OrderDate)
				print @list
				set @list=''
				
				FETCH NEXT FROM cursor_orders INTO @customer, @customerID

			END
		CLOSE cursor_orders
		DEALLOCATE cursor_orders
end
-- EXEC CUSTOMERS_TOTALORDERS_YEAR
--Duda: ¿cómo mostramos los años agrupados por cliente usando cursor? ¿Usamos @prev_customer para detectar el cambio de cliente o lo hacemos de otra manera?"

--------------------------------------------------------------------------------------------------------------------------
-- 79. ORDERS_CUSTOMER. Create a procedure to display the orders and the total amount for the customer given as parameter. 
-- Use a cursor to loop over the tables. For the customer Chop-suey Chinese.
create or alter procedure ORDERS_CUSTOMER (@name_customer varchar (30))
as begin
	declare @orderId int
	declare @date date
	declare @total money
	declare cursor_orders cursor
	for select ORDERS.OrderID, OrderDate, sum(UnitPrice*Quantity*(1- Discount))
        from CUSTOMER, ORDERS, ORDER_DETAILS
        where CUSTOMER.CustomerID=ORDERS.CustomerID
        AND ORDERS.OrderID=ORDER_DETAILS.OrderID
		AND CUSTOMER.CompanyName LIKE '%' + @name_customer + '%'
		group by ORDERS.OrderID, OrderDate
		order by OrderDate
	open cursor_orders
	fetch next from cursor_orders into @orderId, @date, @total
	print 'ORDERID      DATE               TOTAL'
	print REPLICATE('-', 41)
	while @@FETCH_STATUS = 0
		begin
			print CAST(@orderId AS VARCHAR) + SPACE(10) + CAST(@date AS VARCHAR) + SPACE(10) + CAST(@total AS VARCHAR)
			fetch next from cursor_orders into @orderId, @date, @total
		end
	close cursor_orders
	deallocate cursor_orders
end
--exec ORDERS_CUSTOMER 'Chop-suey Chinese'
SELECT * FROM CUSTOMER order by ContactName

---create database WEST_END_MUSIC -----------------------------------------------------------------------------------------------------------------------
-- 80. CUSTOMERS_BILLS_YEAR. Create a procedure to display the customers and their bills for the year given as a parameter. Here is
-- the partial output for the year 2009:


-- EXEC CUSTOMERS_BILLS_YEAR 2009

--- create database GRAVITY_STORE -----------------------------------------------------------------------------------------------------------------------
-- 82.  AUTHOR_BOOKS. Create a procedure to display the authors and their albums. If there are no books for the author, the author will not be displayed.
create or alter procedure AUTHOR_BOOKS
as begin
	declare @name varchar(50)
	declare @id int
	declare @list varchar(max)=''
	declare @title varchar (80)
	declare @publisher varchar(80)
	declare @lenguage varchar (30)

	declare cursor_author cursor 
	for select Author_ID, Author_Name
		from AUTHOR, BOOK_AUTHOR, BOOK
		where AUTHOR.Author_ID=BOOK_AUTHOR

end

---create database GRAVITY_STORE -----------------------------------------------------------------------------------------------------------------------
--83.CUSTOMER_METHODS. Create a procedure to display the customers who used the method given as parameter and spent more 
-- money than the amount given as parameter.
create or alter procedure CUSTOMER_METHODS (@method varchar(50), @morethan money)
as begin
	declare @name_customer varchar (100), @customerid int
	declare @total money
	declare cursor_methods cursor
	for select concat(First_Name,Last_Name), sum(Price), CUSTOMER.Customer_ID
		from CUSTOMER, CUST_ORDER, ORDER_LINE, SHIPPING_METHOD
		where CUSTOMER.Customer_ID = CUST_ORDER.Customer_ID
			and	CUST_ORDER.Shipping_Method_ID = SHIPPING_METHOD.Method_ID
			and CUST_ORDER.Order_ID = ORDER_LINE.Order_ID  
			and Method_Name=@method
		group by First_Name, Last_Name, CUSTOMER.Customer_ID
		having sum(Price) >= @morethan
		
	open cursor_methods
	fetch next from cursor_methods into @name_customer, @total, @customerid
	while @@FETCH_STATUS = 0
		begin
			print 'CUSTOMER: ' + @name_customer +space(15)+'TOTAL BILLS: ' + cast (@total as varchar)+'€'
			fetch next from cursor_methods into @name_customer, @total, @customerid
		end
	close cursor_methods
	deallocate cursor_methods
end

--EXEC CUSTOMER_METHODS 'INTERNATIONAL', 120
--EXEC CUSTOMER_METHODS 'Express', 70

--------------------------------------------------------------------------------------------------------------------------
-- 84. COUNTRY_BOOKS. Create a procedure to display the authors and total books sold for the country and publisher given as parameter. Display the result-set order by years.
create or alter procedure COUNTRY_BOOKS (@country varchar(50), @publis varchar(80)
as begin
	declare @autor varchar (50)
	declare @year char(4)
	declare @tSold
	declare @list =''

	declare cursor_year cursor
	for select Country_Name
		from COUNTRY

	open cursor_year
	fetch next from cursor_year into

end

-- EXEC COUNTRY_BOOKS 'Spain', 'Abacus'

---create database FILMS -----------------------------------------------------------------------------------------------------------------------
--92. DIRECTOR_MOVIES. Create a procedure to display the director and the movies that they directed. Here is the partial output:
create or alter procedure DIRECTOR_MOVIES
as begin
	declare @director varchar(30)
	declare @movie varchar(50)
	declare @year date
	declare @language varchar(50)
	declare cursor_director cursor
	
	for select 


end