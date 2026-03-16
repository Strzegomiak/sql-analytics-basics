 -- =========================================================
-- Day 48
-- Topic: Analytical thinking with window functions
-- File: day_48_window_functions.sql
-- =========================================================

-- ---------------------------------------------------------
-- Task A
-- Show transaction-level data together with
-- customer-level and global-level context
-- ---------------------------------------------------------
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,

  -- Total amount spent by this customer
  SUM(amount) OVER (
    PARTITION BY customer_id
  ) AS total_amount_per_customer,

  -- Total amount across all customers
  SUM(amount) OVER () AS total_amount_all_customers,

  -- Share of this transaction in customer's total amount
  amount * 1.0
    / SUM(amount) OVER (PARTITION BY customer_id)
    AS pct_of_customer_total
FROM transactions;


-- ---------------------------------------------------------
-- Task B
-- Rank customers by total amount spent
-- without losing transaction-level detail
-- ---------------------------------------------------------
SELECT
  transaction_id,
  customer_id,
  amount,

  -- Total amount per customer
  SUM(amount) OVER (
    PARTITION BY customer_id
  ) AS total_amount_per_customer,

  -- Customer ranking based on total amount
  RANK() OVER (
    ORDER BY SUM(amount) OVER (PARTITION BY customer_id) DESC
  ) AS customer_rank
FROM transactions;


-- ---------------------------------------------------------
-- Task C
-- Compare each transaction to the customer's
-- average transaction amount
-- ---------------------------------------------------------
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,

  -- Average transaction amount per customer
  AVG(amount) OVER (
    PARTITION BY customer_id
  ) AS avg_transaction_amount_per_customer,

  -- Difference between transaction and customer average
  amount
    - AVG(amount) OVER (PARTITION BY customer_id)
    AS diff_vs_customer_avg
FROM transactions;


-- ---------------------------------------------------------
-- Task D
-- Classify transactions based on deviation
-- from the customer's average transaction value
-- ---------------------------------------------------------
SELECT
  transaction_id,
  customer_id,
  amount,

  -- Average transaction amount per customer
  AVG(amount) OVER (
    PARTITION BY customer_id
  ) AS avg_transaction_amount,

  -- Transaction classification
  CASE
    WHEN amount >= 2 * AVG(amount) OVER (PARTITION BY customer_id)
      THEN 'high_outlier'
    WHEN amount <= 0.5 * AVG(amount) OVER (PARTITION BY customer_id)
      THEN 'low_outlier'
    ELSE 'normal'
  END AS transaction_flag
FROM transactions;


-- ---------------------------------------------------------
-- Task E
-- Compare transaction amount against
-- global average and customer average
-- ---------------------------------------------------------
SELECT
  transaction_id,
  customer_id,
  amount,

  -- Global average transaction amount
  AVG(amount) OVER () AS avg_amount_global,

  -- Customer-level average transaction amount
  AVG(amount) OVER (
    PARTITION BY customer_id
  ) AS avg_amount_per_customer,

  -- Difference vs global average
  amount - AVG(amount) OVER () AS diff_vs_global_avg,

  -- Difference vs customer average
