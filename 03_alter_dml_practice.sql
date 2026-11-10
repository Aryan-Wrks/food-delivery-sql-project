
-- 03_alter_dml_practice.sql
-- ALTER TABLE, UPDATE and DELETE practice (college practical). 

USE food_delivery_app;

-- ADD COLUMN
ALTER TABLE Customer ADD age INT;

-- Fill the new column
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

-- MODIFY COLUMN (works now because there are no NULL values)
ALTER TABLE Customer MODIFY age INT NOT NULL;

-- ADD CONSTRAINT
ALTER TABLE Customer ADD CONSTRAINT chk_customer_age CHECK (age >= 0);

-- UPDATE practice 
UPDATE Customer SET city = 'Mumbai' WHERE customer_id = 'C101';
UPDATE Orders SET status = 'Delivered' WHERE order_id = 'O104';

-- Another column
ALTER TABLE Customer ADD alternate_phone VARCHAR(15);
UPDATE Customer SET alternate_phone = '9000000001' WHERE customer_id = 'C101';
UPDATE Customer SET alternate_phone = '9000000002' WHERE customer_id = 'C102';
UPDATE Customer SET alternate_phone = '9000000003' WHERE customer_id = 'C103';
UPDATE Customer SET alternate_phone = '9000000004' WHERE customer_id = 'C104';
UPDATE Customer SET alternate_phone = '9000000005' WHERE customer_id = 'C105';
UPDATE Customer SET alternate_phone = '9000000006' WHERE customer_id = 'C106';
UPDATE Customer SET alternate_phone = '9000000007' WHERE customer_id = 'C107';
UPDATE Customer SET alternate_phone = '9000000008' WHERE customer_id = 'C108';
UPDATE Customer SET alternate_phone = '9000000009' WHERE customer_id = 'C109';
UPDATE Customer SET alternate_phone = '9000000010' WHERE customer_id = 'C110';
UPDATE Customer SET alternate_phone = '9000000011' WHERE customer_id = 'C111';
UPDATE Customer SET alternate_phone = '9000000012' WHERE customer_id = 'C112';
UPDATE Customer SET alternate_phone = '9000000013' WHERE customer_id = 'C113';
UPDATE Customer SET alternate_phone = '9000000014' WHERE customer_id = 'C114';
UPDATE Customer SET alternate_phone = '9000000015' WHERE customer_id = 'C115';
UPDATE Customer SET alternate_phone = '9000000016' WHERE customer_id = 'C116';
UPDATE Customer SET alternate_phone = '9000000017' WHERE customer_id = 'C117';
UPDATE Customer SET alternate_phone = '9000000018' WHERE customer_id = 'C118';
UPDATE Customer SET alternate_phone = '9000000019' WHERE customer_id = 'C119';
UPDATE Customer SET alternate_phone = '9000000020' WHERE customer_id = 'C120';

ALTER TABLE Customer MODIFY alternate_phone VARCHAR(20);

-- UNIQUE constraint, then DROP it, then DROP the column
ALTER TABLE Customer ADD CONSTRAINT unique_alternate_phone UNIQUE (alternate_phone);
ALTER TABLE Customer DROP CONSTRAINT unique_alternate_phone;
ALTER TABLE Customer DROP COLUMN alternate_phone;

-- DELETE practice 
DELETE FROM Delivery WHERE delivery_id = 'D108';
