-- =========================================================
-- Day 50
-- Topic: Conditional analytics with window functions
-- File: day_50_conditional_window_functions.sql
-- =========================================================


-- ---------------------------------------------------------
-- Task A
-- Show transaction-level data together with a running sum
-- of only positive transaction amounts per customer.
-- Negative and NULL amounts should be ignored in the sum,
-- but all rows must remain visible.
-- ---------------------------------------------------------

SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  SUM(amount) FILTER (WHERE amount > 0) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_positive_amount
FROM transactions
ORDER BY customer_id, transaction_date;


-- ---------------------------------------------------------
-- Task B
-- Compare total number of transactions per customer
-- with the number of transactions that have a non-NULL
-- amount value.
-- ---------------------------------------------------------

SELECT
  transaction_id,
  customer_id,
  amount,
  COUNT(*) OVER (
    PARTITION BY customer_id
  ) AS all_transactions,
  COUNT(amount) OVER (
    PARTITION BY customer_id
  ) AS non_null_amount_transactions
FROM transactions
ORDER BY customer_id, transaction_id;


-- ---------------------------------------------------------
-- Task C
-- Calculate the share of positive transactions in the
-- entire transaction history of each customer.
-- The result should be a decimal value.
-- ---------------------------------------------------------

SELECT
  transaction_id,
  customer_id,
  amount,
  COUNT(*) FILTER (WHERE amount > 0) OVER (
    PARTITION BY customer_id
  ) * 1.0
  / COUNT(*) OVER (
    PARTITION BY customer_id
  ) AS positive_transaction_ratio
FROM transactions
ORDER BY customer_id, transaction_id;


-- ---------------------------------------------------------
-- Task D
-- Classify each transaction based on customer history
-- and transaction properties:
-- - first_transaction
-- - missing_amount
-- - positive
-- - negative
-- ---------------------------------------------------------

SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  CASE
    WHEN ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date
    ) = 1 THEN 'first_transaction'
    WHEN amount IS NULL THEN 'missing_amount'
    WHEN amount > 0 THEN 'positive'
    ELSE 'negative'
  END AS transaction_type
FROM transactions
ORDER BY customer_id, transaction_date;
