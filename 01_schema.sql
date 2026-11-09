-- =========================================================
-- 01_schema.sql
-- Creates the database and the 7 tables
-- =========================================================

DROP DATABASE IF EXISTS food_delivery_app;
CREATE DATABASE food_delivery_app;
USE food_delivery_app;

-- Customer
CREATE TABLE Customer (
    customer_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE,
    street VARCHAR(100),
    city VARCHAR(50) DEFAULT 'Pune',
    pincode VARCHAR(10),
    CONSTRAINT chk_customer_phone CHECK (LENGTH(phone) >= 10)
);

-- Restaurant
CREATE TABLE Restaurant (
    restaurant_id VARCHAR(10) PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    location VARCHAR(100) NOT NULL
);

-- Menu_Item
CREATE TABLE Menu_Item (
    item_id VARCHAR(10) PRIMARY KEY,
    restaurant_id VARCHAR(10) NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    category VARCHAR(50),
    CONSTRAINT fk_menu_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
    CONSTRAINT chk_menu_price CHECK (price > 0)
);

-- Orders
CREATE TABLE Orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    restaurant_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Placed',
    total_amount DECIMAL(8,2),
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT fk_order_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
    CONSTRAINT chk_order_amount CHECK (total_amount >= 0),
    CONSTRAINT chk_order_status CHECK (status IN ('Placed','Preparing','Out for Delivery','Delivered','Cancelled'))
);

-- Order_Item (one row per item in an order)
CREATE TABLE Order_Item (
    order_id VARCHAR(10),
    item_id VARCHAR(10),
    quantity INT NOT NULL,
    item_price DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (order_id, item_id),
    CONSTRAINT fk_orderitem_order FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_orderitem_item FOREIGN KEY (item_id) REFERENCES Menu_Item(item_id),
    CONSTRAINT chk_orderitem_quantity CHECK (quantity > 0),
    CONSTRAINT chk_orderitem_price CHECK (item_price > 0)
);

-- Payment (one payment per order)
CREATE TABLE Payment (
    payment_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10) NOT NULL UNIQUE,
    payment_method VARCHAR(20),
    payment_status VARCHAR(20),
    CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('UPI','Cash','Card')),
    CONSTRAINT chk_payment_status CHECK (payment_status IN ('Successful','Pending','Refunded'))
);

-- Delivery (one delivery per order)
CREATE TABLE Delivery (
    delivery_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10) NOT NULL UNIQUE,
    delivery_person VARCHAR(100),
    delivery_status VARCHAR(20),
    CONSTRAINT fk_delivery_order FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT chk_delivery_status CHECK (delivery_status IN ('Preparing','Out for Delivery','Delivered','Cancelled'))
);
