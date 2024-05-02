------CREATING DATA BASE WITH THE NAME ECOMMERCE-SQL-CC--------------
CREATE DATABASE Ecommerce_SQL_CC


---USING THAT DATABASE---
USE [Ecommerce_SQL_CC]


---CREATING TABLE CUSTOMERS---
CREATE TABLE Customers(customer_id int primary key not null,
first_name varchar(50),
last_name varchar(50),
email varchar(60),
address varchar(100))


---CREATING TABLE PRODUCTS---
CREATE TABLE Products(product_id int primary key not null,
name varchar(50),
price int,
discription varchar(100),
stockQuantity int)


---CREATING TABLE CART---
CREATE TABLE Cart(cart_id int primary key not null,
customer_id int,
foreign key(customer_id) references Customers(customer_id),
product_id int,
foreign key(product_id) references Products(product_id),
quantity int)


---CREATING TABLE ORDERS---
CREATE TABLE Orders(order_id int  primary key not null,
customer_id int,
foreign key(customer_id) references Customers(customer_id),
order_date date,
total_price int)

--I HAVE DELETED AS I GAVE SAME VALUE FOR ID HERE AND THE FOLLOWING TABLE
drop table Orders





---CREATING TABLE ORDER_ITEMS---
CREATE TABLE Order_Items(order_item_id int primary key not null,
order_id int,
foreign key(order_id) references Orders(order_id),
product_id int,
foreign key(product_id) references Products(product_id),
quantity int)

---THIS COLUMN IS MISSING IN THE SCEAMA 
alter table Order_Items
add  Item_Amount int

--VIEW ALL THE TABLE---
SELECT * FROM Customers
SELECT * FROM Products
SELECT * FROM Cart
SELECT * FROM Orders
SELECT * FROM Order_Items


-----INSERTING THE VALUES IN TABLE PRODUCTS-----
INSERT INTO Products VALUES(300,'Laptop',800,'High-performance',10),
(301,'SmartPhonr',600,'Latest smartphone',15),
(302,'Tablet',300,'Portable tablet',20),
(303,'HeadPhones',150,'Noise-canceling',30),
(304,'TV',900,'4K Smart TV',5),
(305,'Coffee Maker',50,'Automatic coffee maker',25),
(306,'Refrigerator',700,'Energy-efficient',10),
(307,'Microwave Oven',80,'Countertop microwave',15),
(308,'Blender',70,'High-speed blender',20),
(309,'Vaccum Cleaner',120,'Bagless vacuum cleaner',10)

-----INSERTING THE VALUES IN TABLE CUSTOMERS-----
INSERT INTO Customers VALUES(400,'John','Doe','johndoe@email.com','chennai'),
(401,'Jane','Smith','janesmith@email.com','namakkal'),
(402,'Robert','Johnson','robert@email.com','chennai'),
(403,'Sarah','Brown','sarahbrown@email.com','chennai'),
(404,'David','Lee','davidlee@email.com','trichy'),
(405,'Laura','Hall','laurahall@email.com','chennai'),
(406,'Michael','Davis','michaeldavis@email.com','trichy'),
(407,'Emma','Wilson','emmawillson@email.com','chennai'),
(408,'William','Taylor','williamtaylor@email.com','chennai'),
(409,'Olivia','Adams','oliviaadams@email.com','namakkal')

alter table Customers
alter column last_name varchar(50)

-----INSERTING THE VALUES IN TABLE CART-----
INSERT INTO Cart VALUES(1,400,301,2),
(2,401,301,1),
(3,401,302,2),
(4,405,303,4),
(5,406,305,2),
(6,401,308,1),
(7,404,306,2),
(8,405,305,1),
(9,409,307,4),
(10,402,306,3)


-----INSERTING THE VALUES IN TABLE ORDERS-----
INSERT INTO Orders VALUES(1000,400,'2024-01-22',1200),
(1001,401,'2024-01-2',100),
(1002,401,'2024-02-20',600),
(1003,405,'2024-03-7',400),
(1004,406,'2024-02-2',200)



