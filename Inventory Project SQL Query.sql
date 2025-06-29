-- Inventory Project

create database Inventory_Project;

use inventory_project;

-- Create supplier table in inventory project database
create table Supplier (SID VARCHAR(10) primary key ,SNAME VARCHAR(50) not null ,SADD VARCHAR(100) NOT NULL ,
SCITY VARCHAR(30) DEFAULT( 'DELHI')  , SPHONE VARCHAR(15) UNIQUE , SEMAIL VARCHAR (50) );



-- Describe the supplier table 
exec sp_help 'supplier';

-- Insert data into supplier table 
insert into Supplier (SID ,SNAME, SADD, SPHONE , SEMAIL) 
values('S0001', 'GlobalTech Supplies', 'A-12, Connaught Place', '9876543210', 'globaltech@supplies.com'),
('S0002', 'NextGen Distributors', 'B-45, Nehru Place', '9812345678', 'nextgen@distributors.com'),
('S0003', 'Prime Wholesale', 'C-67, Karol Bagh', '9898989898', 'prime@wholesale.com'),
('S0004', 'Metro Logistics', 'D-89, Lajpat Nagar', '9123456780', 'metro@logistics.com'),
('S0005', 'Skyline Traders', 'E-10, Hauz Khas', '9988776655', 'skyline@traders.com');



-- To view the supplier table
select * from Supplier;


-- Create a product table
create table Product( PID varchar(10) primary key ,PDESC varchar (100) not null,PRICE decimal(10,2) check (price >0),
CATEGORY varchar(50) check (category in ( 'IT','HA','HC')),SID varchar(10) foreign key (sid) references supplier(sid));

-- Describe the product table 
exec sp_help 'product';

-- insert data into product table 
insert into  [Product] (PID, PDESC, PRICE, CATEGORY, SID) values
('P0001', 'Mouse Product', 250.00, 'IT', 'S0001'),
('P0002', 'Keyboard Product', 450.00, 'IT', 'S0002'),
('P0003', 'Monitor Product', 950.00, 'IT', 'S0002'),
('P0004', 'Fridge Product', 800.00, 'HA', 'S0004'),
('P0005', 'Iron Product', 300.00, 'HA', 'S0005'),
('P0006', 'Fan Product', 400.00, 'HA', 'S0005'),
('P0007', 'Shampoo Product', 150.00, 'HC', 'S0001'),
('P0008', 'Soap Product', 80.00, 'HC', 'S0001'),
('P0009', 'Toothpaste Product', 90.00, 'HC', 'S0005'),
('P0010', 'Trimmer Product', 550.00, 'HC', 'S0003');



-- To view the product table
select * from Product;


--create a cust table
create table cust (CID varchar(10) primary key ,CNAME varchar (40) not null ,ADDRESS VARCHAR(100) NOT NULL ,
CITY VARCHAR(50) NOT NULL , PHONE VARCHAR(10) NOT NULL ,EMAIL VARCHAR(50) NOT NULL ,DOB DATE CHECK(DOB < '2000-01-01'))


-- Describe the cust table 
exec sp_help 'Cust';

-- insert data into cust table
INSERT INTO CUST (CID, CNAME, ADDRESS, CITY, PHONE, EMAIL, DOB) VALUES
('C0001', 'Ravi Sharma', '45 A, Nehru Nagar', 'Delhi', '9876543210', 'rs987@rcg.com', '1990-04-12'),
('C0002', 'Priya Mehta', '21 B, Model Town', 'Delhi', '9823456781', 'pm781@rcg.com', '1985-11-03'),
('C0003', 'Amit Verma', '78, Rajouri Garden', 'Delhi', '9812345678', 'av678@rcg.com', '1992-07-25'),
('C0004', 'Nisha Kapoor', '12, Green Park', 'Delhi', '9898765432', 'nk432@rcg.com', '1993-09-14'),
('C0005', 'Sandeep Joshi', '9, Lajpat Nagar', 'Delhi', '9845632190', 'sj190@rcg.com', '1988-01-30');


-- To view the cust table
select * from cust;


--create a orders table
create table orders( OID varchar(20) not null ,ODATE date ,PID varchar(10) foreign key(pid) references product(PID),
CID varchar(10) foreign key (cid) references cust(cid),
OQTY int check (oqty >= 1));

-- Describe the orders table 
exec sp_help 'orders';

--insert data into orders table
INSERT INTO ORDERS (OID, ODATE, PID, CID, OQTY) VALUES
('O0001', '2024-04-10', 'P0001', 'C0001', 3),
('O0002', '2024-04-15', 'P0002', 'C0002', 1),
('O0003', '2024-04-18', 'P0003', 'C0003', 2),
('O0004', '2024-04-21', 'P0004', 'C0004', 4),
('O0005', '2024-04-25', 'P0005', 'C0005', 5);

-- To view the orders table
select * from orders;

--create a stock table
create table stock (PID varchar(10) foreign key references product(pid) ,SQTY int check (sqty >0),
ROL int check (rol >= 0),MOQ int check (moq >=5));

-- Describe the stock table 
exec sp_help 'stock';

