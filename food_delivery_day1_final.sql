-- =========================================================
-- FOOD DELIVERY DATABASE
-- COMPLETE DDL + DML PRACTICAL
-- =========================================================

-- =========================================================
-- 1. DATABASE CREATION
-- =========================================================

DROP DATABASE IF EXISTS food_delivery_app;

CREATE DATABASE food_delivery_app;

USE food_delivery_app;


-- =========================================================
-- 2. CUSTOMER TABLE
-- =========================================================

CREATE TABLE Customer (
    customer_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE,
    street VARCHAR(100),
    city VARCHAR(50) DEFAULT 'Pune',
    pincode VARCHAR(10),

    CONSTRAINT chk_customer_phone
    CHECK (LENGTH(phone) >= 10)
);


-- =========================================================
-- 3. RESTAURANT TABLE
-- =========================================================

CREATE TABLE Restaurant (
    restaurant_id VARCHAR(10) PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    location VARCHAR(100) NOT NULL
);


-- =========================================================
-- 4. MENU ITEM TABLE
-- =========================================================

CREATE TABLE Menu_Item (
    item_id VARCHAR(10) PRIMARY KEY,
    restaurant_id VARCHAR(10) NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    category VARCHAR(50),

    CONSTRAINT fk_menu_restaurant
    FOREIGN KEY (restaurant_id)
    REFERENCES Restaurant(restaurant_id),

    CONSTRAINT chk_menu_price
    CHECK (price > 0)
);


-- =========================================================
-- 5. ORDERS TABLE
-- =========================================================

CREATE TABLE Orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    restaurant_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Placed',
    total_amount DECIMAL(8,2),

    CONSTRAINT fk_order_customer
    FOREIGN KEY (customer_id)
    REFERENCES Customer(customer_id),

    CONSTRAINT fk_order_restaurant
    FOREIGN KEY (restaurant_id)
    REFERENCES Restaurant(restaurant_id),

    CONSTRAINT chk_order_amount
    CHECK (total_amount >= 0),

    CONSTRAINT chk_order_status
    CHECK (
        status IN (
            'Placed',
            'Preparing',
            'Out for Delivery',
            'Delivered',
            'Cancelled'
        )
    )
);


-- =========================================================
-- 6. ORDER ITEM TABLE
-- =========================================================

CREATE TABLE Order_Item (
    order_id VARCHAR(10),
    item_id VARCHAR(10),
    quantity INT NOT NULL,
    item_price DECIMAL(8,2) NOT NULL,

    PRIMARY KEY (order_id, item_id),

    CONSTRAINT fk_orderitem_order
    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id)
    ON DELETE CASCADE,

    CONSTRAINT fk_orderitem_item
    FOREIGN KEY (item_id)
    REFERENCES Menu_Item(item_id),

    CONSTRAINT chk_orderitem_quantity
    CHECK (quantity > 0),

    CONSTRAINT chk_orderitem_price
    CHECK (item_price > 0)
);


-- =========================================================
-- 7. PAYMENT TABLE
-- =========================================================

CREATE TABLE Payment (
    payment_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10) NOT NULL UNIQUE,
    payment_method VARCHAR(20),
    payment_status VARCHAR(20),

    CONSTRAINT fk_payment_order
    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    CONSTRAINT chk_payment_method
    CHECK (payment_method IN ('UPI', 'Cash', 'Card')),

    CONSTRAINT chk_payment_status
    CHECK (
        payment_status IN (
            'Successful',
            'Pending',
            'Refunded'
        )
    )
);


-- =========================================================
-- 8. DELIVERY TABLE
-- =========================================================

CREATE TABLE Delivery (
    delivery_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10) NOT NULL UNIQUE,
    delivery_person VARCHAR(100),
    delivery_status VARCHAR(20),

    CONSTRAINT fk_delivery_order
    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    CONSTRAINT chk_delivery_status
    CHECK (
        delivery_status IN (
            'Preparing',
            'Out for Delivery',
            'Delivered',
            'Cancelled'
        )
    )
);


