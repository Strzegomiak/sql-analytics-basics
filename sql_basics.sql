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
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS monthly_revenue
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;
