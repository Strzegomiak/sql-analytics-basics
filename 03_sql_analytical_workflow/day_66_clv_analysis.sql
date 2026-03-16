-- ============================================
-- Day 66 - Customer Lifetime Value (CLV)
-- PostgreSQL
-- ============================================

-- ============================================
-- Task 1
-- Customer lifetime revenue per customer
-- ============================================

SELECT
    customer_id,
    MIN(transaction_date) AS first_transaction_date,
    MAX(transaction_date) AS last_transaction_date,
    MAX(transaction_date) - MIN(transaction_date) AS customer_lifetime_days,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_revenue
FROM transactions
GROUP BY customer_id
ORDER BY customer_id;


-- ============================================
-- Task 2
-- Average customer metrics at company level
-- ============================================

WITH customer_metric AS (
    SELECT
        customer_id,
        MIN(transaction_date) AS first_transaction_date,
        MAX(transaction_date) AS last_transaction_date,
        MAX(transaction_date) - MIN(transaction_date) AS customer_lifetime_days,
        COUNT(*) AS total_transactions,
        SUM(amount) AS total_revenue
    FROM transactions
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,
    ROUND(AVG(customer_lifetime_days), 2) AS avg_customer_lifetime_days,
    ROUND(AVG(total_transactions), 2) AS avg_transactions_per_customer,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM customer_metric;


-- ============================================
-- Task 3
-- Estimated CLV proxy
-- CLV ≈ avg_transactions_per_customer * avg_revenue_per_transaction
-- ============================================

WITH customer_metric AS (
    SELECT
        customer_id,
        COUNT(*) AS total_transactions
    FROM transactions
    GROUP BY customer_id
),
transaction_metric AS (
    SELECT
        ROUND(AVG(amount), 2) AS avg_revenue_per_transaction
    FROM transactions
)

SELECT
    ROUND(AVG(total_transactions), 2) AS avg_transactions_per_customer,
    avg_revenue_per_transaction,
    ROUND(AVG(total_transactions) * avg_revenue_per_transaction, 2) AS estimated_clv
FROM customer_metric
CROSS JOIN transaction_metric
GROUP BY avg_revenue_per_transaction;


-- ============================================
-- Task 4
-- Real CLV distribution by customer
-- Quartile 1 = lowest CLV
-- Quartile 4 = highest CLV
-- ============================================

SELECT
    customer_id,
    SUM(amount) AS customer_clv,
    NTILE(4) OVER (ORDER BY SUM(amount)) AS clv_quartile
FROM transactions
GROUP BY customer_id
ORDER BY customer_clv DESC;


-- ============================================
-- Task 5
-- Business insight
-- The most valuable customers are those with the highest lifetime revenue.
-- ============================================



-- ============================================
-- Optional summary query
-- Full customer CLV table with lifetime metrics
-- ============================================

SELECT
    customer_id,
    MIN(transaction_date) AS first_transaction_date,
    MAX(transaction_date) AS last_transaction_date,
    MAX(transaction_date) - MIN(transaction_date) AS customer_lifetime_days,
    COUNT(*) AS total_transactions,
    ROUND(AVG(amount), 2) AS avg_transaction_value,
    SUM(amount) AS customer_clv
FROM transactions
GROUP BY customer_id
ORDER BY customer_clv DESC;