-- =========================================================
-- DML SECTION
-- =========================================================


-- =========================================================
-- 9. INSERT 20 CUSTOMERS
-- =========================================================

INSERT INTO Customer
(customer_id, name, phone, email, street, city, pincode)
VALUES
('C101','Rahul','9876543210','rahul@example.com','12 MG Road','Pune','411001'),
('C102','Anjali','9876543211','anjali@example.com','45 FC Road','Pune','411004'),
('C103','Amit','9876543212','amit@example.com','22 JM Road','Pune','411005'),
('C104','Priya','9876543213','priya@example.com','18 Kothrud Road','Pune','411038'),
('C105','Rohan','9876543214','rohan@example.com','10 Baner Road','Pune','411045'),
('C106','Sneha','9876543215','sneha@example.com','32 Aundh Road','Pune','411007'),
('C107','Karan','9876543216','karan@example.com','15 Hadapsar Road','Pune','411028'),
('C108','Neha','9876543217','neha@example.com','27 Viman Nagar','Pune','411014'),
('C109','Arjun','9876543218','arjun@example.com','19 Wakad Road','Pune','411057'),
('C110','Pooja','9876543219','pooja@example.com','8 Shivaji Nagar','Pune','411005'),
('C111','Vikas','9876543220','vikas@example.com','25 Camp Area','Pune','411001'),
('C112','Kavya','9876543221','kavya@example.com','14 Karve Road','Pune','411004'),
('C113','Nikhil','9876543222','nikhil@example.com','31 Koregaon Park','Pune','411001'),
('C114','Meera','9876543223','meera@example.com','42 Katraj Road','Pune','411046'),
('C115','Aditya','9876543224','aditya@example.com','16 Pashan Road','Pune','411021'),
('C116','Simran','9876543225','simran@example.com','20 Sinhagad Road','Pune','411051'),
('C117','Varun','9876543226','varun@example.com','11 Magarpatta','Pune','411013'),
('C118','Riya','9876543227','riya@example.com','29 Kalyani Nagar','Pune','411006'),
('C119','Sahil','9876543228','sahil@example.com','7 Deccan Road','Pune','411004'),
('C120','Isha','9876543229','isha@example.com','35 Bibwewadi Road','Pune','411037');


-- =========================================================
-- 10. INSERT 20 RESTAURANTS
-- =========================================================

INSERT INTO Restaurant
(restaurant_id, restaurant_name, phone, location)
VALUES
('R101','Food Corner','9822011111','Pune'),
('R102','Spice Hub','9822022222','Katraj'),
('R103','Pizza Palace','9822033333','Kothrud'),
('R104','Burger House','9822044444','Baner'),
('R105','Biryani Point','9822055555','Hadapsar'),
('R106','South Indian Cafe','9822066666','Aundh'),
('R107','Chinese Wok','9822077777','Viman Nagar'),
('R108','Sweet Treats','9822088888','Shivaji Nagar'),
('R109','Tandoori Nights','9822099999','Wakad'),
('R110','Healthy Bites','9822100000','Pashan'),
('R111','Cafe Delight','9822111111','Camp'),
('R112','Royal Kitchen','9822122222','Koregaon Park'),
('R113','Punjabi Rasoi','9822133333','Karve Nagar'),
('R114','Italian Hub','9822144444','Magarpatta'),
('R115','Street Food Co','9822155555','Deccan'),
('R116','Dosa Corner','9822166666','Sinhagad Road'),
('R117','Maharashtra Kitchen','9822177777','Kalyani Nagar'),
('R118','Rolls Express','9822188888','Bibwewadi'),
('R119','The Food Station','9822199999','Vishrantwadi'),
('R120','Tasty Meals','9822200000','Kharadi');


-- =========================================================
-- 11. INSERT 20 MENU ITEMS
-- =========================================================

