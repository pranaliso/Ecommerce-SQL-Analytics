USE ecommerce_analytics;

-- Indexes designed around common filters, joins and reporting queries.
CREATE INDEX idx_orders_customer_date
    ON orders(customer_id, order_date);

CREATE INDEX idx_orders_status_date
    ON orders(status, order_date);

CREATE INDEX idx_order_items_product
    ON order_items(product_id);

CREATE INDEX idx_products_category
    ON products(category_id);

CREATE INDEX idx_reviews_product_rating
    ON reviews(product_id, rating);

CREATE INDEX idx_payments_status_method
    ON payments(payment_status, payment_method);

-- Inspect the execution plan.
EXPLAIN
SELECT
    o.customer_id,
    SUM(oi.quantity * oi.unit_price - oi.discount) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED'
GROUP BY o.customer_id;

-- MySQL 8+ runtime analysis example:
-- EXPLAIN ANALYZE
-- SELECT ...
