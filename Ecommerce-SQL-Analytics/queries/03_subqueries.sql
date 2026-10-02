USE ecommerce_analytics;

-- 1. Customers spending above the average customer spend
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    SUM(oi.quantity * oi.unit_price - oi.discount) AS spend
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED'
GROUP BY c.customer_id, customer
HAVING spend > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            o2.customer_id,
            SUM(oi2.quantity * oi2.unit_price - oi2.discount) AS customer_total
        FROM orders o2
        JOIN order_items oi2 ON oi2.order_id = o2.order_id
        WHERE o2.status = 'DELIVERED'
        GROUP BY o2.customer_id
    ) x
)
ORDER BY spend DESC;

-- 2. Products priced above their category average
SELECT
    p.product_name,
    c.category_name,
    p.selling_price
FROM products p
JOIN categories c ON c.category_id = p.category_id
WHERE p.selling_price > (
    SELECT AVG(p2.selling_price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);

-- 3. Customers with no orders
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