INSERT INTO Menu_Item
(item_id, restaurant_id, item_name, price, category)
VALUES
('M101','R101','Veg Burger',120,'Fast Food'),
('M102','R101','French Fries',80,'Fast Food'),
('M103','R102','Paneer Biryani',220,'Main Course'),
('M104','R102','Butter Chicken',280,'Main Course'),
('M105','R103','Margherita Pizza',250,'Pizza'),
('M106','R103','Farmhouse Pizza',320,'Pizza'),
('M107','R104','Cheese Burger',180,'Fast Food'),
('M108','R104','Veg Sandwich',130,'Fast Food'),
('M109','R105','Chicken Biryani',260,'Main Course'),
('M110','R105','Veg Biryani',200,'Main Course'),
('M111','R106','Masala Dosa',100,'South Indian'),
('M112','R106','Idli Sambar',80,'South Indian'),
('M113','R107','Veg Noodles',150,'Chinese'),
('M114','R107','Manchurian',170,'Chinese'),
('M115','R108','Gulab Jamun',90,'Dessert'),
('M116','R108','Chocolate Cake',150,'Dessert'),
('M117','R109','Paneer Tikka',220,'Starter'),
('M118','R110','Veg Salad',140,'Healthy Food'),
('M119','R111','Cold Coffee',110,'Beverage'),
('M120','R112','Dal Tadka',160,'Main Course');


-- =========================================================
-- 12. INSERT 20 ORDERS
-- =========================================================

INSERT INTO Orders
(order_id, customer_id, restaurant_id, order_date, status, total_amount)
VALUES
('O101','C101','R101','2026-08-10','Delivered',200),
('O102','C102','R102','2026-08-11','Preparing',220),
('O103','C103','R103','2026-08-12','Delivered',250),
('O104','C104','R104','2026-08-13','Placed',180),
('O105','C105','R105','2026-08-14','Delivered',260),
('O106','C106','R106','2026-08-15','Preparing',100),
('O107','C107','R107','2026-08-16','Delivered',150),
('O108','C108','R108','2026-08-17','Cancelled',90),
('O109','C109','R109','2026-08-18','Out for Delivery',220),
('O110','C110','R110','2026-08-19','Delivered',140),
('O111','C111','R111','2026-08-20','Placed',110),
('O112','C112','R112','2026-08-21','Preparing',160),
('O113','C113','R112','2026-08-22','Delivered',300),
('O114','C114','R103','2026-08-23','Out for Delivery',320),
('O115','C115','R104','2026-08-24','Delivered',130),
('O116','C116','R106','2026-08-25','Preparing',100),
('O117','C117','R112','2026-08-26','Placed',180),
('O118','C118','R105','2026-08-27','Delivered',200),
('O119','C119','R107','2026-08-28','Out for Delivery',150),
('O120','C120','R112','2026-08-29','Delivered',160);


-- =========================================================
-- 13. INSERT 20 ORDER ITEMS
-- =========================================================

INSERT INTO Order_Item
(order_id, item_id, quantity, item_price)
VALUES
('O101','M101',1,120),
('O102','M103',1,220),
('O103','M105',1,250),
('O104','M107',1,180),
('O105','M109',1,260),
('O106','M111',1,100),
('O107','M113',1,150),
('O108','M115',1,90),
('O109','M117',1,220),
('O110','M118',1,140),
('O111','M119',1,110),
('O112','M120',1,160),
('O113','M103',1,220),
('O114','M106',1,320),
('O115','M108',1,130),
('O116','M111',1,100),
('O117','M120',1,160),
('O118','M110',1,200),
('O119','M113',1,150),
('O120','M120',1,160);


-- =========================================================
-- 14. INSERT 20 PAYMENTS
-- =========================================================

