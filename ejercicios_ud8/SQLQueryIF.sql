-- 19. COMPARE_TWO_NUMBERS. Create a procedure to compare two numbers given as parameters.For example:
create or alter procedure COMPARE_2 (@num1 tinyint, @num2 tinyint)
as
begin
	if @num1 > @num2
		begin
			print cast(@num1 as varchar)+ 'is bigger than'+ cast(@num2 as varchar)  --cast para concatenar
		end
	else if @num1 = @num2
		begin
			print cast(@num1 as varchar)+ 'is equal to'+ cast(@num2 as varchar)
		end
	else
		begin
			print cast(@num2 as varchar)+ 'is bigger than'+ cast(@num1 as varchar)
		end
end

-- COMPARE_TWO_LETTERS. Create a procedure to compare two letters given as parameters.
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
-- exc COMPARE_2_LETTER 'B', 'C'
create or alter procedure COMPARE_TWO_LETTERS (@letter1 char(1), @letter2 char(1))
as
begin
	if @letter1 = @letter2
		begin
			print 'The letter ' + @letter1 + ' letters '  @letter2
		end
	else
		begin
			print 'The two letters are different'
		end
end

--21.COMPARE_THREE_NUMBERS. Create a procedure to compare three numbers given as parameters.
create or alter procedure COMPARE_3 (@num1 tinyint, @num2 tinyint, @num3 tinyint)
as
begin
	if @num1 > @num2 and @num1> @num3
		begin
			print cast(@num1 as varchar)+ 'is higher than'+ cast(@num2 as varchar) + ' and ' + cast(@num3 as varchar)
		end
	else if @num2 > @num1 and @num2> @num3
		begin
			print cast(@num2 as varchar)+ 'is higher than'+ cast(@num1 as varchar) + ' and ' + cast(@num3 as varchar)
		end
	else
		begin
			print cast(@num3 as varchar)+ 'is higher than'+ cast(@num1 as varchar) + ' and ' + cast(@num2 as varchar)
		end
end

--22.COLOUR_CODE. Create a procedure to print the name of the colour depending on the code (R=red, B=blue, G=green, 
--other letter→ The code does not exist).
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

--exec COLOUR_CODE 'U'

-- 23.CALCULATOR. Create a procedure to create a calculator for two numbers and four operations 
--(ADDITION, SUBSTRACTION, MULTIPLICATION, DIVISION)
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

-- 24.TYPE TAXES. Create a procedure to calculate the total of a bill depending on the type of the VAT (1=0%, 2=10%, 3=15%, other=20%). 
--The parameters will be price, quantity, type_tax. For example: EXEC TYPE_TAXES, 10,30,4
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


--25.Create a program to print a sentence depending on if the number of the customers from New York is bigger, equal, 
--or lower than the customers from California. Show the actual date at the end of the sentence.
create or alter procedure COMPARE_CUSTOMERS
as
BEGIN
	declare @num_NY as smallint, @num_CA as smallint
	select @num_NY=count(customer_id)
	from CUSTOMER 
	where state='NY'
	select @num_CA=count(customer_id)
	from CUSTOMER 
	where state='CA'
	
	if @num_NY>@num_CA
		begin
			print 'there are more customers from New York than from California -- '+ cast(getdate()as varchar)
		end
	else if @num_NY=@num_CA
		begin
			print 'there are equal number of customers from New York as from California -- '+ cast(gatdate() as varchar
		end
	else
END
--26.EMPLOYEE_ORDERS. Create a procedure to compare the total orders of the employees given as parameters.
--For example: EXEC EMPLOYEE_ORDERS 'Genna', 'Mireya'.
--27.COMPARE_CITIES. Create a procedure to compare the cities of the customers given as parameters.
--For example: EXEC COMPARE_CITIES 'Cyndi Dyer', 'Sam Lester'
--29. BILLS_HIGHER_THAN. Create a procedure to show a list of the bills which exceeded the amount given as a parameter.

create or alter procedure BILLS_HIGHER_THAN @total as money
as
BEGIN
	declare @list varchar(max)
	set @list=''

	print ' NUM_ORDER    DATE    CLIENTE    TOTAL BILL'
	print '============================================'

	select @list=@list+space(4)+cast(ORDERS.order_id  as char)(7)+
			cast(order_date as char(12))+
			cast(fist_name+' '+last_name as char(20))+
			cast(cast (sum (list_price*quantity*(1-discount)) as decimal(10,2))) as varchar)+char(10)
	from ORDERS, ORDER_ITEM, CUSTOMER
	where ORDERS.order_id=ORDER_ITEM.order_id
		AND ORDER_ITEM.customer_id=CUSTOMER.customer_id
	group by ORDER.order_id, order_date, fist_name, last_name
	having sum(list_price*quantity*(1-discount))>@total
	print @list
END
--exec BILLS_HIGHER_THAM 25000

--30.Create a list to display the customers from Brazil.
declare @list varchar(max)=''

select @list=@list

--32.INSERT_NEW_PROVINCE. Create a procedure to insert a new province checking if the province had been previously added.
create or alter procedure INSERT_NEW_PROVINCE @province varchar(20)
as 
begin
	if exists(select nameprovince from province where NameProvince=@province)
	begin 
	print 'The province ' + @province+' is already in the database'
	return
	end
	insert into province value (@province)
	print 'The province ' + @province+' has been added'
	end
	--exc INSERT_NEW_PROVINCE 'Murcia'
	select * from province

--40.SHOW BILL. Create a procedure to display the bill for a customer, order and date given as parameters.
create or alter procedure BILL
@customerid int, @orderid int, @orderdate date
AS
BEGIN
	declare @customername varchar(80)

	select @customername=CONCAT(first_name, ' ', last_name)
	from CUSTOMER
	where customer_id=@customername

	if @customername is NULL
		begin 
		print 'the customer id is wrong'
		return
	end
	print @customername+space(5)+c
END

--exec BILL 1480, 10, '10/10/2025'
--select*ftom customer
