-- =========================================================
-- Day 49
-- Topic: Window Functions — FILTER + conditional aggregations
-- File: day_49_window_filter.sql
-- =========================================================


-- ---------------------------------------------------------
-- Task A
-- Show transaction-level rows with a running sum of PAID amounts
-- for each customer (only status = 'paid').
-- Make ordering deterministic when dates tie.
-- ---------------------------------------------------------
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  status,
  amount,
  SUM(amount) FILTER (WHERE status = 'paid') OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_paid_sum
FROM transactions
ORDER BY customer_id, transaction_date, transaction_id;


-- ---------------------------------------------------------
-- Task B
-- In one query, calculate two running sums per customer:
-- 1) running PAID sum
-- 2) running REFUNDED sum
-- (same window definition, different FILTER)
-- ---------------------------------------------------------
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  status,
  amount,

  SUM(amount) FILTER (WHERE status = 'paid') OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_paid_sum,

  SUM(amount) FILTER (WHERE status = 'refunded') OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_refunded_sum

FROM transactions
ORDER BY customer_id, transaction_date, transaction_id;


-- ---------------------------------------------------------
-- Task C
-- Same as Task B, but using CASE WHEN instead of FILTER.
-- Note: we keep the same window frame + deterministic ordering
-- so results match Task B exactly.
-- ---------------------------------------------------------
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  status,
  amount,

  SUM(
    CASE
      WHEN status = 'paid' THEN amount
      ELSE NULL
    END
  ) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_paid_sum,

  SUM(
    CASE
      WHEN status = 'refunded' THEN amount
      ELSE NULL
    END
  ) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_refunded_sum

FROM transactions
ORDER BY customer_id, transaction_date, transaction_id;


-- ---------------------------------------------------------
-- Bonus (optional)
-- Add a running count of FAILED transactions per customer
-- using FILTER (cleaner than CASE for counts).
-- ---------------------------------------------------------
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  status,
  amount,

  COUNT(*) FILTER (WHERE status = 'failed') OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_failed_count

FROM transactions
ORDER BY customer_id, transaction_date, transaction_id;