INSERT INTO Payment
(payment_id, order_id, payment_method, payment_status)
VALUES
('P101','O101','UPI','Successful'),
('P102','O102','Cash','Pending'),
('P103','O103','Card','Successful'),
('P104','O104','UPI','Pending'),
('P105','O105','Card','Successful'),
('P106','O106','Cash','Pending'),
('P107','O107','UPI','Successful'),
('P108','O108','Card','Refunded'),
('P109','O109','UPI','Successful'),
('P110','O110','Cash','Successful'),
('P111','O111','UPI','Pending'),
('P112','O112','Card','Successful'),
('P113','O113','UPI','Successful'),
('P114','O114','Card','Successful'),
('P115','O115','Cash','Successful'),
('P116','O116','UPI','Pending'),
('P117','O117','Card','Pending'),
('P118','O118','UPI','Successful'),
('P119','O119','Cash','Successful'),
('P120','O120','UPI','Successful');


-- =========================================================
-- 15. INSERT 20 DELIVERIES
-- =========================================================

INSERT INTO Delivery
(delivery_id, order_id, delivery_person, delivery_status)
VALUES
('D101','O101','Amit','Delivered'),
('D102','O102','Rohit','Out for Delivery'),
('D103','O103','Suresh','Delivered'),
('D104','O104','Vijay','Preparing'),
('D105','O105','Manoj','Delivered'),
('D106','O106','Akash','Preparing'),
('D107','O107','Raj','Delivered'),
('D108','O108','Kunal','Cancelled'),
('D109','O109','Deepak','Out for Delivery'),
('D110','O110','Nitin','Delivered'),
('D111','O111','Arun','Preparing'),
('D112','O112','Ravi','Preparing'),
('D113','O113','Mohan','Delivered'),
('D114','O114','Sachin','Out for Delivery'),
('D115','O115','Varun','Delivered'),
('D116','O116','Sameer','Preparing'),
('D117','O117','Harish','Preparing'),
('D118','O118','Vishal','Delivered'),
('D119','O119','Gaurav','Out for Delivery'),
('D120','O120','Prakash','Delivered');


-- =========================================================
-- ALTER TABLE OPERATIONS
-- =========================================================


-- =========================================================
-- 16. ADD COLUMN
-- =========================================================

ALTER TABLE Customer
ADD age INT;


-- =========================================================
-- 17. INSERT 20 VALUES INTO NEW AGE COLUMN
-- =========================================================

UPDATE Customer SET age = 20 WHERE customer_id = 'C101';
UPDATE Customer SET age = 21 WHERE customer_id = 'C102';
UPDATE Customer SET age = 22 WHERE customer_id = 'C103';
UPDATE Customer SET age = 23 WHERE customer_id = 'C104';
UPDATE Customer SET age = 24 WHERE customer_id = 'C105';
UPDATE Customer SET age = 25 WHERE customer_id = 'C106';
UPDATE Customer SET age = 21 WHERE customer_id = 'C107';
UPDATE Customer SET age = 22 WHERE customer_id = 'C108';
UPDATE Customer SET age = 23 WHERE customer_id = 'C109';
UPDATE Customer SET age = 24 WHERE customer_id = 'C110';
UPDATE Customer SET age = 25 WHERE customer_id = 'C111';
UPDATE Customer SET age = 20 WHERE customer_id = 'C112';
UPDATE Customer SET age = 21 WHERE customer_id = 'C113';
UPDATE Customer SET age = 22 WHERE customer_id = 'C114';
UPDATE Customer SET age = 23 WHERE customer_id = 'C115';
UPDATE Customer SET age = 24 WHERE customer_id = 'C116';
UPDATE Customer SET age = 25 WHERE customer_id = 'C117';
UPDATE Customer SET age = 20 WHERE customer_id = 'C118';
UPDATE Customer SET age = 21 WHERE customer_id = 'C119';
UPDATE Customer SET age = 22 WHERE customer_id = 'C120';


-- =========================================================
-- 18. MODIFY COLUMN
-- =========================================================
-- NOW there are NO NULL values, so this will work.

ALTER TABLE Customer
MODIFY age INT NOT NULL;


-- =========================================================
-- 19. ADD CONSTRAINT
-- =========================================================

