-- Łukaszek become Analyst
-- Days 57–58
-- Engine: PostgreSQL
-- Topic: LAG / NULL handling / Cohort Retention

/* =========================================================
   DAY 57 — Window functions: LAG, deltas, movement flags
   ========================================================= */

-- 57.1 Previous transaction amount per customer

SELECT
    customer_id,
    transaction_date,
    amount,
    LAG(amount) OVER (
        PARTITION BY customer_id
        ORDER BY transaction_date
    ) AS preceding_amount
FROM transactions
ORDER BY customer_id, transaction_date;


-- 57.2 Difference vs previous transaction

WITH customer_metric AS (
    SELECT
        customer_id,
        transaction_date,
        amount,
        LAG(amount) OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) AS preceding_amount
    FROM transactions
)

SELECT
    customer_id,
    transaction_date,
    amount,
    preceding_amount,
    amount - preceding_amount AS diff_cur_prev
FROM customer_metric
ORDER BY customer_id, transaction_date;


-- 57.3 Movement classification (increase / decrease / no_change)

WITH customer_metric AS (
    SELECT
        customer_id,
        transaction_date,
        amount,
        LAG(amount) OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) AS preceding_amount
    FROM transactions
),
diffs AS (
    SELECT
        customer_id,
        transaction_date,
        amount,
        preceding_amount,
        amount - preceding_amount AS diff_cur_prev
    FROM customer_metric
)

SELECT
    customer_id,
    transaction_date,
    amount,
    preceding_amount,
    diff_cur_prev,
    CASE
        WHEN preceding_amount IS NULL THEN 'first_or_missing_prev'
        WHEN amount IS NULL THEN 'amount_is_null'
        WHEN diff_cur_prev > 0 THEN 'increase'
        WHEN diff_cur_prev < 0 THEN 'decrease'
        ELSE 'no_change'
    END AS movement
FROM diffs
ORDER BY customer_id, transaction_date;


-- 57.4 Alternative: treating NULL as 0 (only if business rules allow)

WITH customer_metric AS (
    SELECT
        customer_id,
        transaction_date,
        amount,
        LAG(amount) OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) AS preceding_amount
    FROM transactions
)

SELECT
    customer_id,
    transaction_date,
    amount,
    preceding_amount,
    COALESCE(amount, 0) - COALESCE(preceding_amount, 0) AS diff_cur_prev_null_as_zero
FROM customer_metric
ORDER BY customer_id, transaction_date;


/* =========================================================
   DAY 58 — Cohort Analysis (Monthly Retention)
   ========================================================= */

-- Goal:
-- Cohort = first purchase month
-- Retention = active customers by months since first purchase

WITH transaction_metric AS (
    SELECT
        customer_id,
        transaction_date,
        MIN(transaction_date) OVER (PARTITION BY customer_id) AS first_purchase_date
    FROM transactions
),

transaction_first_purchase AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', first_purchase_date) AS first_purchase_month,
        DATE_TRUNC('month', transaction_date)     AS transaction_month,
        (
            (EXTRACT(YEAR  FROM DATE_TRUNC('month', transaction_date)) -
             EXTRACT(YEAR  FROM DATE_TRUNC('month', first_purchase_date))) * 12
            +
            (EXTRACT(MONTH FROM DATE_TRUNC('month', transaction_date)) -
             EXTRACT(MONTH FROM DATE_TRUNC('month', first_purchase_date)))
        ) AS months_since_first_purchase
    FROM transaction_metric
),

retention AS (
    SELECT
        first_purchase_month,
        months_since_first_purchase,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM transaction_first_purchase
    GROUP BY 1, 2
),

cohort_sizes AS (
    SELECT
        first_purchase_month,
        MAX(CASE
                WHEN months_since_first_purchase = 0
                THEN active_customers
            END) AS cohort_size
    FROM retention
    GROUP BY 1
)

SELECT
    r.first_purchase_month,
    r.months_since_first_purchase,
    r.active_customers,
    cs.cohort_size,
    ROUND(
        1.0 * r.active_customers / NULLIF(cs.cohort_size, 0),
        4
    ) AS retention_rate
FROM retention r
JOIN cohort_sizes cs
    ON cs.first_purchase_month = r.first_purchase_month
ORDER BY r.first_purchase_month, r.months_since_first_purchase;
