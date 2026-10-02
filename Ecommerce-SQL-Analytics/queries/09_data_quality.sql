USE ecommerce_analytics;

-- 1. Duplicate emails should be impossible because of UNIQUE constraint
SELECT email, COUNT(*) AS duplicate_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

-- 2. Orders without order items
SELECT o.order_id
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
WHERE oi.order_item_id IS NULL;

-- 3. Paid payments with missing payment timestamp
SELECT *
FROM payments
WHERE payment_status = 'PAID'
  AND paid_at IS NULL;

-- 4. Negative inventory / invalid prices
SELECT *
FROM products
WHERE stock_quantity < 0
   OR cost_price < 0
   OR selling_price < 0;

-- 5. Reviews outside valid rating range
SELECT *
FROM reviews
WHERE rating NOT BETWEEN 1 AND 5;

-- 6. Delivered orders without successful payment
SELECT o.order_id, o.status, p.payment_status
FROM orders o
LEFT JOIN payments p ON p.order_id = o.order_id
WHERE o.status = 'DELIVERED'
  AND (p.payment_status IS NULL OR p.payment_status <> 'PAID');
