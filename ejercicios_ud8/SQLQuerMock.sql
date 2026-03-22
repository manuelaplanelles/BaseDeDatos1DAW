-- create database TITAN_HARDWARE 
-- 1. 
create or alter procedure WORK_EMPLOYEE_MONTH (@month char(2), @year char(4))
as begin
	declare @nameEmpl varchar(40)
	declare @idEmpl char(5)
	declare @list varchar(max)=''
	
	declare cursor_numcomputers cursor

	for select NameEmployee, EMPLOYEE.EmployeeID
		from EMPLOYEE, WORK_ORDERS
		where EMPLOYEE.EmployeeID=WORK_ORDERS.EmployeeID
			and Year(DateAssembly)=@year
			and Month(DateAssembly)=@month
		group by NameEmployee, EMPLOYEE.EmployeeID,DateAssembly
			
		
	open cursor_numcomputers
	fetch next from cursor_numcomputers into @nameEmpl, @idEmpl

	while @@FETCH_STATUS=0
		begin
			print 'Employee: '+@nameEmpl
			print space(5)+'Product'+space(5)+'Units Assembled'
			print space(5)+replicate('=',30)

			select @list=@list + space(5)+ 
				cast(Category as char(20))+ cast(sum(WORK_ORDERS.Quantity)as varchar)+char(10)
			from PRODUCT, EMPLOYEE, WORK_ORDERS
			where PRODUCT.ProductID=WORK_ORDERS.ProductID
				and WORK_ORDERS.EmployeeID=EMPLOYEE.EmployeeID
				and EMPLOYEE.EmployeeID=@idEmpl
			group by Category, WORK_ORDERS.Quantity
			order by Category
			print @list
			fetch next from cursor_numcomputers into @nameEmpl, @idEmpl
		end
	close cursor_numcomputers
	deallocate cursor_numcomputers

end
-- exec WORK_EMPLOYEE_MONTH 3 ,'2025'

-- 2.
create or alter procedure BILLS_MONTH (@month char(2), @year char(4))
as begin
	declare @orderID char(5), @clientID char(10), @employId char(5), @orderDate date
	declare @nameEmployee varchar(40), @nameClient varchar(80)
	declare @subtotal money,@vat money,@total money
	declare @list varchar(max)=''
	
	declare cursor_bills cursor

	for select OrderID, ClientID, OrderDate, EmployeeID
		from ORDERS 
		where Year(OrderDate)=@year and Month(OrderDate)=@month
					
		
	open cursor_bills
	fetch next from cursor_bills into @orderID, @clientID, @orderDate, @employId

	while @@FETCH_STATUS=0
		begin
			select @nameClient=NameClient
			from CLIENT
			where ClientID=@clientID

			select @nameEmployee=NameEmployee
			from EMPLOYEE
			where EmployeeID=@employId

			select @subtotal=sum(unitPrice*Quantity) 
			from ORDER_DETAILS
			where OrderID=@orderID
			group by OrderID

			set @vat = @subtotal*0.21
			set @total = @subtotal+@vat

			print replicate('*',50)
			print 'Order: '+@orderID+space(15)+'Date: '+cast(@orderDate as char(12))
			print 'Employee: '+ @nameEmployee
			print 'Client: '+@nameClient
			print 'PRODUCT'+space(12)+'CATEGORY'+space(5)+'QUANTITY'+space(5)+'PRICE'
			print replicate('-',50)

			select @list=@list + cast(NameProduct as char(18)) +
				cast(Category as char(15)) + cast(ORDER_DETAILS.Quantity as char(2))+ space(4)+
				cast(cast(sum(Price*ORDER_DETAILS.Quantity)as money)as char(10)) + char(10)
			from PRODUCT,ORDER_DETAILS
			where PRODUCT.ProductID=ORDER_DETAILS.ProductID
				and ORDER_DETAILS.OrderID=@orderID
			group by ORDER_DETAILS.Quantity, Price, Category, NameProduct
			print @list

			print space(27)+cast('Subtotal:'as char(12))+cast(cast(@subtotal as money) as char(10))
			print space(27)+cast('VAT 21%:'as char(12))+cast(cast(@vat as money)as char(10))
			print space(27)+cast('Total:'as char(12))+cast(cast(@total as money)as char(10))
			set @list=''
			
			fetch next from cursor_bills into @orderID, @clientID, @orderDate, @employId
		end
		close cursor_bills
		deallocate cursor_bills

end
-- exec BILLS_MONTH 3 ,'2025' 

--3. Create a procedure to display the products in stock for the category given as parameter.
create or alter procedure PRODUCT_IN_STOCK @category varchar(11)
as begin 
	declare @productID char(10), @nameProduct varchar(50)
	declare @price smallmoney
	declare @list varchar(max)=''
	
	declare cursor_productstock cursor
	for select ProductID, NameProduct, Price
		from PRODUCT
		where Category=@category
			and Quantity>0
			
	
	open cursor_productstock
	fetch next from cursor_productstock into @productId, @nameProduct, @price

	while @@FETCH_STATUS=0
		begin
			print @nameProduct+space(10)+cast(@price as char(10))+'€'
			print 'COMPONENTS:'
			select @list=@list+
				space(2)+cast(NamePart as char(12))+space(10)+
				cast(USE_PART.Quantity as char(3))+space(4)+
				cast(cast(RetailPrice as money)as char(10))+'€'+char(10)
			from PART, USE_PART
			where USE_PART.PartID=PART.PartID
				and USE_PART.ProductID=@productID

			order by NamePart
			print @list
			set @list=''
			print replicate('-', 50)

			fetch next from cursor_productstock into @productId, @nameProduct, @price
		end
		close cursor_productstock
		deallocate cursor_productstock
end


-- EXEC PRODUCT_IN_STOCK 'All-in-one' 'Workstation' 