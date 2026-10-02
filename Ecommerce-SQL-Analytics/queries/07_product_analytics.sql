USE ecommerce_analytics;

-- 1. Product revenue, cost and profit
SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount),2) AS revenue,
    ROUND(SUM(oi.quantity * oi.unit_cost),2) AS cost,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount)
        - SUM(oi.quantity * oi.unit_cost),
        2
    ) AS profit
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'DELIVERED'
GROUP BY p.product_id, p.product_name
ORDER BY profit DESC;

-- 2. Profit margin by product
SELECT
    p.product_name,
    ROUND(
        (
            SUM(oi.quantity * oi.unit_price - oi.discount)
            - SUM(oi.quantity * oi.unit_cost)
        ) / NULLIF(SUM(oi.quantity * oi.unit_price - oi.discount),0) * 100,
        2
    ) AS profit_margin_pct
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'DELIVERED'
GROUP BY p.product_id, p.product_name
ORDER BY profit_margin_pct DESC;

-- 3. Low stock + high demand
SELECT
    p.product_name,
    p.stock_quantity,
    p.reorder_level,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'DELIVERED'
GROUP BY p.product_id, p.product_name, p.stock_quantity, p.reorder_level
HAVING p.stock_quantity <= p.reorder_level
   AND units_sold >= 3
ORDER BY units_sold DESC;

-- 4. Products without reviews
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN reviews r ON r.product_id = p.product_id
WHERE r.review_id IS NULL;

-- 5. Product rating summary
SELECT
    p.product_name,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating),2) AS avg_rating
FROM products p
LEFT JOIN reviews r ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY avg_rating DESC;
