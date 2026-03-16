-- DAY 45
-- FIRST_VALUE / LAST_VALUE + window frames (Pitfall #2)
-- Goal:
-- Understand why LAST_VALUE is misleading with the default window frame
-- and how to correctly retrieve the last value in a partition.

------------------------------------------------------------
-- Task A
-- Show the first transaction amount per customer
-- FIRST_VALUE works correctly with the default frame
------------------------------------------------------------

SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  FIRST_VALUE(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
  ) AS first_transaction_amount
FROM transactions;

------------------------------------------------------------
-- Task B
-- Demonstration of the LAST_VALUE pitfall
-- With the default frame:
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- LAST_VALUE returns the current row value instead of the true last value
------------------------------------------------------------

SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  LAST_VALUE(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date
  ) AS last_value_wrong
FROM transactions;

------------------------------------------------------------
-- Task C
-- Correct usage of LAST_VALUE
-- The window frame is explicitly extended to the end of the partition
------------------------------------------------------------

SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  LAST_VALUE(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS last_transaction_amount
FROM transactions;

------------------------------------------------------------
-- Task D
-- Compare each transaction to:
-- 1) the first transaction amount of the customer
-- 2) the last transaction amount of the customer
-- All calculations are done using window functions only
------------------------------------------------------------

WITH transaction_metrics AS (
  SELECT
    transaction_id,
    customer_id,
    transaction_date,
    amount,
    FIRST_VALUE(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS first_transaction_amount,
    LAST_VALUE(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_transaction_amount
  FROM transactions
)
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  first_transaction_amount,
  last_transaction_amount,
  amount - first_transaction_amount AS diff_vs_first_transaction,
  amount - last_transaction_amount AS diff_vs_last_transaction
FROM transaction_metrics;
