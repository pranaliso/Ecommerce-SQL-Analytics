# Business Analysis Report

## KPI Layer

The project can produce:

- Completed orders
- Purchasing customers
- Units sold
- Revenue
- Cost
- Gross profit
- Gross margin

## Customer Layer

Useful metrics:

- Lifetime value
- Average order value
- Repeat purchase rate
- Last purchase date
- Customer segment
- Categories purchased

## Product Layer

Useful metrics:

- Units sold
- Revenue
- Gross profit
- Profit margin
- Average rating
- Review count
- Stock risk

## Operational Layer

Useful metrics:

- Orders by status
- Payment method distribution
- Low-stock products
- High-demand products
- City-level revenue

## Interview Questions Demonstrated

### Find the second-highest customer spend

Use a ranking/window-function approach rather than relying only on `LIMIT`.

### Find top 3 products per category

Use `DENSE_RANK()` with `PARTITION BY category`.

### Calculate month-over-month growth

Use `LAG()` over monthly revenue.

### Find customers with no purchases

Use `NOT EXISTS` or a `LEFT JOIN ... IS NULL` pattern.

### Find products above their category average

Use a correlated subquery.

### Calculate customer lifetime value

Aggregate delivered order-item revenue by customer.

### Identify low-stock high-demand products

Combine inventory thresholds with historical sales.

## Suggested GitHub Screenshot Set

1. ER/database schema
2. `vw_customer_360` result
3. Monthly revenue + growth result
4. Top 3 products per category
5. Customer segmentation
6. Profitability report
