-- 05_analysis_queries.sql
-- Data quality checks 

USE food_delivery_app;

-- PART A: COLLEGE PRACTICAL QUERIES (aggregates and joins)


-- A1: All aggregate functions together
SELECT COUNT(*) AS total_orders,
       SUM(total_amount) AS total_sales,
       AVG(total_amount) AS average_order,
       MAX(total_amount) AS highest_order,
       MIN(total_amount) AS lowest_order
FROM Orders;
-- Expected: 57 orders, 17560 sales, average about 308.07, highest 660, lowest 90

-- A2: Number of orders by status
SELECT status, COUNT(*) AS number_of_orders
FROM Orders
GROUP BY status;
-- Expected: Delivered 48, Cancelled 6, Preparing 2, Out for Delivery 1

-- A3: Customers and their orders (3-table join)
SELECT c.name, o.order_id, r.restaurant_name, o.order_date, o.total_amount
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Restaurant r ON o.restaurant_id = r.restaurant_id;

-- Expected: 57 rows

-- A4: LEFT JOIN, all customers including those with no orders
SELECT c.name, o.order_id, o.status, o.total_amount
FROM Customer c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

-- Expected: 60 rows (57 orders + 3 customers without orders, shown with NULL)

-- A5: RIGHT JOIN, all restaurants and their menu items
SELECT r.restaurant_name, m.item_name, m.price
FROM Menu_Item m
RIGHT JOIN Restaurant r ON r.restaurant_id = m.restaurant_id;

-- Expected: 45 rows (every restaurant has at least one menu item now)


-- PART B: DATA QUALITY CHECKS (Day 3)

-- DQ1: Orders whose total does not match the sum of their items
SELECT o.order_id, o.total_amount,
       SUM(oi.quantity * oi.item_price) AS calculated_total
FROM Orders o
JOIN Order_Item oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
HAVING o.total_amount <> SUM(oi.quantity * oi.item_price);

-- Expected: 0 rows

-- DQ2: Customers who never placed an order
SELECT c.customer_id, c.name
FROM Customer c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Expected: 3 rows (C121, C122, C123)

-- DQ3: Menu items that were never ordered
SELECT m.item_id, m.item_name, r.restaurant_name
FROM Menu_Item m
JOIN Restaurant r ON m.restaurant_id = r.restaurant_id
LEFT JOIN Order_Item oi ON m.item_id = oi.item_id
WHERE oi.order_id IS NULL;

-- Expected: 4 rows (M142 to M145)

-- DQ4: Orders without a payment record
SELECT o.order_id
FROM Orders o
LEFT JOIN Payment p ON o.order_id = p.order_id
WHERE p.payment_id IS NULL;

-- Expected: 0 rows

-- DQ5: Orders without a delivery record
SELECT o.order_id
FROM Orders o
LEFT JOIN Delivery d ON o.order_id = d.order_id
WHERE d.delivery_id IS NULL;

-- Expected: 0 rows

-- DQ6: Orders that have no items
SELECT o.order_id
FROM Orders o
LEFT JOIN Order_Item oi ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;

-- Expected: 0 rows

-- DQ7: Restaurants that never received an order
SELECT r.restaurant_id, r.restaurant_name
FROM Restaurant r
LEFT JOIN Orders o ON r.restaurant_id = o.restaurant_id
WHERE o.order_id IS NULL;
-- Expected: 2 rows (R119, R120)

-- DQ8: Restaurants with MORE THAN 5 orders (WHERE vs HAVING)
SELECT r.restaurant_name, COUNT(*) AS total_orders
FROM Restaurant r
JOIN Orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
HAVING COUNT(*) > 5
ORDER BY total_orders DESC;

-- Expected: 3 rows (Royal Kitchen 8, Pizza Palace 6, Biryani Point 6)

-- DQ9: Order status must equal delivery status
SELECT o.order_id, o.status, d.delivery_status
FROM Orders o
JOIN Delivery d ON o.order_id = d.order_id
WHERE o.status <> d.delivery_status;

-- Expected: 0 rows

-- DQ10: Every item must belong to the restaurant of its order
SELECT oi.order_id, oi.item_id
FROM Order_Item oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Menu_Item m ON oi.item_id = m.item_id
WHERE o.restaurant_id <> m.restaurant_id;

-- Expected: 0 rows



-- PART C: SALES ANALYSIS (Day 4). Revenue = Delivered orders only

-- S1: Total revenue
SELECT COUNT(*) AS delivered_orders,
       SUM(total_amount) AS total_revenue
FROM Orders
WHERE status = 'Delivered';

-- Expected: 48 orders, 15100
-- S1 Insight: 48 of 57 orders (84%) were delivered, earning 15100. The rest were cancelled or still in progress.


-- S2: Top 5 restaurants by revenue
SELECT r.restaurant_name,
       SUM(o.total_amount) AS total_revenue
FROM Restaurant r
JOIN Orders o ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Expected: Biryani Point 2100, Royal Kitchen 2090, Pizza Palace 1890, Burger House 1240, Spice Hub 1220
-- S2 Insight: Biryani Point (2100) and Royal Kitchen (2090) are almost tied, and together earn about 28% of revenue.

-- S3: Revenue per month
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       COUNT(*) AS delivered_orders,
       SUM(total_amount) AS total_revenue
