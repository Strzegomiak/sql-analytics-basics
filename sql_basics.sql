-- ============================================
-- SQL BASICS – ANALYTICS QUERIES
-- Author: Lukasz
-- Purpose: Business metrics (transactions, revenue, time analysis)
-- ============================================

-- Assumed table: transactions
-- Columns:
--   transaction_id      (unique id)
--   transaction_date    (date/time of transaction)
--   amount              (transaction value, positive numbers assumed)

-- --------------------------------------------
-- 1) NUMBER OF TRANSACTIONS
-- What it answers:
--   How many transactions happened in total?
-- Business use:
--   Measures activity / operational volume (independent from revenue).
-- --------------------------------------------
SELECT
    COUNT(*) AS number_of_transactions
FROM transactions;

-- --------------------------------------------
-- 2) TOTAL REVENUE
-- What it answers:
--   How much revenue did we generate in total?
-- Business use:
--   Core financial metric (overall performance).
-- --------------------------------------------
SELECT
    SUM(amount) AS total_revenue
FROM transactions;

-- --------------------------------------------
-- 3) REVENUE PER MONTH
-- What it answers:
--   How does revenue change over time (month by month)?
-- Business use:
--   Trend + seasonality + reporting.
--

-- --------------------------------------------
-- Task 1: Daily revenue
-- This query calculates the total revenue for each day by summing transaction amounts
-- and orders the results by transaction date.
SELECT
    transaction_date AS day,
    SUM(amount) AS daily_revenue
FROM transactions
GROUP BY transaction_date
ORDER BY transaction_date;

-- Task 2: Number of transactions per month
-- This query counts the number of transactions for each month and orders the results
-- chronologically from the earliest month.
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;

-- Task 3: Monthly revenue (descending order)
-- This query calculates total monthly revenue by summing transaction amounts
-- and sorts the results in descending order by month.
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS monthly_revenue
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month DESC;
-- --------------------------------------------
-- Day 4: GROUP BY + HAVING

-- Months with more than 3 transactions
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS number_of_transaction_in_month
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
HAVING COUNT(*) > 3
ORDER BY DATE_TRUNC('month', transaction_date);

-- Months with revenue above 1000
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS number_of_transaction_in_month
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
HAVING SUM(amount)>1000
ORDER BY DATE_TRUNC('month', transaction_date);
-- Months with high average transaction value above 200
 SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    AVG(amount) AS avg_of_transaction_in_month
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
HAVING AVG(amount) > 200
ORDER BY AVG(amount) DESC;
    
-- ================================
-- Day 5-6: WHERE vs HAVING, query logic
-- ================================


-- 1. Monthly revenue from transactions with amount > 100
-- Filters rows BEFORE aggregation
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS revenue
FROM transactions
WHERE amount > 100
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;


-- 2. Monthly revenue for months with total revenue > 100
-- Filters groups AFTER aggregation
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS revenue
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
HAVING SUM(amount) > 100
ORDER BY month;


-- 3. Reading and understanding a complex query
-- Shows months with at least 3 transactions (amount > 50),
-- sorted by highest average transaction value
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS transactions_count,
    AVG(amount) AS avg_amount
FROM transactions
WHERE amount > 50
GROUP BY DATE_TRUNC('month', transaction_date)
HAVING COUNT(*) >= 3
ORDER BY avg_amount DESC;

-- 4. Mini task: transactions per month
-- Only transactions with amount > 200
-- Only months with at least 2 transactions
-- Sorted by number of transactions (descending)
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS amount_of_transactions_per_month
FROM transactions
WHERE amount > 200
GROUP BY DATE_TRUNC('month', transaction_date)
HAVING COUNT(*) >= 2
ORDER BY amount_of_transactions_per_month DESC;

-- Total number of transactions
SELECT COUNT(*) AS total_transactions
FROM transactions;

-- Total revenue
SELECT SUM(amount) AS total_revenue
FROM transactions;

-- Monthly revenue
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS monthly_revenue
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;

-- Months with more than 2 transactions
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
HAVING COUNT(*) > 2
ORDER BY month;

-- Average transaction value per month
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    AVG(amount) AS avg_transaction_value
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY avg_transaction_value DESC;

-- This last query calculates the average transaction value per month.
-- First, it selects data from the transactions table.
-- Then, it truncates the transaction_date to month level using the DATE_TRUNC function.
-- Next, the data is grouped by month and the average amount is calculated for each month.
-- Finally, the results are ordered from the highest to the lowest average transaction value.

