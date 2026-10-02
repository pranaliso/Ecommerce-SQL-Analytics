# 🛒 E-Commerce SQL Analytics

A portfolio-grade **MySQL 8+ analytics project** that models an e-commerce business and answers real business questions using SQL.

The project demonstrates:

- Relational database design and normalization
- Primary keys, foreign keys and constraints
- Complex joins
- Aggregations and conditional aggregation
- Subqueries
- CTEs
- Recursive CTE
- Window functions
- Date/time analysis
- Cohort-style customer analysis
- Customer segmentation
- Product/category performance
- Revenue and profit analysis
- Views
- Stored procedures
- Indexing and query optimization
- Data-quality checks

## Tech Stack

- **Database:** MySQL 8+
- **Language:** SQL
- **Tools:** MySQL Workbench / DBeaver / MySQL CLI

## Project Structure

```text
Ecommerce-SQL-Analytics/
├── database/
│   ├── 01_schema.sql
│   └── 02_seed_data.sql
├── queries/
│   ├── 01_basic_analysis.sql
│   ├── 02_joins_and_aggregation.sql
│   ├── 03_subqueries.sql
│   ├── 04_cte_analysis.sql
│   ├── 05_window_functions.sql
│   ├── 06_customer_analytics.sql
│   ├── 07_product_analytics.sql
│   ├── 08_sales_and_profit.sql
│   └── 09_data_quality.sql
├── views/
│   └── analytics_views.sql
├── optimization/
│   └── indexes_and_explain.sql
├── procedures/
│   └── reporting_procedures.sql
└── reports/
    └── business_questions.md
```

## Database Model

The database contains:

- `customers`
- `addresses`
- `categories`
- `products`
- `orders`
- `order_items`
- `payments`
- `reviews`
- `suppliers`
- `product_suppliers`

The design separates transactional data from product/customer information and uses bridge tables where required.

## Business Questions

This project answers questions such as:

1. What is total revenue?
2. What is monthly revenue and month-over-month growth?
3. What are the top products by revenue?
4. Which categories generate the most revenue?
5. Who are the highest-value customers?
6. Which customers are repeat buyers?
7. What percentage of customers have never purchased?
8. What is the average order value?
9. What is the profit margin by product?
10. Which products have declining monthly sales?
11. What are the top 3 products in every category?
12. Which customers belong to high-value segments?
13. What is customer lifetime value?
14. What is the average delivery time?
15. Which payment methods are used most?
16. Which products have low stock but high sales?
17. Which products have never been reviewed?
18. What is the first-purchase month distribution?
19. What is the revenue contribution of each category?
20. Which cities generate the most revenue?

## How To Run

Create a database:

```sql
CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;
```

Run the files in this order:

```text
1. database/01_schema.sql
2. database/02_seed_data.sql
3. views/analytics_views.sql
4. procedures/reporting_procedures.sql
5. optimization/indexes_and_explain.sql
6. queries/*.sql
```

## Advanced SQL Demonstrated

### CTE

```sql
WITH customer_spend AS (
    SELECT customer_id, SUM(total_amount) AS spend
    FROM orders
    WHERE status = 'DELIVERED'
    GROUP BY customer_id
)
SELECT *
FROM customer_spend
WHERE spend > 1000;
```

### Window Function

```sql
SELECT
    product_name,
    category_name,
    revenue,
    RANK() OVER (
        PARTITION BY category_name
        ORDER BY revenue DESC
    ) AS category_rank
FROM vw_product_performance;
```

### Customer Segmentation

Customers are segmented using lifetime spend and order frequency:

- VIP
- High Value
- Regular
- New
- Inactive

## Portfolio Value

This repository is intentionally designed to show **practical SQL**, not only syntax. The queries are organized around business problems that appear in analytics, backend and software-engineering interviews.

## Future Improvements

- Connect a React dashboard
- Add a Node.js REST API
- Add automated ETL
- Add a larger public dataset
- Add scheduled reporting
- Add Power BI/Tableau visualization
