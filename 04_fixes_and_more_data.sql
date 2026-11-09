-- =========================================================
-- 04_fixes_and_more_data.sql
-- Data fixes, then more customers, menu items and orders. Run after 03.
-- =========================================================

USE food_delivery_app;

-- =========================================================
-- PART 1: DATA FIXES (found with the data quality checks)
-- =========================================================

-- Fix 1: O101 total was 200 but it only had a 120 item. Add French Fries (80).
INSERT INTO Order_Item (order_id, item_id, quantity, item_price) VALUES ('O101', 'M102', 1, 80);

-- Fix 2: O113 (restaurant R112) contained an item from R102. Replace it with Dal Tadka x 2.
DELETE FROM Order_Item WHERE order_id = 'O113' AND item_id = 'M103';
INSERT INTO Order_Item (order_id, item_id, quantity, item_price) VALUES ('O113', 'M120', 2, 160);
UPDATE Orders SET total_amount = 320 WHERE order_id = 'O113';

-- Fix 3: O117 total must match its item (160)
UPDATE Orders SET total_amount = 160 WHERE order_id = 'O117';

-- Fix 4: Make Orders, Delivery and Payment statuses agree
UPDATE Delivery SET delivery_status = 'Delivered'  WHERE delivery_id = 'D104';
UPDATE Payment  SET payment_status  = 'Successful' WHERE payment_id  = 'P104';
UPDATE Delivery SET delivery_status = 'Preparing'  WHERE delivery_id = 'D102';
UPDATE Orders   SET status = 'Preparing' WHERE order_id IN ('O111', 'O117');
UPDATE Payment  SET payment_status = 'Pending' WHERE payment_id = 'P119';

-- Fix 5: Small logical errors
UPDATE Customer   SET city = 'Pune' WHERE customer_id = 'C101';
UPDATE Restaurant SET location = 'MG Road' WHERE restaurant_id = 'R101';


-- =========================================================
-- PART 2: REALISTIC DATA (37 new orders, July to October 2026)
-- =========================================================

-- ---------------------------------------------------------
-- 2.1 Restore the delivery row deleted in the DELETE practice
-- ---------------------------------------------------------
INSERT INTO Delivery (delivery_id, order_id, delivery_person, delivery_status)
VALUES ('D108', 'O108', 'Kunal', 'Cancelled');


-- ---------------------------------------------------------
-- 2.2 Finish old orders (2 months old orders cannot still be "Preparing")
-- Orders, Delivery and Payment are updated TOGETHER
-- ---------------------------------------------------------

-- These become Delivered
UPDATE Orders
SET status = 'Delivered'
WHERE order_id IN ('O102','O106','O109','O112','O114','O116','O119');

UPDATE Delivery
SET delivery_status = 'Delivered'
WHERE order_id IN ('O102','O106','O109','O112','O114','O116','O119');

-- Cash and pending payments are now collected
UPDATE Payment
SET payment_status = 'Successful'
WHERE order_id IN ('O102','O106','O116','O119');

-- These become Cancelled (money is refunded)
UPDATE Orders
SET status = 'Cancelled'
WHERE order_id IN ('O111','O117');

UPDATE Delivery
SET delivery_status = 'Cancelled'
WHERE order_id IN ('O111','O117');

UPDATE Payment
SET payment_status = 'Refunded'
WHERE order_id IN ('O111','O117');


-- ---------------------------------------------------------
-- 2.3 Use a small pool of 8 delivery persons
-- (names like Amit and Varun are removed because they are customer names too)
-- ---------------------------------------------------------
UPDATE Delivery SET delivery_person = 'Suresh' WHERE delivery_id IN ('D101','D109','D117');
UPDATE Delivery SET delivery_person = 'Manoj'  WHERE delivery_id IN ('D102','D110','D118');
UPDATE Delivery SET delivery_person = 'Raj'    WHERE delivery_id IN ('D103','D111','D119');
UPDATE Delivery SET delivery_person = 'Deepak' WHERE delivery_id IN ('D104','D112','D120');
UPDATE Delivery SET delivery_person = 'Nitin'  WHERE delivery_id IN ('D105','D113');
UPDATE Delivery SET delivery_person = 'Vijay'  WHERE delivery_id IN ('D106','D114');
UPDATE Delivery SET delivery_person = 'Ravi'   WHERE delivery_id IN ('D107','D115');
UPDATE Delivery SET delivery_person = 'Sameer' WHERE delivery_id IN ('D108','D116');


