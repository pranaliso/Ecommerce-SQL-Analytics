USE ecommerce_analytics;

-- 1. Order summary
SELECT
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    o.order_date,
    o.status,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount), 2) AS item_total
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, customer, o.order_date, o.status
ORDER BY o.order_date;

-- 2. Revenue by category
SELECT
    c.category_name,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount), 2) AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN categories c ON c.category_id = p.category_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'DELIVERED'
GROUP BY c.category_id, c.category_name
ORDER BY revenue DESC;

-- 3. Payment method performance
SELECT
    payment_method,
    COUNT(*) AS transactions,
    ROUND(SUM(amount),2) AS total_amount
FROM payments
WHERE payment_status = 'PAID'
GROUP BY payment_method
ORDER BY total_amount DESC;