--insert data into stock table
INSERT INTO STOCK (PID, SQTY, ROL, MOQ) VALUES
('P0001', 120, 20, 10),
('P0002', 80, 15, 5),
('P0003', 50, 10, 7),
('P0004', 200, 25, 15),
('P0005', 60, 12, 6),
('P0006', 140, 30, 10),
('P0007', 75, 10, 8),
('P0008', 90, 18, 12),
('P0009', 110, 22, 9),
('P0010', 130, 20, 10);

-- To view the stock table
select * from stock;

-- view all the tables of inventory project database
select * from INFORMATION_SCHEMA.tables


-- auto generate alphanumeric ids for supp,cust,prod,ord tables
-- create squences for all tables
create sequence seq_supplier as int 
start with 6
increment by 1 ;

create sequence seq_product as int
start with 11
increment by 1 ;

create sequence seq_cust as int 
start with 6
increment by 1;


create sequence seq_orders as int 
start with 6
increment by 1;

-- create procedure for auto generate alphanumeric ids and also insert data into supplier table through procedure
create procedure ins_supplier
@sname varchar(50) ,
@sadd varchar(100) , 
@sphone varchar(15) ,
@semail varchar (50)
as 
begin 
declare @numb int = next value for seq_supplier 
declare @id varchar(5)

--generate sid 
set @id = CONCAT( 'S' ,left('000' + CAST(@numb as varchar ) ,4) )

--insert data into supplier table 
insert into Supplier(SID,SNAME , sadd, SPHONE,SEMAIL)
values(@id ,@sname,@sadd,@sphone ,@semail )

--print message after inserted a row by user 
print 'inserted sid is ' + @id 
end ;

--excecute procedure with inserting data into supplier table
execute dbo.ins_supplier @sname = 'NeVep EXP',
@sadd = 'Secter-11 Dwarka',
@sphone ='8545145896',
@semail ='nevep@exp.com';

-- view the inserted data of supplier table
select * from Supplier;

-- create procedure for auto generate alphanumeric ids and also insert data into product through procedure
create procedure ins_product 
@Pdesc varchar(100) ,
@price decimal(10,2) ,
@category varchar(50) ,
@sid varchar(10)
as 
begin 
declare @numb int = next value for seq_product 
declare @id varchar(5)
set @id =CONCAT('P' , right('000' + cast(@numb as varchar),4))

insert into Product(pid,Pdesc,price ,category ,sid)
values(@id ,@Pdesc , @price,@category,@sid)

print 'inserted pid is '+ @id 
end;

--excecute procedure with inserting data into product table 
exec dbo.ins_product
@pdesc ='Bulb Product',
@price ='100' ,
@category = 'HA',
@sid ='S0006';


--view the inserted data of product table
select * from product;


-- create procedure for auto generate alphanumeric ids and also insert data into cust through procedure
create  procedure ins_cust
@cname varchar(40) ,
@address varchar(100) ,
@city varchar(50) ,
@phone varchar(10) ,
@email varchar(50) ,
@dob date 
as 
begin 
declare @numb int = next value for seq_cust 
declare @id varchar(5) 
set @id= CONCAT('C' , RIGHT('000' + cast(@numb as varchar ) ,4)) 

insert into cust (CID ,CNAME,ADDRESS,CITY ,PHONE ,EMAIL,DOB )
values (@id ,@cname ,@address,@city ,@phone ,@email,@dob ) 

print 'inserted cid is ' +@id 
end;

--excecute procedure with inserting data into cust table 
exec dbo.ins_cust 
@cname ='Rahul Kumar',
@address = '34 C,shaheed Nagar', 
@city = 'Delhi' ,
@phone= '7845865263',
@email = 'rk856@rcg.com',
@dob = '1994-04-22';


--view the inserted data of cust table 
select * from cust;

-- create procedure for auto generate alphanumeric ids and also insert data into orders through procedure 
create procedure ins_orders 
@odate date ,
@pid varchar(5),
@cid varchar(5) ,
@oqty int 
as 
begin
declare @numb int= next value for seq_orders 
declare @id varchar(5)

set @id = CONCAT('O' , right('000' + cast(@numb as varchar ) ,4))

insert into orders (OID ,ODATE,PID,CID,OQTY)
values(@id ,@odate,@pid,@cid ,@oqty) 

print 'inserted oid is '+@id 
end;

--excecute procedure with inserting data into orders table 
exec dbo.ins_orders 
@odate = '2024-04-29',
@pid = 'P0011',
@cid = 'C0006',
@oqty = 3;


--view the inserted data of orders table
select * from orders;


-- insert new data into stock table  
insert into stock (PID, SQTY,ROL,MOQ) 
values('P0011' ,50,15,10),('P0012', 100,20,25);


-- create a bill view
create view bill 
as 
select o.OID as Order_id, o.ODATE as Order_date ,c.CNAME as Customer_name,c.ADDRESS as Address, c.PHONE as Phone,
p.PDESC as Product_desc , p.PRICE as Price ,o.OQTY as Quantity ,p.price*o.oqty as Total_amount from orders o
inner join Product p 
on p.PID = o.pid
inner join cust c 
on c.CID = o.CID;

-- check bill for a specific customer
select * from bill 
where Customer_name ='Ravi sharma';

