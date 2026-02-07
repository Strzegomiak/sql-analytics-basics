-- Day 39 — Window frames (ROWS vs RANGE) + LAG + “average between customers”
-- Notes:
-- 1) ROWS counts physical rows (e.g., current row + 2 previous rows).
-- 2) RANGE counts a value range in the ORDER BY expression (e.g., last 6 days if ORDER BY is a date/timestamp).
-- 3) If ORDER BY is not unique (same date appears multiple times), add a tie-breaker for deterministic results
--    (e.g., transaction_id) — especially for ROWS/LAG.

------------------------------------------------------------
-- Task A
-- Rolling SUM for each customer: current transaction + 2 previous transactions (ROWS frame).
------------------------------------------------------------
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS sum_amount_current_plus_2_prev_rows
FROM transactions;

------------------------------------------------------------
-- Task B
-- Rolling SUM for each customer: transactions from the last 6 days up to the current row (RANGE frame).
-- IMPORTANT: For date/timestamp ORDER BY in PostgreSQL, use an INTERVAL.
-- This is NOT the same as "6 previous rows".
------------------------------------------------------------
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date
    RANGE BETWEEN INTERVAL '6 days' PRECEDING AND CURRENT ROW
  ) AS sum_amount_last_6_days_including_today
FROM transactions;

------------------------------------------------------------
-- Task C
-- Difference vs previous transaction (per customer).
-- Option 1 (recommended): return NULL when there is no previous transaction or current amount is NULL.
------------------------------------------------------------
WITH transaction_metric AS (
  SELECT
    transaction_id,
    customer_id,
    transaction_date,
    amount,
    LAG(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS preceding_amount
  FROM transactions
)
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  preceding_amount,
  CASE
    WHEN amount IS NULL OR preceding_amount IS NULL THEN NULL
    ELSE amount - preceding_amount
  END AS diff_amount_vs_preceding
FROM transaction_metric;

-- Option 2 (only if business wants NULL treated as 0):
-- COALESCE(amount, 0) - COALESCE(preceding_amount, 0) AS diff_amount_vs_preceding

------------------------------------------------------------
-- Task D
-- “Average between customers”:
-- 1) compute AVG(amount) per customer
-- 2) then average those customer-level averages
-- This is NOT the same as AVG(amount) over all transactions.
------------------------------------------------------------
WITH customer_metric AS (
  SELECT
    customer_id,
    AVG(amount) AS avg_revenue_per_customer
  FROM transactions
  GROUP BY customer_id
)
SELECT
  AVG(avg_revenue_per_customer) AS avg_between_customers
FROM customer_metric;
