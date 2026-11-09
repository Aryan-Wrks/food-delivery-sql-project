-- =========================================================
-- 06_views.sql
-- Saved queries (views). Run after 04.
-- =========================================================

USE food_delivery_app;

-- View 0 (college experiment): customers with their orders
DROP VIEW IF EXISTS Customer_Order_View;
CREATE VIEW Customer_Order_View AS
SELECT c.customer_id, c.name, o.order_id, o.order_date, o.status, o.total_amount
FROM Customer c
INNER JOIN Orders o ON c.customer_id = o.customer_id;

-- View 1: revenue of each restaurant (delivered orders only)
DROP VIEW IF EXISTS Restaurant_Revenue_View;
CREATE VIEW Restaurant_Revenue_View AS
SELECT r.restaurant_name,
       COUNT(*) AS delivered_orders,
       SUM(o.total_amount) AS total_revenue
FROM Restaurant r
JOIN Orders o ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name;

-- View 2: spending of each customer (delivered orders only)
DROP VIEW IF EXISTS Customer_Spending_View;
CREATE VIEW Customer_Spending_View AS
SELECT c.name AS customer_name,
       COUNT(*) AS delivered_orders,
       SUM(o.total_amount) AS total_spent
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.name;

-- View 3: one row per order with customer, restaurant, payment and delivery details
DROP VIEW IF EXISTS Order_Details_View;
CREATE VIEW Order_Details_View AS
SELECT o.order_id,
       c.name AS customer_name,
       r.restaurant_name,
       o.order_date,
       o.status,
       o.total_amount,
       p.payment_method,
       p.payment_status,
       d.delivery_person
FROM Orders o
JOIN Customer c   ON o.customer_id = c.customer_id
JOIN Restaurant r ON o.restaurant_id = r.restaurant_id
JOIN Payment p    ON o.order_id = p.order_id
JOIN Delivery d   ON o.order_id = d.order_id;

-- Test the views
SELECT * FROM Restaurant_Revenue_View ORDER BY total_revenue DESC;   -- 17 rows, Biryani Point 2100 first
SELECT * FROM Customer_Spending_View ORDER BY total_spent DESC;      -- 19 rows, Rahul 1860 first
SELECT * FROM Order_Details_View ORDER BY order_id;                  -- 57 rows
SHOW FULL TABLES WHERE TABLE_TYPE = 'VIEW';                          -- 4 views
