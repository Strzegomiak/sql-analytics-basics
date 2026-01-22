/* =========================================================
   DAY 20 — WINDOW FUNCTIONS (OVER / PARTITION BY / ORDER BY)
   Goal: keep row-level detail + add aggregated context
   Tables assumed: transactions (transaction_id, customer_id, amount, ...)
   ========================================================= */


/* ---------------------------------------------------------
   Example 1: Number of transactions per customer
   (row-level + metric next to each row)
   --------------------------------------------------------- */
SELECT
    transaction_id,
    customer_id,
    COUNT(*) OVER (PARTITION BY customer_id) AS transactions_per_customer
FROM transactions;


/* ---------------------------------------------------------
   Example 2: Total revenue per customer
   --------------------------------------------------------- */
SELECT
    transaction_id,
    customer_id,
    amount,
    SUM(amount) OVER (PARTITION BY customer_id) AS total_customer_revenue
FROM transactions;


/* ---------------------------------------------------------
   Example 3: Transaction rank within each customer
   (largest transaction = 1)
   --------------------------------------------------------- */
SELECT
    transaction_id,
    customer_id,
    amount,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY amount DESC
    ) AS transaction_rank_within_customer
FROM transactions;


/* =========================================================
   TASK A
   For each transaction show avg transaction amount per customer
   ========================================================= */
SELECT
    transaction_id,
    customer_id,
    amount,
    AVG(amount) OVER (PARTITION BY customer_id) AS average_amount_per_customer
FROM transactions;


/* =========================================================
   TASK B (FIXED)
   Global ranking by amount (whole table)
   NOTE: RANK/DENSE_RANK/ROW_NUMBER differences
   ========================================================= */
SELECT
    transaction_id,
    customer_id,
    amount,
    RANK() OVER (ORDER BY amount DESC) AS rank_by_amount,
    DENSE_RANK() OVER (ORDER BY amount DESC) AS dense_rank_by_amount,
    ROW_NUMBER() OVER (ORDER BY amount DESC) AS rownum_by_amount
FROM transactions;


/* =========================================================
   BONUS: TOP 3 transactions by amount (global)
   IMPORTANT: to filter by window function result -> subquery/CTE
   ========================================================= */
SELECT
    transaction_id,
    customer_id,
    amount,
    rank_by_amount
FROM (
    SELECT
        transaction_id,
        customer_id,
        amount,
        RANK() OVER (ORDER BY amount DESC) AS rank_by_amount
    FROM transactions
) t
WHERE rank_by_amount <= 3
ORDER BY amount DESC;


/* =========================================================
   TASK C (comment / reasoning)
   GROUP BY vs WINDOW FUNCTION
   - GROUP BY: best for summary report (one row per customer)
   - WINDOW: best for analysis when we must keep transaction-level detail
   ========================================================= */

/*
Example GROUP BY (summary report):
SELECT customer_id, SUM(amount) AS total_customer_revenue
FROM transactions
GROUP BY customer_id;

Example WINDOW (analysis with detail):
SELECT transaction_id, customer_id, amount,
       SUM(amount) OVER (PARTITION BY customer_id) AS total_customer_revenue
FROM transactions;
*/
