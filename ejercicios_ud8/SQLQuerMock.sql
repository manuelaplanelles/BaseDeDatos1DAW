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
	declare @orderID char(5)
	declare @nameEmployee varchar(40)
	declare @subtotal money
	declare @vat money
	declare @total money
	declare @list varchar(max)=''
	
	declare cursor_bills cursor

	for select OrderID, OrderDate, NameEmployee, NameClient
		from ORDERS, EMPLOYEE, CLIENT 
		where ORDERS.EmployeeID=EMPLOYEE.EmployeeID
			and ORDERS.OrderID=CLIENT.ClientID
			and Year(OrderDate)=@year
			and Month(OrderDate)=@month
		
			
		
	open cursor_bills
	fetch next from cursor_bills into 

	while @@FETCH_STATUS=0
		begin
			

			fetch next from cursor_bills into 
		end
	close cursor_bills
	deallocate cursor_bills

end
-- exec BILLS_MONTH 3 ,'2025' 