ALTER TABLE Customer
ADD CONSTRAINT chk_customer_age
CHECK (age >= 0);


-- =========================================================
-- 20. UPDATE DML
-- =========================================================

UPDATE Customer
SET city = 'Mumbai'
WHERE customer_id = 'C101';


UPDATE Orders
SET status = 'Delivered'
WHERE order_id = 'O104';


-- =========================================================
-- 21. ADD ANOTHER COLUMN
-- =========================================================

ALTER TABLE Customer
ADD alternate_phone VARCHAR(15);


-- =========================================================
-- 22. INSERT/UPDATE VALUES IN NEW COLUMN
-- =========================================================

UPDATE Customer
SET alternate_phone = '9000000001'
WHERE customer_id = 'C101';

UPDATE Customer
SET alternate_phone = '9000000002'
WHERE customer_id = 'C102';

UPDATE Customer
SET alternate_phone = '9000000003'
WHERE customer_id = 'C103';

UPDATE Customer
SET alternate_phone = '9000000004'
WHERE customer_id = 'C104';

UPDATE Customer
SET alternate_phone = '9000000005'
WHERE customer_id = 'C105';

UPDATE Customer
SET alternate_phone = '9000000006'
WHERE customer_id = 'C106';

UPDATE Customer
SET alternate_phone = '9000000007'
WHERE customer_id = 'C107';

UPDATE Customer
SET alternate_phone = '9000000008'
WHERE customer_id = 'C108';

UPDATE Customer
SET alternate_phone = '9000000009'
WHERE customer_id = 'C109';

UPDATE Customer
SET alternate_phone = '9000000010'
WHERE customer_id = 'C110';

UPDATE Customer
SET alternate_phone = '9000000011'
WHERE customer_id = 'C111';

UPDATE Customer
SET alternate_phone = '9000000012'
WHERE customer_id = 'C112';

UPDATE Customer
SET alternate_phone = '9000000013'
WHERE customer_id = 'C113';

UPDATE Customer
SET alternate_phone = '9000000014'
WHERE customer_id = 'C114';

UPDATE Customer
SET alternate_phone = '9000000015'
WHERE customer_id = 'C115';

UPDATE Customer
SET alternate_phone = '9000000016'
WHERE customer_id = 'C116';

UPDATE Customer
SET alternate_phone = '9000000017'
WHERE customer_id = 'C117';

UPDATE Customer
SET alternate_phone = '9000000018'
WHERE customer_id = 'C118';

UPDATE Customer
SET alternate_phone = '9000000019'
WHERE customer_id = 'C119';

UPDATE Customer
SET alternate_phone = '9000000020'
WHERE customer_id = 'C120';


-- =========================================================
-- 23. MODIFY ALTERNATE PHONE
-- =========================================================

ALTER TABLE Customer
MODIFY alternate_phone VARCHAR(20);


-- =========================================================
-- 24. ADD UNIQUE CONSTRAINT
-- =========================================================

ALTER TABLE Customer
ADD CONSTRAINT unique_alternate_phone
UNIQUE (alternate_phone);


-- =========================================================
-- 25. DROP CONSTRAINT
-- =========================================================

ALTER TABLE Customer
DROP CONSTRAINT unique_alternate_phone;


-- =========================================================
-- 26. DROP COLUMN
-- =========================================================

ALTER TABLE Customer
DROP COLUMN alternate_phone;


-- =========================================================
-- 27. DELETE DML
-- =========================================================
-- Delete one delivery record

DELETE FROM Delivery
WHERE delivery_id = 'D108';


-- =========================================================
-- 28. FINAL SELECT QUERIES
-- =========================================================

SELECT * FROM Customer;

SELECT * FROM Restaurant;

SELECT * FROM Menu_Item;

SELECT * FROM Orders;

SELECT * FROM Order_Item;

SELECT * FROM Payment;

SELECT * FROM Delivery;
-- =========================================================
-- EXPERIMENT 06
-- AGGREGATE FUNCTIONS + JOIN
-- =========================================================