-----INSERTING THE VALUES IN TABLE ORDER_ITEMS-----
INSERT INTO Order_Items VALUES(100,1000,301,2,1200),
(101,1001,301,1,400),
(102,1002,302,2,600),
(103,1003,303,4,200),
(104,1004,304,2,300)



-----1. Update refrigerator product price to 800. 
UPDATE Products
SET price = 800
WHERE name='Refrigerator'


-----2. Remove all cart items for a specific customer. 
DELETE FROM Cart
WHERE customer_id=401


-----3. Retrieve Products Priced Below $100. 
SELECT product_id
FROM Products
WHERE price<100


-----4. Find Products with Stock Quantity Greater Than 5.
SELECT *
FROM Products
WHERE stockQuantity > 5

-----5. Retrieve Orders with Total Amount Between $500 and $1000. 
SELECT *
FROM Orders
WHERE total_price BETWEEN 500 AND 1000


-----6. Find Products which name end with letter ‘r’. 
SELECT *
FROM Products
WHERE name LIKE '%r'

-----7. Retrieve Cart Items for Customer 5. 
SELECT *
FROM Cart
WHERE customer_id = 406

-----8. Find Customers Who Placed Orders in 2023. 
SELECT DISTINCT C.customer_id,C.first_name,C.last_name,O.order_date
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
WHERE YEAR(O.order_date) = 2023

--AS I HAVE NOT INSERTED ANY ROWS IN THE YEAR 2023
update Orders
set order_date = '2023-04-2'
where customer_id=400

-----9. Determine the Minimum Stock Quantity for Each Product Category.------!!
SELECT product_id,MIN(stockQuantity) as min_value
From Products
GROUP BY product_id


-----10. Calculate the Total Amount Spent by Each Customer. 
SELECT O.total_price,C.customer_id
from Orders O
join Customers C on C.customer_id=O.customer_id


-----11. Find the Average Order Amount for Each Customer. 
SELECT C.customer_id,
C.first_name AS customer_name,
AVG(O.total_price) AS average_order_amount
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
GROUP BY C.customer_id, C.first_name

-----12. Count the Number of Orders Placed by Each Customer.
SELECT C.customer_id,
C.first_name AS customer_name,
COUNT(O.order_id) AS order_count
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
GROUP BY C.customer_id, C.first_name

-----13. Find the Maximum Order Amount for Each Customer. 
SELECT C.customer_id,
MAX(O.total_price) AS max_order_amount
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
GROUP BY C.customer_id

-----14. Get Customers Who Placed Orders Totaling Over $1000. 
SELECT DISTINCT C.customer_id,
C.first_name AS customer_name
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
WHERE O.total_price > 1000


-----15. Subquery to Find Products Not in the Cart. 
SELECT *
FROM Products
WHERE product_id NOT IN 
( SELECT DISTINCT product_id
FROM Cart )


-----16. Subquery to Find Customers Who Haven't Placed Orders.
SELECT *
FROM Customers
WHERE customer_id NOT IN 
( SELECT DISTINCT customer_id
FROM Orders )



-----17. Subquery to Calculate the Percentage of Total Revenue for a Product.
SELECT P.product_id,
P.name,
P.price,
(SUM(O.total_price) / (SELECT SUM(total_price) FROM Orders)) * 100 AS percentage
FROM Products P
JOIN Order_Items OI ON P.product_id = OI.product_id
JOIN Orders O ON OI.order_id = O.order_id
GROUP BY P.product_id, P.name, P.price


-----18. Subquery to Find Products with Low Stock. 
SELECT *
FROM Products
WHERE stockQuantity < 
( SELECT AVG(stockQuantity)  
 FROM Products )

-----19. Subquery to Find Customers Who Placed High-Value Orders. 
SELECT DISTINCT customer_id
FROM Orders
WHERE order_id IN 
(SELECT top 1 order_id
FROM Orders
order by total_price  )