-- ---------------------------------------------------------
-- 2.4 More menu items (25 new, so every restaurant has 2-3 items)
-- ---------------------------------------------------------
INSERT INTO Menu_Item
(item_id, restaurant_id, item_name, price, category)
VALUES
('M121','R109','Chicken Tikka',280,'Starter'),
('M122','R109','Butter Naan',50,'Bread'),
('M123','R110','Fruit Bowl',130,'Healthy Food'),
('M124','R110','Sprouts Chaat',120,'Healthy Food'),
('M125','R111','Cappuccino',120,'Beverage'),
('M126','R111','Grilled Sandwich',140,'Fast Food'),
('M127','R112','Paneer Butter Masala',240,'Main Course'),
('M128','R112','Jeera Rice',140,'Main Course'),
('M129','R112','Butter Naan',50,'Bread'),
('M130','R113','Chole Bhature',150,'Main Course'),
('M131','R113','Rajma Chawal',140,'Main Course'),
('M132','R114','White Sauce Pasta',230,'Pasta'),
('M133','R114','Garlic Bread',120,'Starter'),
('M134','R115','Pav Bhaji',130,'Street Food'),
('M135','R115','Vada Pav',40,'Street Food'),
('M136','R116','Mysore Dosa',120,'South Indian'),
('M137','R116','Uttapam',110,'South Indian'),
('M138','R117','Misal Pav',120,'Main Course'),
('M139','R117','Puran Poli',90,'Dessert'),
('M140','R118','Paneer Roll',110,'Fast Food'),
('M141','R118','Chicken Roll',140,'Fast Food'),
('M142','R119','Veg Thali',180,'Main Course'),
('M143','R119','Masala Papad',40,'Starter'),
('M144','R120','Chicken Thali',240,'Main Course'),
('M145','R120','Egg Curry',170,'Main Course');


-- ---------------------------------------------------------
-- 2.5 Three customers who have NOT ordered yet
-- (age is required because the column is NOT NULL)
-- ---------------------------------------------------------
INSERT INTO Customer
(customer_id, name, phone, email, street, city, pincode, age)
VALUES
('C121','Tanvi','9876543230','tanvi@example.com','5 Kondhwa Road','Pune','411048',22),
('C122','Harsh','9876543231','harsh@example.com','33 Sadashiv Peth','Pune','411030',23),
('C123','Divya','9876543232','divya@example.com','9 Nagar Road','Pune','411014',21);


