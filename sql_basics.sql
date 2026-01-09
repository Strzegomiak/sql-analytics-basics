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

ZADANIE A:
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS revenue_of_month
FROM transactions
GROUP BY DATE_TRUNK('month', transaction_date)
ORDER BY SUM(amount) DESC;
-- Query shows total revenue per month
-- Data is grouped by months
-- Result is sorted from the highest revenue per month 

ZADANIE B:
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS numbers_of_transaction_monthly
FROM transactions
GROUP BY DATE_TRUNK('month', transaction_date)
ORDER BY COUNT(*) DESC;
-- Query shows how many  transactions were per month
-- Data is grouped by months
-- Result is sorted from the highest number of transaction monthly

ZADANIE C
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    AVG(amount) AS average_amount_by_month
FROM transactions
GROUP BY DATE_TRUNK('month', transaction_date)
ORDER BY AVG(amount) DESC;
-- Query shows average amount of transaction per month
-- Data is grouped by months
-- Result is sorted from the highest average amount of transaction per month 










