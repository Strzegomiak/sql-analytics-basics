-- =========================================================
-- Day 52–53
-- Topic: Window ratios, aggregation levels & data granularity
-- File: day_52_53_window_levels_and_ratios.sql
-- =========================================================


-- =========================================================
-- DAY 52
-- Window-based ratios vs aggregated ratios
-- =========================================================


-- ---------------------------------------------------------
-- Task A
-- Show transaction-level data together with
-- customer-level total, paid amount and paid ratio.
-- 1 row = 1 transaction.
-- No GROUP BY allowed.
-- ---------------------------------------------------------

WITH transaction_metrics AS (
    SELECT
        transaction_id,
        customer_id,
        transaction_date,
        status,
        amount,

        -- Total amount per customer (window level)
        SUM(amount) OVER (
            PARTITION BY customer_id
        ) AS customer_total_amount,

        -- Paid amount per customer (window level)
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

    -- Ratio calculated at transaction level
    customer_paid_amount * 1.0
        / NULLIF(customer_total_amount, 0) AS paid_ratio

FROM transaction_metrics
ORDER BY customer_id, transaction_date;



-- ---------------------------------------------------------
-- Task B
-- Calculate the same metrics but aggregated per customer.
-- 1 row = 1 customer.
-- No window functions allowed.
-- ---------------------------------------------------------

WITH customer_metrics AS (
    SELECT
        customer_id,

        -- Total amount per customer
        SUM(amount) AS customer_total_amount,

        -- Paid amount per customer
        SUM(amount) FILTER (WHERE status = 'paid')
            AS customer_paid_amount

    FROM transactions
    GROUP BY customer_id
)

SELECT
    customer_id,
    customer_total_amount,
    customer_paid_amount,

    -- Ratio calculated at customer aggregation level
    customer_paid_amount * 1.0
        / NULLIF(customer_total_amount, 0) AS paid_ratio

FROM customer_metrics
ORDER BY customer_id;



-- ---------------------------------------------------------
-- Task C
-- Why AVG(window_sum) is logically suspicious
--
-- The example below works "by coincidence":
-- total_amount is constant per customer, so AVG(total_amount)
-- returns the same value.
-- However, this pattern can lead to incorrect logic
-- when applied to non-constant window expressions.
-- ---------------------------------------------------------

WITH customer_window AS (
    SELECT
        customer_id,
        SUM(amount) OVER (PARTITION BY customer_id)
            AS total_amount
    FROM transactions
)

SELECT
    customer_id,
    AVG(total_amount) AS suspicious_total_amount
FROM customer_window
GROUP BY customer_id
ORDER BY customer_id;



-- ---------------------------------------------------------
-- Correct approach (clean aggregation instead of AVG hack)
-- ---------------------------------------------------------

SELECT
    customer_id,
    SUM(amount) AS correct_total_amount
FROM transactions
GROUP BY customer_id
ORDER BY customer_id;




-- =========================================================
-- DAY 53
-- Clear separation of data levels (transaction vs customer)
-- =========================================================


-- ---------------------------------------------------------
-- Task D
-- Step 1: Create transaction-level metrics.
-- Step 2: Aggregate to customer level.
-- Clear separation of granularity.
-- ---------------------------------------------------------

-- Level 1: transaction-level enrichment
WITH transaction_level AS (
    SELECT
        transaction_id,
        customer_id,
        transaction_date,
        amount,

        -- Paid amount per transaction
        CASE
            WHEN status = 'paid'
                THEN COALESCE(amount, 0)
            ELSE 0
        END AS paid_amount

    FROM transactions
),

-- Level 2: customer-level aggregation
customer_level AS (
    SELECT
        customer_id,

        SUM(amount) AS customer_total_amount,
        SUM(paid_amount) AS customer_paid_amount,
        COUNT(*) AS transaction_count

    FROM transaction_level
    GROUP BY customer_id
)

SELECT
    customer_id,
    customer_total_amount,
    customer_paid_amount,
    transaction_count,

    customer_paid_amount * 1.0
        / NULLIF(customer_total_amount, 0) AS paid_ratio

FROM customer_level
ORDER BY customer_id;



-- ---------------------------------------------------------
-- Key Concept Summary
-- ---------------------------------------------------------
-- 1. Window functions (OVER) do not change row count.
-- 2. GROUP BY changes data granularity.
-- 3. AVG(window_sum) often indicates duplicated values.
-- 4. Always be aware of the level at which your metric lives:
--      - transaction level
--      - customer level
--      - global level
-- ---------------------------------------------------------
