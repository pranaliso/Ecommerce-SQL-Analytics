USE ecommerce_analytics;

-- 1. Monthly revenue with CTE
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(oi.quantity * oi.unit_price - oi.discount) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status = 'DELIVERED'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    month,
    ROUND(revenue,2) AS revenue
FROM monthly_revenue
ORDER BY month;

-- 2. Customer segmentation
WITH customer_metrics AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer,
        COUNT(DISTINCT o.order_id) AS orders_count,
        COALESCE(SUM(oi.quantity * oi.unit_price - oi.discount),0) AS lifetime_spend
    FROM customers c
    LEFT JOIN orders o
        ON o.customer_id = c.customer_id
       AND o.status = 'DELIVERED'
    LEFT JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_id, customer
)
SELECT
    customer,
    orders_count,
    ROUND(lifetime_spend,2) AS lifetime_spend,
    CASE
        WHEN lifetime_spend >= 25000 THEN 'VIP'
        WHEN lifetime_spend >= 12000 THEN 'HIGH VALUE'
        WHEN orders_count >= 2 THEN 'REGULAR'
        WHEN orders_count = 1 THEN 'NEW'
        ELSE 'INACTIVE'
    END AS customer_segment
FROM customer_metrics
ORDER BY lifetime_spend DESC;

-- 3. Recursive CTE: category hierarchy
WITH RECURSIVE category_tree AS (
    SELECT
        category_id,
        category_name,
        parent_category_id,
        0 AS level
    FROM categories
    WHERE parent_category_id IS NULL

    UNION ALL

    SELECT
        c.category_id,
        c.category_name,
        c.parent_category_id,
        ct.level + 1
    FROM categories c
    JOIN category_tree ct
        ON c.parent_category_id = ct.category_id
)
SELECT *
FROM category_tree
ORDER BY level, category_name;