-- ================================
-- Day 8 repeat day - Monthly revenue analysis
-- ================================

-- Assumed table: transactions
-- Columns:
--   transaction_id      (unique id)
--   transaction_date    (date/time of transaction)
--   amount              (transaction value, positive numbers assumed)

SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS monthly_revenue
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY monthly_revenue DESC;

-- This query shows the total revenue per month.
-- The data is grouped by month using the DATE_TRUNC function.
-- The result is ordered from the highest to the lowest monthly revenue.
-- Day 8 – Task B: Number of transactions per month

SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS number_of_transactions
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY number_of_transactions DESC;

-- This query shows the number of transactions per month.
-- The data is grouped by month.
-- The result is ordered from the highest to the lowest number of transactions.

-- Day 8 – Task C: Average transaction value per month

SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    AVG(amount) AS average_transaction_value
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY average_transaction_value DESC;

-- This query calculates the average transaction value per month.
-- The data is grouped by month.
-- The result is ordered from the highest to the lowest average transaction value.

-- ================================
-- Day 9 repeat day  
-- ================================

SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS transactions_per_month
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date) 
HAVING COUNT(*) > 3
ORDER BY month; (świadomy wybór aby użyć)

-- This query shows the number of transactions per month.
-- The data comes from the transactions table.
-- Transactions are grouped by month using the DATE_TRUNC function.
-- It filters to months with more than 3 transactions (HAVING COUNT(*) > 3).
-- The results are ordered by month in ascending order.


SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS total_amount_per_month
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date) 
HAVING SUM(amount) > 1000
ORDER BY month DESC;

-- This query calculates total revenue (SUM(amount)) per month.
-- The data comes from the transactions table.
-- Transactions are grouped by month using the DATE_TRUNC function.
-- It filters to months where total revenue is greater than 1000.
-- The results are ordered by month in descending order.

SELECT 
    DATE_TRUNC('month', transaction_date) AS month,
    AVG(amount) AS average_amount_per_month
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date) 
ORDER BY average_amount_per_month DESC;

-- This query calculates the average transaction value per month.
-- The data comes from the transactions table.
-- Transactions are grouped by month using the DATE_TRUNC function.
-- The results are ordered from the highest to the lowest average value.

-- ============================================
-- Day 10 & 11 — CASE WHEN (business logic in SQL)
-- Database: PostgreSQL (works similarly in other SQL dialects)
-- Table: transactions
-- Assumed columns:
--   - transaction_date (date / timestamp)
--   - amount (numeric)
-- ============================================


-- 1) Label each transaction as high/low value
-- Business idea: classify single transactions based on amount.
SELECT
    transaction_date,
    amount,
    CASE
        WHEN amount >= 200 THEN 'high'
        ELSE 'low'
    END AS transaction_category
FROM transactions
ORDER BY transaction_date;


-- 2) Count transactions by category (high vs low)
-- Business idea: compare how many transactions fall into each segment.
SELECT
    CASE
        WHEN amount >= 200 THEN 'high'
        ELSE 'low'
    END AS transaction_category,
    COUNT(*) AS number_of_transactions
FROM transactions
GROUP BY
    CASE
        WHEN amount >= 200 THEN 'high'
        ELSE 'low'
    END
ORDER BY number_of_transactions DESC;


-- 3) Segment transactions into small / medium / large
-- Business idea: create 3 value buckets (typical segmentation).
SELECT
    amount,
    CASE
        WHEN amount < 100 THEN 'small'
        WHEN amount BETWEEN 100 AND 300 THEN 'medium'
        ELSE 'large'
    END AS transaction_size
FROM transactions
ORDER BY amount;


-- 4) Count transactions by size (small / medium / large)
SELECT
    CASE
        WHEN amount < 100 THEN 'small'
        WHEN amount BETWEEN 100 AND 300 THEN 'medium'
        ELSE 'large'
    END AS transaction_size,
    COUNT(*) AS number_of_transactions
FROM transactions
GROUP BY
    CASE
        WHEN amount < 100 THEN 'small'
        WHEN amount BETWEEN 100 AND 300 THEN 'medium'
        ELSE 'large'
    END
ORDER BY number_of_transactions DESC;


