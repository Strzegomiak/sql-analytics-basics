-- ============================================================
-- Day 56 — Advanced Window Framing & Business Logic Thinking
-- Dataset: transactions(transaction_id, customer_id, transaction_date, amount, status)
-- SQL dialect: PostgreSQL
-- ============================================================


-- ============================================================
-- Task A — Rolling 3-transaction revenue per customer
-- For each transaction, compute sum(amount) of the current row + 2 previous rows
-- Deterministic ordering: transaction_date, transaction_id
-- ============================================================

SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS rolling_sum_last_3_transactions
FROM transactions;


-- ============================================================
-- Task B — Detect the first transaction per customer
-- IMPORTANT: Use ROW_NUMBER to guarantee exactly ONE "first" row per customer
-- (If multiple transactions share the same earliest date, MIN(date) would flag all of them.)
-- ============================================================

SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  CASE
    WHEN ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) = 1 THEN 1
    ELSE 0
  END AS is_first_transaction
FROM transactions;


-- ============================================================
-- Task C — Running share of customer lifetime value
-- For each transaction:
--   running_total_customer / total_customer_lifetime
-- Uses a window frame for running sum (UNBOUNDED PRECEDING .. CURRENT ROW).
-- ============================================================

WITH customer_metric AS (
  SELECT
    transaction_id,
    customer_id,
    transaction_date,
    amount,
    SUM(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_customer,
    SUM(amount) OVER (
      PARTITION BY customer_id
    ) AS total_customer_lifetime
  FROM transactions
)
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  running_total_customer * 1.0 / NULLIF(total_customer_lifetime, 0) AS customer_running_share
FROM customer_metric;


-- ============================================================
-- Task D — Business question
-- "What % of customers have more than 50% of their revenue in 'paid' status?"
-- Steps:
--  1) Aggregate revenue per customer
--  2) Compute paid_share per customer
--  3) Count customers with share > 0.5 and divide by all customers
-- ============================================================

WITH customer_metric AS (
  SELECT
    customer_id,
    SUM(amount) AS total_revenue_per_customer,
    SUM(amount) FILTER (WHERE status = 'paid') AS paid_revenue_per_customer
  FROM transactions
  GROUP BY customer_id
),
customer_paid_share_metric AS (
  SELECT
    customer_id,
    paid_revenue_per_customer * 1.0 / NULLIF(total_revenue_per_customer, 0) AS customer_paid_share
  FROM customer_metric
)
SELECT
  COUNT(*) FILTER (WHERE customer_paid_share > 0.5) * 1.0 / COUNT(*) AS pct_customers_paid_share_above_50
  -- If you want percent points (0–100), multiply by 100.0:
  -- , (COUNT(*) FILTER (WHERE customer_paid_share > 0.5) * 100.0 / COUNT(*)) AS pct_points
FROM customer_paid_share_metric;
