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
-- NOTE:
--   This version is for PostgreSQL (DATE_TRUNC).
--   If you use MySQL, tell me and I'll paste the MySQL variant.
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




