-- =========================================================
-- Day 51
-- Topic: Window ratios & percentages (KPI-style metrics)
-- File: day_51_window_ratios.sql
-- =========================================================


-- ---------------------------------------------------------
-- Task A
-- Show each transaction together with:
-- - customer_total_amount
-- - customer_paid_amount
-- - customer_paid_share = paid / total
--
-- Notes:
-- - Keep transaction grain (no GROUP BY)
-- - Use NULLIF to avoid division by zero
-- ---------------------------------------------------------

WITH customer_metric AS (
  SELECT
    transaction_id,
    customer_id,
    transaction_date,
    status,
    amount,

    SUM(amount) OVER (
      PARTITION BY customer_id
    ) AS customer_total_amount,

    SUM(amount) FILTER (WHERE status = 'paid') OVER (
      PARTITION BY customer_id
    ) AS customer_paid_amount
  FROM transactions
)
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  status,
  amount,
  customer_total_amount,
  customer_paid_amount,
  customer_paid_amount * 1.0 / NULLIF(customer_total_amount, 0) AS customer_paid_share
FROM customer_metric
ORDER BY customer_id, transaction_date, transaction_id;



-- ---------------------------------------------------------
-- Task B
-- Show each transaction together with:
-- - global_total_amount
-- - customer_total_amount
-- - customer_share_of_global = customer_total / global_total
--
-- Notes:
-- - Keep transaction grain (no GROUP BY)
-- - Use NULLIF to avoid division by zero
-- ---------------------------------------------------------

WITH customer_metric AS (
  SELECT
    transaction_id,
    customer_id,
    transaction_date,
    status,
    amount,

    SUM(amount) OVER () AS global_total_amount,

    SUM(amount) OVER (
      PARTITION BY customer_id
    ) AS customer_total_amount
  FROM transactions
)
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  status,
  amount,
  global_total_amount,
  customer_total_amount,
  customer_total_amount * 1.0 / NULLIF(global_total_amount, 0) AS customer_share_of_global
FROM customer_metric
ORDER BY customer_id, transaction_date, transaction_id;



-- ---------------------------------------------------------
-- Task C
-- Show running (cumulative) KPI per customer over time:
-- - running_total_amount
-- - running_paid_amount
-- - running_paid_ratio = running_paid / running_total
--
-- Notes:
-- - Use deterministic order: transaction_date, transaction_id
-- - Use ROWS frame to make the running calculation explicit
-- ---------------------------------------------------------

WITH customer_metric AS (
  SELECT
    transaction_id,
    customer_id,
    transaction_date,
    status,
    amount,

    SUM(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_amount,

    SUM(amount) FILTER (WHERE status = 'paid') OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_paid_amount
  FROM transactions
)
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  status,
  amount,
  running_total_amount,
  running_paid_amount,
  running_paid_amount * 1.0 / NULLIF(running_total_amount, 0) AS running_paid_ratio
FROM customer_metric
ORDER BY customer_id, transaction_date, transaction_id;



-- ---------------------------------------------------------
-- Task D
-- Return one row per customer:
-- - customer_total_amount
-- - customer_paid_amount
-- - paid_ratio = paid / total
-- - segment:
--     high   >= 0.80
--     medium >= 0.50
--     low    <  0.50
--
-- Notes:
-- - Here we intentionally change grain to customer level (GROUP BY)
-- - Use NULLIF to avoid division by zero
-- ---------------------------------------------------------

WITH customer_metric AS (
  SELECT
    customer_id,
    SUM(amount) AS customer_total_amount,
    SUM(amount) FILTER (WHERE status = 'paid') AS customer_paid_amount,
    SUM(amount) FILTER (WHERE status = 'paid') * 1.0 / NULLIF(SUM(amount), 0) AS paid_ratio
  FROM transactions
  GROUP BY customer_id
)
SELECT
  customer_id,
  customer_total_amount,
  customer_paid_amount,
  paid_ratio,
  CASE
    WHEN paid_ratio >= 0.80 THEN 'high'
    WHEN paid_ratio >= 0.50 THEN 'medium'
    ELSE 'low'
  END AS segment
FROM customer_metric
ORDER BY paid_ratio DESC NULLS LAST, customer_id;
