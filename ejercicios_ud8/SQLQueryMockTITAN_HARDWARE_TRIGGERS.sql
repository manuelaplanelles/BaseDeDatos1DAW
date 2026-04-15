create database TITAN_HARDWARE_TRIGGERS
--1
create or alter trigger UPDATE_PART
on ORDERS_DETAILS_SUP
after INSERT
as begin
	declare @partID char (10)=(select PartID from inserted)
	declare @quantity int =(select Quantity from inserted)
	declare @unitPrice smallint =(select UnitPrice from inserted)

	update PART
	set Quantity = Quantity + @quantity, RetailPrice = @unitPrice * 1.20
	where PartID = @partID

end

--2
create or alter trigger SELL_PRODUCT
on ORDER_DETAILS
as begin
	declare @orederId char(5) =(select OrderID from inserted)
	declare @productID char(19) =(select ProducID from inserted)
	declare @quantity tinyint =(select Quantity from inserted)

	declare @price money =(select Price from PRODUCT where ProductID = @productID)

	update PRODUCT
	set Quantity = Quantity - @quantity
	where ProductID = @productID
	
	update ORDER_DETAILS
	set UnitPrice = @price
	where OrderID = @orederId and ProductID = @productID

	declare @employeeID char(5) = (select EmployeeID from ORDERS where OrderID=@orederId)
	declare @month date =(select month(OrderDate) from ORDER where OrderID=@orederId)
	declare @year date =(select year(OrderDate) from ORDER where OrderID=@orederId)
	declare @total smallint = @price * @quantity
	declare @bonus money = @total * 0.04

	if exists (select * from COMMISSION where EmployeeID = @employeeID and MonthCom = @month and YearCom = @year)
		update COMMISSION
		set Bonus = bonus + @bonus
		where EmployeeID = @employeeID and MonthCom = @month and YearCom = @year
	else
		insert into COMMISSION values (@year, @month, @employeeID, @bonus)

end
--3
create or alter trigger UPDATE_PRODUCTS_PARTS
on WORK_ORDERS
after insert
as begin
	declare @productId char(10) =(select ProductID from inserted)
	declare @quantity int =(select Quantity from inserted)

	UPDATE PRODUCT
	set Quantity=Quantity*@quantity
	where ProductID=@productId

	declare @partId char(10)
	declare @quantityUsed tinyint

	declare part_cursor cursor
	for select PartID, Quantity
		from USE_PART
		where ProductID=@productId

		open part_cursor
		fetch next from part_cursor into @partId, @quantityUsed

		while @@FETCH_STATUS=0
		begin
			update PART
			set Quantity=Quantity-@quantityUsed*@quantity
			where PartID=@partId
		end
		close part_cursor
		deallocate part_cursor

		update PART
		set Flag=1
		where Quantity*5

end
