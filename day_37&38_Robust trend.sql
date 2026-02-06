 /* =========================
   DAY 37 — LAG() / LEAD() basics
   Topic: Compare current vs previous/next transaction
   ========================= */

/* Task A
   Show each transaction with the previous amount for the same customer.
   We add transaction_id as a tie-breaker to guarantee deterministic ordering
   when multiple transactions share the same date. */
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  LAG(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
  ) AS preceding_amount
FROM transactions;


/* Task B
   Calculate the difference vs previous transaction.
   Note: For the first transaction per customer, preceding_amount is NULL,
   so diff_vs_previous will also be NULL (which is correct). */
WITH customer_metric AS (
  SELECT
    customer_id,
    transaction_date,
    transaction_id,
    amount,
    LAG(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS preceding_amount
  FROM transactions
)
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  preceding_amount,
  amount - preceding_amount AS diff_vs_previous
FROM customer_metric;


/* Task C
   Add the next amount as well (LEAD) to enable "what happens next" analysis. */
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  LAG(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
  ) AS preceding_amount,
  LEAD(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
  ) AS next_amount
FROM transactions;


/* Task D
   Simple trend label vs previous transaction.
   This version is intentionally "basic" (Day 37):
   it does NOT distinguish "no previous row" from "previous amount is NULL". */
WITH customer_metric AS (
  SELECT
    customer_id,
    transaction_date,
    transaction_id,
    amount,
    LAG(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS preceding_amount
  FROM transactions
)
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  preceding_amount,
  amount - preceding_amount AS diff_vs_previous,
  CASE
    WHEN preceding_amount IS NULL THEN 'first_transaction'
    WHEN amount IS NULL THEN 'missing_amount'
    WHEN amount > preceding_amount THEN 'increase'
    WHEN amount < preceding_amount THEN 'decrease'
    ELSE 'no_change'
  END AS transaction_trend
FROM customer_metric;

/* =========================
   DAY 38 — Robust trend classification + NULL logic
   Topic: Make trends unambiguous (no SQL "guessing")
   ========================= */

/* Task A
   Base dataset: include previous amount and row number per customer.
   rn=1 is the ONLY reliable way to identify the first transaction row. */
WITH customer_metric AS (
  SELECT
    customer_id,
    transaction_date,
    transaction_id,
    amount,
    LAG(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS preceding_amount,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS rn
  FROM transactions
)
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  preceding_amount,
  rn
FROM customer_metric;


/* Task B
   Difference vs previous.
   Leaving NULLs is intentional:
   - rn=1 => no previous row => diff cannot be computed => NULL
   - amount is NULL => diff cannot be computed => NULL
   - preceding_amount is NULL => previous row exists but amount missing => diff cannot be computed => NULL */
WITH customer_metric AS (
  SELECT
    customer_id,
    transaction_date,
    transaction_id,
    amount,
    LAG(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS preceding_amount,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS rn
  FROM transactions
)
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  preceding_amount,
  amount - preceding_amount AS diff_vs_previous
FROM customer_metric;


/* Task C
   Unambiguous classification (covers all cases explicitly). */
WITH customer_metric AS (
  SELECT
    customer_id,
    transaction_date,
    transaction_id,
    amount,
    LAG(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS preceding_amount,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS rn
  FROM transactions
)
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  preceding_amount,
  amount - preceding_amount AS diff_vs_previous,
  CASE
    WHEN rn = 1 THEN 'first_transaction'
    WHEN amount IS NULL THEN 'missing_amount'
    WHEN preceding_amount IS NULL THEN 'missing_previous_amount'
    WHEN amount > preceding_amount THEN 'increase'
    WHEN amount < preceding_amount THEN 'decrease'
    ELSE 'no_change'
  END AS transaction_trend
FROM customer_metric;


/* (Optional) Task D/E
   KPI-style summary: count transactions by trend (global).
   Useful for reporting and dashboard checks. */
WITH customer_metric AS (
  SELECT
    customer_id,
    transaction_date,
    transaction_id,
    amount,
    LAG(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS preceding_amount,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS rn
  FROM transactions
),
labeled AS (
  SELECT
    customer_id,
    transaction_id,
    CASE
      WHEN rn = 1 THEN 'first_transaction'
      WHEN amount IS NULL THEN 'missing_amount'
      WHEN preceding_amount IS NULL THEN 'missing_previous_amount'
      WHEN amount > preceding_amount THEN 'increase'
      WHEN amount < preceding_amount THEN 'decrease'
      ELSE 'no_change'
    END AS transaction_trend
  FROM customer_metric
)
SELECT
  transaction_trend,
  COUNT(*) AS transaction*













