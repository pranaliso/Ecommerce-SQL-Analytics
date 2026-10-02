USE ecommerce_analytics;

-- 1. Active customers
SELECT *
FROM customers
WHERE status = 'ACTIVE';

-- 2. Products above ₹2,000
SELECT product_name, selling_price
FROM products
WHERE selling_price > 2000
ORDER BY selling_price DESC;

-- 3. Low-stock products
SELECT product_name, stock_quantity, reorder_level
FROM products
WHERE stock_quantity <= reorder_level
ORDER BY stock_quantity;

-- 4. Average product price by category
SELECT
    c.category_name,
    ROUND(AVG(p.selling_price), 2) AS avg_price
FROM categories c
JOIN products p ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY avg_price DESC;

-- 5. Number of customers by city
SELECT city, COUNT(*) AS customers
FROM customers
GROUP BY city
ORDER BY customers DESC;
