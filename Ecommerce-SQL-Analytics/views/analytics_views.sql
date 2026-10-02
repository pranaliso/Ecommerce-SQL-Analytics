USE ecommerce_analytics;

CREATE OR REPLACE VIEW vw_order_summary AS
SELECT
    o.order_id,
    o.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    o.order_date,
    o.status,
    o.shipping_city,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount),2) AS order_value
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY
    o.order_id, o.customer_id, customer_name,
    o.order_date, o.status, o.shipping_city;

CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(CASE WHEN o.status = 'DELIVERED' THEN oi.quantity ELSE 0 END) AS units_sold,
    ROUND(SUM(
        CASE
            WHEN o.status = 'DELIVERED'
            THEN oi.quantity * oi.unit_price - oi.discount
            ELSE 0
        END
    ),2) AS revenue,
    ROUND(SUM(
        CASE
            WHEN o.status = 'DELIVERED'
            THEN oi.quantity * (oi.unit_price - oi.unit_cost) - oi.discount
            ELSE 0
        END
    ),2) AS gross_profit,
    ROUND(AVG(r.rating),2) AS avg_rating
FROM products p
JOIN categories c ON c.category_id = p.category_id
LEFT JOIN order_items oi ON oi.product_id = p.product_id
LEFT JOIN orders o ON o.order_id = oi.order_id
LEFT JOIN reviews r ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name, c.category_name;

CREATE OR REPLACE VIEW vw_customer_360 AS
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    c.city,
    c.state,
    COUNT(DISTINCT CASE WHEN o.status = 'DELIVERED' THEN o.order_id END) AS completed_orders,
    ROUND(COALESCE(SUM(
        CASE
            WHEN o.status = 'DELIVERED'
            THEN oi.quantity * oi.unit_price - oi.discount
            ELSE 0
        END
    ),0),2) AS lifetime_spend,
    MAX(CASE WHEN o.status = 'DELIVERED' THEN o.order_date END) AS last_order_date
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, customer_name, c.city, c.state;
