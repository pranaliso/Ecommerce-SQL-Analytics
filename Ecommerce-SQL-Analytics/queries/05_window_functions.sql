USE ecommerce_analytics;

-- 1. Top 3 products per category
WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        c.category_name,
        SUM(oi.quantity * oi.unit_price - oi.discount) AS revenue
    FROM products p
    JOIN categories c ON c.category_id = p.category_id
    JOIN order_items oi ON oi.product_id = p.product_id
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.status = 'DELIVERED'
    GROUP BY p.product_id, p.product_name, c.category_name
)
SELECT *
FROM (
    SELECT
        product_name,
        category_name,
        ROUND(revenue,2) AS revenue,
        DENSE_RANK() OVER (
            PARTITION BY category_name
            ORDER BY revenue DESC
        ) AS category_rank
    FROM product_revenue
) ranked
WHERE category_rank <= 3
ORDER BY category_name, category_rank;

-- 2. Running monthly revenue
WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_date,'%Y-%m') AS month,
        SUM(oi.quantity * oi.unit_price - oi.discount) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status = 'DELIVERED'
    GROUP BY DATE_FORMAT(o.order_date,'%Y-%m')
)
SELECT
    month,
    ROUND(revenue,2) AS revenue,
    ROUND(
        SUM(revenue) OVER (ORDER BY month),
        2
    ) AS cumulative_revenue
FROM monthly
ORDER BY month;

-- 3. Month-over-month revenue comparison
WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_date,'%Y-%m') AS month,
        SUM(oi.quantity * oi.unit_price - oi.discount) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status = 'DELIVERED'
    GROUP BY DATE_FORMAT(o.order_date,'%Y-%m')
),
comparison AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_revenue
    FROM monthly
)
SELECT
    month,
    ROUND(revenue,2) AS revenue,
    ROUND(previous_revenue,2) AS previous_revenue,
    ROUND(
        (revenue - previous_revenue) / NULLIF(previous_revenue,0) * 100,
        2
    ) AS growth_pct
FROM comparison
ORDER BY month;
