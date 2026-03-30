/*
CASE STUDY 1
Sales performance analysis

Goal:
Prepare analytical datasets to evaluate sales performance in 2025.

Dataset:
transactions table containing transactional sales data.

Metrics include:
- revenue trends
- customer ranking
- product performance
- revenue share
*/


/* =====================================================
CHECK DATA
Quick preview of dataset structure and values
===================================================== */

SELECT *
FROM transactions;



/* =====================================================
TASK 1
Monthly revenue metrics by category

Business goal:
Understand how revenue changes over time and compare performance between product categories.

Metrics:
- total revenue
- number of transactions
- average order value
- number of unique customers
===================================================== */

SELECT 
    DATE_TRUNC('month', transaction_date) AS month,   -- first day of month
    category,
    SUM(amount) AS total_revenue,                    -- total sales value
    COUNT(*) AS transactions_cnt,                    -- number of transactions
    AVG(amount) AS avg_order_value,                  -- average value per transaction
    COUNT(DISTINCT customer_id) AS unique_customers  -- number of unique customers
FROM transactions
WHERE transaction_date >= '2025-01-01'
  AND transaction_date <= '2025-12-31'
GROUP BY 1,2
ORDER BY month, category;



/* =====================================================
TASK 2
Month-over-month revenue change

Business goal:
Identify growth or decline trends within each category.

Technique:
LAG() window function to compare current month revenue
with previous month revenue within the same category.
===================================================== */

WITH month_metric AS (
SELECT 
    DATE_TRUNC('month', transaction_date) AS month,
    category,
    SUM(amount) AS total_revenue,

    LAG(SUM(amount)) 
    OVER (
        PARTITION BY category
        ORDER BY DATE_TRUNC('month', transaction_date)
    ) AS prev_month_revenue

FROM transactions
WHERE transaction_date >= '2025-01-01'
  AND transaction_date <= '2025-12-31'
GROUP BY 1,2
)

SELECT
    month,
    category,
    total_revenue,

    total_revenue - prev_month_revenue
        AS revenue_change_vs_prev_month

FROM month_metric
ORDER BY month, category;



/* =====================================================
TASK 3
Customer revenue ranking

Business goal:
Identify top customers generating the highest revenue.

Technique:
Aggregation + DENSE_RANK window function.
Customers with equal revenue share the same rank.
===================================================== */

SELECT 
    customer_id,
    customer_name,
    city,

    SUM(amount) AS total_revenue,

    DENSE_RANK()
    OVER (
        ORDER BY SUM(amount) DESC
    ) AS revenue_rank

FROM transactions
WHERE transaction_date >= '2025-01-01'
  AND transaction_date <= '2025-12-31'

GROUP BY
    customer_id,
    customer_name,
    city

ORDER BY
    revenue_rank,
    customer_name;



/* =====================================================
TASK 4
Product performance and revenue share

Business goal:
Evaluate which products contribute the most to total company revenue.

Technique:
Window function to calculate total company revenue
and compute percentage share per product.
===================================================== */

WITH product_metric AS (

SELECT 
    product,
    category,

    SUM(amount) AS total_revenue,
    COUNT(*) AS transactions_cnt,

    SUM(SUM(amount)) OVER()
        AS total_company_revenue

FROM transactions
WHERE transaction_date >= '2025-01-01'
  AND transaction_date <= '2025-12-31'

GROUP BY
    product,
    category
)

SELECT
    product,
    category,

    total_revenue,
    transactions_cnt,

    ROUND(
        100.0 * total_revenue
        / NULLIF(total_company_revenue,0),
        2
    ) AS revenue_share_pct

FROM product_metric
ORDER BY total_revenue DESC;