-- ---------------------------------------------------------
-- 2.6 Orders (37 new, July to October 2026)
-- Restaurants R119 and R120 get no orders on purpose
-- ---------------------------------------------------------
INSERT INTO Orders
(order_id, customer_id, restaurant_id, order_date, status, total_amount)
VALUES
('O121','C101','R101','2026-07-03','Delivered',320),
('O122','C102','R103','2026-07-05','Delivered',250),
('O123','C113','R112','2026-07-08','Delivered',340),
('O124','C105','R105','2026-07-10','Delivered',460),
('O125','C108','R106','2026-07-13','Delivered',280),
('O126','C101','R104','2026-07-16','Delivered',490),
('O127','C110','R107','2026-07-19','Cancelled',320),
('O128','C115','R115','2026-07-22','Delivered',380),
('O129','C103','R102','2026-07-25','Delivered',500),
('O130','C113','R112','2026-07-29','Delivered',400),
('O131','C118','R108','2026-08-02','Delivered',330),
('O132','C102','R105','2026-08-04','Delivered',520),
('O133','C107','R109','2026-08-06','Delivered',600),
('O134','C112','R111','2026-08-08','Delivered',360),
('O135','C101','R103','2026-08-09','Delivered',570),
('O136','C105','R114','2026-08-31','Delivered',350),
('O137','C110','R113','2026-09-02','Delivered',440),
('O138','C108','R110','2026-09-04','Delivered',250),
('O139','C115','R116','2026-09-06','Delivered',340),
('O140','C113','R117','2026-09-09','Delivered',330),
('O141','C102','R118','2026-09-11','Cancelled',250),
('O142','C118','R112','2026-09-13','Delivered',290),
('O143','C101','R101','2026-09-15','Delivered',280),
('O144','C103','R107','2026-09-18','Delivered',300),
('O145','C112','R104','2026-09-20','Delivered',440),
('O146','C107','R105','2026-09-24','Delivered',660),
('O147','C104','R103','2026-09-27','Delivered',500),
('O148','C106','R115','2026-09-30','Delivered',210),
('O149','C113','R112','2026-10-03','Delivered',420),
('O150','C109','R106','2026-10-07','Delivered',260),
('O151','C102','R102','2026-10-10','Delivered',500),
('O152','C114','R109','2026-10-14','Cancelled',280),
('O153','C111','R108','2026-10-17','Delivered',240),
('O154','C120','R111','2026-10-20','Delivered',230),
('O155','C108','R114','2026-10-22','Out for Delivery',470),
('O156','C105','R103','2026-10-23','Preparing',320),
('O157','C116','R105','2026-10-23','Preparing',460);


-- ---------------------------------------------------------
-- 2.7 Order items (some orders have 2-3 items and quantity above 1)
-- item_price is the menu price at the time of the order
-- ---------------------------------------------------------
INSERT INTO Order_Item
(order_id, item_id, quantity, item_price)
VALUES
('O121','M101',2,120),
('O121','M102',1,80),
('O122','M105',1,250),
('O123','M127',1,240),
('O123','M129',2,50),
('O124','M109',1,260),
('O124','M110',1,200),
('O125','M111',2,100),
('O125','M112',1,80),
('O126','M107',2,180),
('O126','M108',1,130),
('O127','M113',1,150),
('O127','M114',1,170),
('O128','M134',2,130),
('O128','M135',3,40),
('O129','M103',1,220),
('O129','M104',1,280),
('O130','M120',1,160),
('O130','M128',1,140),
('O130','M129',2,50),
('O131','M115',2,90),
('O131','M116',1,150),
('O132','M109',2,260),
('O133','M117',1,220),
('O133','M121',1,280),
('O133','M122',2,50),
('O134','M119',2,110),
('O134','M126',1,140),
('O135','M105',1,250),
('O135','M106',1,320),
('O136','M132',1,230),
('O136','M133',1,120),
('O137','M130',2,150),
('O137','M131',1,140),
('O138','M123',1,130),
('O138','M124',1,120),
('O139','M136',1,120),
('O139','M137',2,110),
('O140','M138',2,120),
('O140','M139',1,90),
('O141','M140',1,110),
('O141','M141',1,140),
('O142','M127',1,240),
('O142','M129',1,50),
('O143','M101',1,120),
('O143','M102',2,80),
('O144','M113',2,150),
('O145','M107',1,180),
('O145','M108',2,130),
('O146','M109',1,260),
('O146','M110',2,200),
('O147','M105',2,250),
('O148','M134',1,130),
('O148','M135',2,40),
('O149','M120',2,160),
('O149','M129',2,50),
('O150','M111',1,100),
('O150','M112',2,80),
('O151','M103',1,220),
('O151','M104',1,280),
('O152','M121',1,280),
('O153','M115',1,90),
('O153','M116',1,150),
('O154','M119',1,110),
('O154','M125',1,120),
('O155','M132',1,230),
('O155','M133',2,120),
('O156','M106',1,320),
('O157','M109',1,260),
('O157','M110',1,200);


