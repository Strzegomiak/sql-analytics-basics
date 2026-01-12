-- Day 14: SQL Summary & Mini Project
-- Tables assumed:
-- customers(customer_id, customer_name)
-- transactions(transaction_id, customer_id, transaction_date, amount)

-- ------------------------------------------------------------
-- Task 1: Monthly performance analysis
-- This query shows monthly transaction activity and total revenue.
-- It classifies each month as busy or quiet based on transaction volume.
SELECT
    DATE_TRUNC('month', t.transaction_date) AS month,
    COUNT(*) AS transactions_volume_per_month,
    COALESCE(SUM(t.amount), 0) AS revenue_per_month,
    CASE
        WHEN COUNT(*) >= 5 THEN 'busy'
        ELSE 'quiet'
    END AS volume_category
FROM transactions t
GROUP BY DATE_TRUNC('month', t.transaction_date)
ORDER BY month;

-- ------------------------------------------------------------
-- Task 2: Customer revenue overview
-- This query calculates total revenue per customer, including customers with no transactions.
-- The result is sorted in descending order by customer revenue.
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(t.amount), 0) AS customer_revenue
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY customer_revenue DESC;

-- ------------------------------------------------------------
-- Task 3: Transaction value structure (refactored with a subquery)
-- This query shows the distribution of high-value and low-value transactions.
-- Transactions are classified using an amount threshold (>= 200).
SELECT
    sub.transaction_category,
    COUNT(*) AS number_of_transactions
FROM (
    SELECT
        CASE
            WHEN COALESCE(amount, 0) >= 200 THEN 'high'
            ELSE 'low'
        END AS transaction_category
    FROM transactions
) sub
GROUP BY sub.transaction_category
ORDER BY number_of_transactions DESC;
