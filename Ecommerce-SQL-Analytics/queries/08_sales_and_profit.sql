USE ecommerce_analytics;

-- 1. Overall KPI report
SELECT
    COUNT(DISTINCT o.order_id) AS completed_orders,
    COUNT(DISTINCT o.customer_id) AS purchasing_customers,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount),2) AS revenue,
    ROUND(SUM(oi.quantity * oi.unit_cost),2) AS cost,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount)
        - SUM(oi.quantity * oi.unit_cost),
        2
    ) AS gross_profit,
    ROUND(
        (
            SUM(oi.quantity * oi.unit_price - oi.discount)
            - SUM(oi.quantity * oi.unit_cost)
        ) / NULLIF(SUM(oi.quantity * oi.unit_price - oi.discount),0) * 100,
        2
    ) AS gross_margin_pct
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED';

-- 2. Revenue by city
SELECT
    o.shipping_city,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount),2) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED'
GROUP BY o.shipping_city
ORDER BY revenue DESC;

-- 3. Discount impact
SELECT
    ROUND(SUM(oi.quantity * oi.unit_price),2) AS gross_sales_before_discount,
    ROUND(SUM(oi.discount),2) AS item_discounts,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount),2) AS net_sales
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED';

-- 4. Order status distribution
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;
