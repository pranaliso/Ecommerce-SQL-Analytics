USE ecommerce_analytics;

DROP PROCEDURE IF EXISTS sp_customer_report;
DELIMITER //

CREATE PROCEDURE sp_customer_report(IN p_customer_id INT)
BEGIN
    SELECT
        c.customer_id,
        CONCAT(c.first_name,' ',c.last_name) AS customer_name,
        c.email,
        c.city,
        COUNT(DISTINCT CASE
            WHEN o.status = 'DELIVERED' THEN o.order_id
        END) AS completed_orders,
        ROUND(COALESCE(SUM(
            CASE
                WHEN o.status = 'DELIVERED'
                THEN oi.quantity * oi.unit_price - oi.discount
                ELSE 0
            END
        ),0),2) AS lifetime_spend,
        MAX(CASE
            WHEN o.status = 'DELIVERED' THEN o.order_date
        END) AS last_order
    FROM customers c
    LEFT JOIN orders o ON o.customer_id = c.customer_id
    LEFT JOIN order_items oi ON oi.order_id = o.order_id
    WHERE c.customer_id = p_customer_id
    GROUP BY c.customer_id, customer_name, c.email, c.city;
END //

DELIMITER ;

-- Example:
-- CALL sp_customer_report(1);

DROP PROCEDURE IF EXISTS sp_monthly_sales;
DELIMITER //

CREATE PROCEDURE sp_monthly_sales(IN p_year INT, IN p_month INT)
BEGIN
    SELECT
        DATE_FORMAT(o.order_date,'%Y-%m') AS sales_month,
        COUNT(DISTINCT o.order_id) AS orders,
        SUM(oi.quantity) AS units_sold,
        ROUND(SUM(oi.quantity * oi.unit_price - oi.discount),2) AS revenue,
        ROUND(SUM(oi.quantity * oi.unit_cost),2) AS cost,
        ROUND(
            SUM(oi.quantity * (oi.unit_price - oi.unit_cost))
            - SUM(oi.discount),
            2
        ) AS gross_profit
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status = 'DELIVERED'
      AND YEAR(o.order_date) = p_year
      AND MONTH(o.order_date) = p_month
    GROUP BY DATE_FORMAT(o.order_date,'%Y-%m');
END //

DELIMITER ;

-- Example:
-- CALL sp_monthly_sales(2026, 2);