-- 5) Monthly transaction count + activity label (busy / quiet)
-- Business idea: label each month depending on volume of transactions.
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS transactions_count,
    CASE
        WHEN COUNT(*) >= 5 THEN 'busy'
        ELSE 'quiet'
    END AS month_activity
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;


-- 6) Monthly revenue + revenue label (high / low) with threshold 1000
-- Business idea: label each month depending on total revenue.
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS monthly_revenue,
    CASE
        WHEN SUM(amount) >= 1000 THEN 'high'
        ELSE 'low'
    END AS revenue_category
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;


-- 7) Cleaner version (recommended): compute CASE once in a subquery
-- Business idea: avoid repeating CASE in both SELECT and GROUP BY.
SELECT
    category AS transaction_category,
    COUNT(*) AS number_of_transactions
FROM (
    SELECT
        CASE
            WHEN amount >= 200 THEN 'high'
            ELSE 'low'
        END AS category
    FROM transactions
    ) t
GROUP BY category
ORDER BY number_of_transactions DESC;

-- ============================
-- Day 12 – Aggregation & CASE
-- ============================

-- 1. Monthly transaction count and revenue
-- This query shows the number of transactions and total revenue for each month,
-- allowing analysis of business trends over time.
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS transaction_count,
    SUM(amount) AS monthly_revenue
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;

-- 2. Busy months (high transaction volume)
-- This query identifies months with at least five transactions,
-- helping assess periods of high operational workload.
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
HAVING COUNT(*) >= 5
ORDER BY transaction_count DESC;

-- 3. Transaction value segmentation (high vs low)
-- This query classifies transactions into high and low value categories
-- and counts how many transactions fall into each segment.
SELECT
    transaction_category,
    COUNT(*) AS number_of_transactions
FROM (
    SELECT
        CASE
            WHEN amount >= 200 THEN 'high'
            ELSE 'low'
        END AS transaction_category
    FROM transactions
) t
GROUP BY transaction_category
ORDER BY number_of_transactions DESC;

-- ============================
-- Day 13 – JOIN fundamentals + business analysis (COUNT, SUM, NULL handling)
-- ============================

-- Goal: understand how LEFT JOIN keeps rows, how NULL appears, and how to aggregate safely.


-- 0A) Row-level view: customers + matching transactions (LEFT JOIN keeps all customers)
SELECT
    c.customer_id,
    c.customer_name,
    t.transaction_id,
    t.transaction_date,
    t.amount
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
ORDER BY c.customer_id, t.transaction_id;

-- 0B) Customers with no matching transaction rows (NULLs on the right side)
SELECT
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
WHERE t.transaction_id IS NULL
ORDER BY c.customer_id;


-- ============================================================
-- A) Transactions per customer
-- Business idea: show how many transactions each customer has, including 0.
-- Key point: COUNT(column) ignores NULL, so customers with no transactions get 0.
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(t.transaction_id) AS transaction_count
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY transaction_count DESC, c.customer_id;


-- ============================================================
-- B) Revenue per customer
-- Business idea: show total revenue generated by each customer, including 0.
-- Key point: SUM(...) can return NULL for customers with no transactions, so COALESCE converts NULL to 0.
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(t.amount), 0) AS total_revenue
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_revenue DESC, c.customer_id;


-- ============================================================
-- C) Customers without transactions
-- Business idea: identify customers who have no transaction records.
-- Key point: after LEFT JOIN, missing matches become NULL on the right side.
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
WHERE t.transaction_id IS NULL
ORDER BY c.customer_id;


-- ============================================================
-- D) (Optional) The "WHERE trap" demo: how WHERE can break LEFT JOIN
-- Business idea: understand why filtering the right table in WHERE can remove NULL rows,
-- which effectively turns LEFT JOIN into INNER JOIN for that condition.
-- ============================================================

-- D1) This keeps ONLY customers who have matching transactions with amount > 0.
-- Customers with no transactions disappear because t.amount is NULL and NULL > 0 is not true.
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(t.amount), 0) AS total_revenue_amount_gt_0
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
WHERE t.amount > 0
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_revenue_amount_gt_0 DESC, c.customer_id;

-- D2) Safer pattern: keep all customers, but filter the joined rows inside ON.
-- This preserves customers with no matching transactions (they will still appear with 0).
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(t.amount), 0) AS total_revenue_amount_gt_0
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
   AND t.amount > 0
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_revenue_amount_gt_0 DESC, c.customer_id;


