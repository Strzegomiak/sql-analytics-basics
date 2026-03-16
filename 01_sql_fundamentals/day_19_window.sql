-- day_19.sql
-- Topic: Window functions (OVER, PARTITION BY, ORDER BY)
-- Goal: Calculate KPIs per row without losing transaction-level detail.

-- ============================================================
-- 1) SUM() OVER (PARTITION BY)
-- Business idea: show each transaction and also total revenue per customer.
-- ============================================================
SELECT
    transaction_id,
    customer_id,
    transaction_date,
    amount,
    SUM(amount) OVER (PARTITION BY customer_id) AS total_amount_per_customer
FROM transactions
ORDER BY customer_id, transaction_date, transaction_id;

-- ============================================================
-- 2) AVG() OVER + difference from average
-- Business idea: compare each transaction to the customer's typical (average) transaction.
-- ============================================================
SELECT
    transaction_id,
    customer_id,
    transaction_date,
    amount,
    AVG(amount) OVER (PARTITION BY customer_id) AS avg_amount_per_customer,
    amount - AVG(amount) OVER (PARTITION BY customer_id) AS diff_from_avg
FROM transactions
ORDER BY customer_id, transaction_date, transaction_id;

-- ============================================================
-- 3) ROW_NUMBER vs RANK vs DENSE_RANK
-- Business idea: rank transactions per customer by amount (biggest first).
-- Notes:
--   ROW_NUMBER -> unique sequence (ties still get different numbers)
--   RANK       -> ties share rank, but creates gaps (1,1,3)
--   DENSE_RANK -> ties share rank, no gaps (1,1,2)
-- ============================================================
SELECT
    transaction_id,
    customer_id,
    transaction_date,
    amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY amount DESC, transaction_date, transaction_id) AS row_number,
    RANK()       OVER (PARTITION BY customer_id ORDER BY amount DESC, transaction_date, transaction_id) AS rank,
    DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC, transaction_date, transaction_id) AS dense_rank
FROM transactions
ORDER BY customer_id, row_number;

-- ============================================================
-- 4) JOIN + WINDOW (no GROUP BY)
-- Business idea: show customer name and total customer revenue on each transaction row.
-- ============================================================
SELECT
    c.customer_id,
    c.customer_name,
    t.transaction_id,
    t.transaction_date,
    t.amount,
    SUM(t.amount) OVER (PARTITION BY c.customer_id) AS total_customer_revenue
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
ORDER BY c.customer_id, t.transaction_date, t.transaction_id;