USE food_delivery_app;


-- =========================================================
-- PART A: AGGREGATE FUNCTIONS
-- =========================================================

-- 1. COUNT
SELECT COUNT(*) AS total_customers
FROM Customer;


-- 2. SUM
SELECT SUM(total_amount) AS total_sales
FROM Orders;


-- 3. AVG
SELECT AVG(total_amount) AS average_order_amount
FROM Orders;


-- 4. MAX
SELECT MAX(total_amount) AS highest_order_amount
FROM Orders;


-- 5. MIN
SELECT MIN(total_amount) AS lowest_order_amount
FROM Orders;


-- 6. ALL AGGREGATE FUNCTIONS TOGETHER
SELECT
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS average_order,
    MAX(total_amount) AS highest_order,
    MIN(total_amount) AS lowest_order
FROM Orders;


-- 7. GROUP BY + COUNT
SELECT
    status,
    COUNT(*) AS number_of_orders
FROM Orders
GROUP BY status;


-- =========================================================
-- PART B: JOIN OPERATIONS
-- =========================================================


-- 8. INNER JOIN
-- Display customer name and their orders

SELECT
    Customer.customer_id,
    Customer.name,
    Orders.order_id,
    Orders.order_date,
    Orders.status,
    Orders.total_amount
FROM Customer
INNER JOIN Orders
ON Customer.customer_id = Orders.customer_id;


-- 9. INNER JOIN
-- Display restaurant and its menu items

SELECT
    Restaurant.restaurant_name,
    Menu_Item.item_name,
    Menu_Item.price,
    Menu_Item.category
FROM Restaurant
INNER JOIN Menu_Item
ON Restaurant.restaurant_id = Menu_Item.restaurant_id;


-- 10. THREE TABLE JOIN
-- Customer + Orders + Restaurant

SELECT
    Customer.name,
    Orders.order_id,
    Restaurant.restaurant_name,
    Orders.order_date,
    Orders.total_amount
FROM Customer
INNER JOIN Orders
ON Customer.customer_id = Orders.customer_id
INNER JOIN Restaurant
ON Orders.restaurant_id = Restaurant.restaurant_id;


-- 11. LEFT JOIN
-- Show all customers and their orders

SELECT
    Customer.name,
    Orders.order_id,
    Orders.status,
    Orders.total_amount
FROM Customer
LEFT JOIN Orders
ON Customer.customer_id = Orders.customer_id;


-- 12. RIGHT JOIN
-- Show all restaurants and their menu items

SELECT
    Restaurant.restaurant_name,
    Menu_Item.item_name,
    Menu_Item.price
FROM Restaurant
RIGHT JOIN Menu_Item
ON Restaurant.restaurant_id = Menu_Item.restaurant_id;


-- 13. JOIN + AGGREGATE FUNCTION
-- Total sales for each restaurant

SELECT
    Restaurant.restaurant_name,
    SUM(Orders.total_amount) AS total_sales
FROM Restaurant
INNER JOIN Orders
ON Restaurant.restaurant_id = Orders.restaurant_id
GROUP BY Restaurant.restaurant_name;


-- 14. JOIN + COUNT
-- Number of orders for each restaurant

SELECT
    Restaurant.restaurant_name,
    COUNT(Orders.order_id) AS total_orders
FROM Restaurant
INNER JOIN Orders
ON Restaurant.restaurant_id = Orders.restaurant_id
GROUP BY Restaurant.restaurant_name;
-- =========================================================
-- EXPERIMENT 07 : VIEW
-- =========================================================

USE food_delivery_app;


-- 1. Remove the view if it already exists
DROP VIEW IF EXISTS Customer_Order_View;

CREATE VIEW Customer_Order_View AS
SELECT
    c.customer_id,
    c.name,
    o.order_id,
    o.order_date,
    o.status,
    o.total_amount
FROM Customer c
INNER JOIN Orders o
ON c.customer_id = o.customer_id;