-- ---------------------------------------------------------
-- 2.8 Payments
-- Delivered = Successful | Cancelled = Refunded
-- In progress: UPI/Card = Successful, Cash = Pending
-- ---------------------------------------------------------
INSERT INTO Payment
(payment_id, order_id, payment_method, payment_status)
VALUES
('P121','O121','UPI','Successful'),
('P122','O122','Card','Successful'),
('P123','O123','UPI','Successful'),
('P124','O124','Card','Successful'),
('P125','O125','Cash','Successful'),
('P126','O126','UPI','Successful'),
('P127','O127','UPI','Refunded'),
('P128','O128','Cash','Successful'),
('P129','O129','Card','Successful'),
('P130','O130','UPI','Successful'),
('P131','O131','UPI','Successful'),
('P132','O132','Card','Successful'),
('P133','O133','UPI','Successful'),
('P134','O134','Cash','Successful'),
('P135','O135','Card','Successful'),
('P136','O136','UPI','Successful'),
('P137','O137','Cash','Successful'),
('P138','O138','UPI','Successful'),
('P139','O139','Cash','Successful'),
('P140','O140','UPI','Successful'),
('P141','O141','Card','Refunded'),
('P142','O142','UPI','Successful'),
('P143','O143','UPI','Successful'),
('P144','O144','Cash','Successful'),
('P145','O145','Card','Successful'),
('P146','O146','UPI','Successful'),
('P147','O147','Card','Successful'),
('P148','O148','Cash','Successful'),
('P149','O149','UPI','Successful'),
('P150','O150','UPI','Successful'),
('P151','O151','Card','Successful'),
('P152','O152','UPI','Refunded'),
('P153','O153','Cash','Successful'),
('P154','O154','UPI','Successful'),
('P155','O155','UPI','Successful'),
('P156','O156','Cash','Pending'),
('P157','O157','Card','Successful');


-- ---------------------------------------------------------
-- 2.9 Deliveries (same 8 delivery persons, status same as the order)
-- ---------------------------------------------------------
INSERT INTO Delivery
(delivery_id, order_id, delivery_person, delivery_status)
VALUES
('D121','O121','Suresh','Delivered'),
('D122','O122','Manoj','Delivered'),
('D123','O123','Raj','Delivered'),
('D124','O124','Deepak','Delivered'),
('D125','O125','Nitin','Delivered'),
('D126','O126','Vijay','Delivered'),
('D127','O127','Ravi','Cancelled'),
('D128','O128','Sameer','Delivered'),
('D129','O129','Suresh','Delivered'),
('D130','O130','Manoj','Delivered'),
('D131','O131','Raj','Delivered'),
('D132','O132','Deepak','Delivered'),
('D133','O133','Nitin','Delivered'),
('D134','O134','Vijay','Delivered'),
('D135','O135','Ravi','Delivered'),
('D136','O136','Sameer','Delivered'),
('D137','O137','Suresh','Delivered'),
('D138','O138','Manoj','Delivered'),
('D139','O139','Raj','Delivered'),
('D140','O140','Deepak','Delivered'),
('D141','O141','Nitin','Cancelled'),
('D142','O142','Vijay','Delivered'),
('D143','O143','Ravi','Delivered'),
('D144','O144','Sameer','Delivered'),
('D145','O145','Suresh','Delivered'),
('D146','O146','Manoj','Delivered'),
('D147','O147','Raj','Delivered'),
('D148','O148','Deepak','Delivered'),
('D149','O149','Nitin','Delivered'),
('D150','O150','Vijay','Delivered'),
('D151','O151','Ravi','Delivered'),
('D152','O152','Sameer','Cancelled'),
('D153','O153','Suresh','Delivered'),
('D154','O154','Manoj','Delivered'),
('D155','O155','Raj','Out for Delivery'),
('D156','O156','Deepak','Preparing'),
('D157','O157','Nitin','Preparing');


