USE ecommerce_analytics;

-- 1. Customer lifetime value
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer,
    COUNT(DISTINCT o.order_id) AS orders_count,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount),2) AS lifetime_value,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED'
GROUP BY c.customer_id, customer
ORDER BY lifetime_value DESC;

-- 2. Repeat customers
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer,
    COUNT(DISTINCT o.order_id) AS completed_orders
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status = 'DELIVERED'
GROUP BY c.customer_id, customer
HAVING completed_orders >= 2
ORDER BY completed_orders DESC;

-- 3. Customer first purchase month
WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(DATE(order_date)) AS first_order_date
    FROM orders
    WHERE status = 'DELIVERED'
    GROUP BY customer_id
)
SELECT
    DATE_FORMAT(first_order_date,'%Y-%m') AS first_purchase_month,
    COUNT(*) AS new_customers
FROM first_purchase
GROUP BY DATE_FORMAT(first_order_date,'%Y-%m')
ORDER BY first_purchase_month;

-- 4. Customers who purchased from multiple categories
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer,
    COUNT(DISTINCT p.category_id) AS categories_bought
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.status = 'DELIVERED'
GROUP BY c.customer_id, customer
HAVING categories_bought >= 2
ORDER BY categories_bought DESC;