-- 3. Display the View
SELECT *
FROM Customer_Order_View;


-- 4. Display only Delivered Orders
SELECT *
FROM Customer_Order_View
WHERE status = 'Delivered';


-- 5. Display selected columns from View
SELECT
    name,
    order_id,
    total_amount
FROM Customer_Order_View;


-- 6. Show all Views in the Database
SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';


-- =========================================
-- EXPERIMENT 08: DECISION STUDY
-- FOOD DELIVERY PLATFORM
-- =========================================

USE food_delivery_app;

-- 1. Restaurant with highest delivered revenue

SELECT r.restaurant_name,
       SUM(o.total_amount) AS revenue
FROM Restaurant r
JOIN Orders o
ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY revenue DESC;


-- 2. Most popular food items

SELECT m.item_name,
       SUM(oi.quantity) AS total_ordered
FROM Order_Item oi
JOIN Menu_Item m
ON oi.item_id = m.item_id
JOIN Orders o
ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY m.item_id, m.item_name
ORDER BY total_ordered DESC;


-- 3. Top 5 customers by spending

SELECT c.customer_id, c.name,
       SUM(o.total_amount) AS total_spent
FROM Customer c
JOIN Orders o
ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 5;


-- 4. Payment status analysis

SELECT payment_status,
       COUNT(*) AS total_payments
FROM Payment
GROUP BY payment_status;


-- 5. Restaurants without orders

SELECT r.restaurant_name
FROM Restaurant r
LEFT JOIN Orders o
ON r.restaurant_id = o.restaurant_id
WHERE o.order_id IS NULL;

-- =========================================================
-- 29. DATA FIXES
-- =========================================================

-- Fix 1: O101 total was 200 but only had a 120 item.
-- Add French Fries (80) from the same restaurant -> 120 + 80 = 200
INSERT INTO Order_Item (order_id, item_id, quantity, item_price)
VALUES ('O101', 'M102', 1, 80);

-- Fix 2: O113 (restaurant R112) contained an item from R102.
-- Replace it with R112's item M120 (Dal Tadka), quantity 2 -> 320
DELETE FROM Order_Item
WHERE order_id = 'O113' AND item_id = 'M103';

INSERT INTO Order_Item (order_id, item_id, quantity, item_price)
VALUES ('O113', 'M120', 2, 160);

UPDATE Orders SET total_amount = 320 WHERE order_id = 'O113';

-- Fix 3: O117 total should match its item (160)
UPDATE Orders SET total_amount = 160 WHERE order_id = 'O117';

-- Fix 4: Make Orders, Delivery and Payment statuses agree
UPDATE Delivery SET delivery_status = 'Delivered'  WHERE delivery_id = 'D104'; -- O104 is Delivered
UPDATE Payment  SET payment_status  = 'Successful' WHERE payment_id  = 'P104';
UPDATE Delivery SET delivery_status = 'Preparing'  WHERE delivery_id = 'D102'; -- O102 is Preparing
UPDATE Orders   SET status = 'Preparing' WHERE order_id IN ('O111', 'O117');   -- Delivery has no 'Placed'
UPDATE Payment  SET payment_status = 'Pending' WHERE payment_id = 'P119';      -- cash isn't paid until delivered

-- Fix 5: Small logical errors
UPDATE Customer   SET city = 'Pune'    WHERE customer_id = 'C101';  -- MG Road + Pune pincode
UPDATE Restaurant SET location = 'MG Road' WHERE restaurant_id = 'R101'; -- was just "Pune"

-- Check 1: order totals vs item totals
SELECT o.order_id, o.total_amount,
       SUM(oi.quantity * oi.item_price) AS calculated
FROM Orders o
JOIN Order_Item oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
HAVING o.total_amount <> SUM(oi.quantity * oi.item_price);

-- Check 2: order status vs delivery status
SELECT o.order_id, o.status, d.delivery_status
FROM Orders o
JOIN Delivery d ON o.order_id = d.order_id
WHERE o.status <> d.delivery_status;
