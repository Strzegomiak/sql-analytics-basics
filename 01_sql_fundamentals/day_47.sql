/* =========================================================
   DAY 47 — Window Frames: ROWS vs RANGE (PostgreSQL)
   Topic: running totals, rolling windows, and time windows
   Tables assumed: transactions(transaction_id, customer_id, transaction_date, amount)
   ========================================================= */


/* ---------------------------------------------------------
   A) Running total per customer
   Notes:
   - ORDER BY inside OVER() enables a cumulative calculation.
   - In PostgreSQL, this defaults to:
     RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
   - With duplicate transaction_date values, RANGE can include
     multiple rows that share the same date (same "current value").
   --------------------------------------------------------- */
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date
  ) AS running_total
FROM transactions;


/* ---------------------------------------------------------
   B) Rolling sum over the last 3 transactions (ROWS)
   Notes:
   - ROWS counts physical rows in the ordered stream.
   - Adding transaction_id makes ordering deterministic when
     multiple transactions have the same transaction_date.
   --------------------------------------------------------- */
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS sum_last_3_tx
FROM transactions;


/* ---------------------------------------------------------
   C) Rolling sum over the last 7 days (RANGE with INTERVAL)
   Notes:
   - RANGE works on the ORDER BY value (here: a date/timestamp).
   - This window includes all rows where:
     transaction_date is between (current_date - 6 days) and current_date
   - If there are multiple rows on the same day, they are all included.
   --------------------------------------------------------- */
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date
    RANGE BETWEEN INTERVAL '6 days' PRECEDING AND CURRENT ROW
  ) AS sum_last_7_days
FROM transactions;


/* ---------------------------------------------------------
   D1) Rolling average over last 5 transactions — ignore NULL amounts
   Notes:
   - AVG(amount) ignores NULL values automatically
     (both numerator and denominator).
   - Still uses the last 5 ROWS (transactions), but averages only
     over non-NULL amounts inside that 5-row window.
   --------------------------------------------------------- */
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  AVG(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
  ) AS avg_last_5_tx_ignore_nulls
FROM transactions;


/* ---------------------------------------------------------
   D2) Alternative: Rolling average over last 5 transactions — treat NULL as 0
   Notes:
   - COALESCE(amount, 0) forces NULL to contribute as 0.
   - This changes the meaning: missing amounts reduce the average.
   --------------------------------------------------------- */
SELECT
  customer_id,
  transaction_date,
  transaction_id,
  amount,
  AVG(COALESCE(amount, 0)) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
  ) AS avg_last_5_tx_null_as_zero
FROM transactions;
