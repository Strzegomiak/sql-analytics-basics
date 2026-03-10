-- =====================================================
-- Day 67 – Customer Retention Analysis
-- =====================================================

-- Step 1
-- Find the first transaction date for each customer

WITH first_transaction AS (
    SELECT
        customer_id,
        MIN(transaction_date) AS first_transaction_date
    FROM transactions
    GROUP BY customer_id
),

-- Step 2
-- Calculate how many days passed since the first purchase

customer_days AS (
    SELECT
        t.customer_id,
        t.transaction_date,
        f.first_transaction_date,
        t.transaction_date - f.first_transaction_date AS days_since_first_purchase
    FROM transactions t
    JOIN first_transaction f
        USING (customer_id)
),

-- Step 3
-- Count how many customers are active for each day since the first purchase

retention_base AS (
    SELECT
        days_since_first_purchase,
        COUNT(DISTINCT customer_id) AS customers_per_day
    FROM customer_days
    GROUP BY days_since_first_purchase
)

-- Step 4
-- Calculate retention rate compared to day 0 (initial cohort)

SELECT
    days_since_first_purchase,
    customers_per_day,
    MAX(customers_per_day) FILTER (WHERE days_since_first_purchase = 0) OVER () AS customers_day_0,
    100.00 * customers_per_day
        / NULLIF(
            MAX(customers_per_day) FILTER (WHERE days_since_first_purchase = 0) OVER (),
            0
        ) AS retention_rate
FROM retention_base
ORDER BY days_since_first_purchase;



-- =====================================================
-- Day 68 – Cohort Retention Analysis
-- =====================================================

-- Step 1
-- Convert transaction dates to months

WITH customer_metric AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', transaction_date) AS transaction_month
    FROM transactions
),

-- Step 2
-- Determine cohort month and number of months since first purchase

month_metric AS (
    SELECT
        customer_id,
        MIN(transaction_month) OVER (PARTITION BY customer_id) AS cohort_month,
        transaction_month,

        -- Calculate number of months since first purchase
        (
            (EXTRACT(YEAR FROM transaction_month)
                - EXTRACT(YEAR FROM MIN(transaction_month) OVER (PARTITION BY customer_id))) * 12
            +
            (EXTRACT(MONTH FROM transaction_month)
                - EXTRACT(MONTH FROM MIN(transaction_month) OVER (PARTITION BY customer_id)))
        ) AS month_number

    FROM customer_metric
),

-- Step 3
-- Count unique active customers in each cohort month and period

cohort_metric AS (
    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT customer_id) AS customers_in_period
    FROM month_metric
    GROUP BY cohort_month, month_number
),

-- Step 4
-- Calculate cohort size and retention rate

retention_metric AS (
    SELECT
        cohort_month,
        month_number,
        customers_in_period,

        -- Cohort size equals the number of customers in month 0
        MAX(customers_in_period)
            FILTER (WHERE month_number = 0)
            OVER (PARTITION BY cohort_month) AS cohort_size,

        -- Retention rate in percentage
        ROUND(
            100.0 * customers_in_period
            / NULLIF(
                MAX(customers_in_period)
                FILTER (WHERE month_number = 0)
                OVER (PARTITION BY cohort_month),
                0
            ),
            2
        ) AS retention_rate

    FROM cohort_metric
)

-- Step 5
-- Pivot retention values to create a cohort retention table

SELECT
    cohort_month,

    MAX(retention_rate) FILTER (WHERE month_number = 0) AS m0,
    MAX(retention_rate) FILTER (WHERE month_number = 1) AS m1,
    MAX(retention_rate) FILTER (WHERE month_number = 2) AS m2,
    MAX(retention_rate) FILTER (WHERE month_number = 3) AS m3,
    MAX(retention_rate) FILTER (WHERE month_number = 4) AS m4,
    MAX(retention_rate) FILTER (WHERE month_number = 5) AS m5

FROM retention_metric
GROUP BY cohort_month
ORDER BY cohort_month;
