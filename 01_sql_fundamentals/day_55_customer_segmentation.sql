/*
Day 55 — Customer segmentation (RFM foundations) — Part 1
Focus:
- Frequency: transaction count per customer
- Monetary: total + average amount per customer
- Recency: days since previous transaction
- First/last transaction date per customer

Table:
transactions(transaction_id, customer_id, transaction_date, amount)
*/

-- =========================================================
-- Task A — Frequency: number of transactions per customer
-- (Window function keeps transaction-level granularity)
-- =========================================================
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  COUNT(*) OVER (PARTITION BY customer_id) AS transaction_count_per_customer
FROM transactions;


-- =========================================================
-- Task B — Monetary: total revenue + average transaction
-- a) Window version (transaction-level view)
-- =========================================================
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  SUM(amount) OVER (PARTITION BY customer_id) AS total_revenue_customer,
  AVG(amount) OVER (PARTITION BY customer_id) AS average_transaction_customer
FROM transactions;

-- b) Grouped version (customer-level table)
SELECT
  customer_id,
  SUM(amount) AS total_revenue_customer,
  AVG(amount) AS average_transaction_customer
FROM transactions
GROUP BY customer_id;


-- =========================================================
-- Task C — Recency: time since previous transaction
-- Notes:
-- - We order by transaction_date AND transaction_id for deterministic ordering.
-- - If transaction_date is DATE, subtraction gives an integer (days).
-- - If transaction_date is TIMESTAMP, subtraction gives an INTERVAL,
--   so we extract days explicitly (PostgreSQL-safe).
-- =========================================================
WITH t AS (
  SELECT
    transaction_id,
    customer_id,
    amount,
    transaction_date,
    LAG(transaction_date) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS previous_transaction_date
  FROM transactions
)
SELECT
  transaction_id,
  customer_id,
  amount,
  transaction_date,
  previous_transaction_date,
  CASE
    WHEN previous_transaction_date IS NULL THEN NULL
    -- PostgreSQL-safe for timestamps; also works fine for dates
    ELSE EXTRACT(DAY FROM (transaction_date - previous_transaction_date))
  END AS days_since_last_transaction
FROM t;


-- =========================================================
-- Task D — First and last transaction date per customer
-- Window MIN/MAX (adds customer-level context to each transaction row)
-- =========================================================
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  MIN(transaction_date) OVER (PARTITION BY customer_id) AS first_transaction_date_customer,
  MAX(transaction_date) OVER (PARTITION BY customer_id) AS last_transaction_date_customer
FROM transactions;