FROM Orders
WHERE status = 'Delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Expected: 2026-07 (9, 3420), 2026-08 (23, 5990), 2026-09 (11, 4040), 2026-10 (5, 1650)
-- S3 Insight: August has the highest revenue (5990), but the sample data is concentrated in August, so this is not a real trend.

-- S4: Average order value per restaurant
SELECT r.restaurant_name,
       COUNT(*) AS delivered_orders,
       ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM Restaurant r
JOIN Orders o ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY avg_order_value DESC;

-- Expected: 17 rows (Punjabi Rasoi 440.00 first, Biryani Point 420.00, Royal Kitchen 298.57)
-- S4 Insight: Punjabi Rasoi has the top average (440) from only 1 order, so Biryani Point (420 from 5 orders) is more reliable.

-- S5: Most ordered items (cancelled orders excluded)
SELECT m.item_name,
       r.restaurant_name,
       SUM(oi.quantity) AS total_ordered
FROM Order_Item oi
JOIN Menu_Item m ON oi.item_id = m.item_id
JOIN Orders o ON oi.order_id = o.order_id
JOIN Restaurant r ON m.restaurant_id = r.restaurant_id
WHERE o.status <> 'Cancelled'
GROUP BY m.item_id, m.item_name, r.restaurant_name
ORDER BY total_ordered DESC
LIMIT 10;

-- Expected: Dal Tadka 7, Butter Naan (Royal Kitchen) 7, Chicken Biryani 6, then 5 each
-- S5 Insight: Dal Tadka and Butter Naan (both Royal Kitchen) lead with 7 units each, but Butter Naan is a cheap side dish.



-- PART D: CUSTOMER AND PAYMENT ANALYSIS (Day 5)
 

-- C1: Repeat customers (2 or more orders)
SELECT c.name, COUNT(*) AS total_orders
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(*) >= 2
ORDER BY total_orders DESC, c.name;

-- Expected: 18 rows (Anjali, Nikhil, Rahul first with 5)
-- C1 Insight: 18 of the 20 customers who ordered placed 2 or more orders (90%), so repeat buying is strong in this sample.

-- C1b: One-time customers
SELECT c.name, COUNT(*) AS total_orders
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(*) = 1;

-- Expected: 2 rows (Varun, Sahil)

-- C2: Top 5 customers by spending
SELECT c.name,
       COUNT(*) AS delivered_orders,
       SUM(o.total_amount) AS total_spent
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 5;

-- Expected: Rahul 1860, Nikhil 1810, Anjali 1490, Karan 1410, Rohan 1070
-- C2 Insight: The top 5 customers made about 51% of delivered revenue (7640 of 15100), so the business depends on a few customers.

-- C3: Payment method share
SELECT payment_method,
       COUNT(*) AS total_payments,
       ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM Payment), 2) AS percentage
FROM Payment
GROUP BY payment_method
ORDER BY total_payments DESC;

-- Expected: UPI 27 (47.37), Card 16 (28.07), Cash 14 (24.56)
-- C3 Insight: UPI is the most used payment method (47.37%), and Cash is the least (24.56%).

-- C4: Pending and refunded money
SELECT p.payment_status,
       COUNT(*) AS total_payments,
       SUM(o.total_amount) AS total_value
FROM Payment p
JOIN Orders o ON p.order_id = o.order_id
GROUP BY p.payment_status
ORDER BY total_value DESC;

-- Expected: Successful 50 / 16030, Refunded 6 / 1210, Pending 1 / 320
-- C4 Insight: Refunds are about 7% of total order value (1210 of 17560), all from cancelled orders.

-- C5: Orders by customer pincode (top 5)
SELECT c.pincode, COUNT(*) AS total_orders
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.pincode
ORDER BY total_orders DESC
LIMIT 5;

-- Expected: 411001 = 12, 411004 = 9, 411005 = 6, then 411045 and 411014 tied at 4
-- C5 Insight: Pincode 411001 has the most orders (12), but only 3 customers live there, so it shows customers, not an area trend.


-- PART E: CASE STATEMENTS (Day 6)

-- E1: Cancellation rate per restaurant
SELECT r.restaurant_name,
       COUNT(*) AS total_orders,
       SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
       ROUND(100 * SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*), 1) AS cancel_pct
FROM Restaurant r
JOIN Orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
HAVING SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END) > 0
ORDER BY cancel_pct DESC, total_orders DESC;

-- Expected: 6 rows (Rolls Express 100.0, three at 33.3, Chinese Wok 25.0, Royal Kitchen 12.5)
-- E1 Insight: 6 of 57 orders (10.5%) were cancelled, one each at 6 restaurants. Rolls Express shows 100% from only 1 order.

-- E2: Order value segments
SELECT CASE
           WHEN total_amount >= 400 THEN 'High'
           WHEN total_amount >= 200 THEN 'Medium'
           ELSE 'Low'
       END AS order_segment,
       COUNT(*) AS total_orders
FROM Orders
GROUP BY CASE
           WHEN total_amount >= 400 THEN 'High'
           WHEN total_amount >= 200 THEN 'Medium'
           ELSE 'Low'
       END
ORDER BY total_orders DESC;

-- Expected: Medium 30, High 15, Low 12
-- E2 Insight: Over half of the orders (30 of 57, 53%) are Medium value (200 to 399), so most customers spend a moderate amount.