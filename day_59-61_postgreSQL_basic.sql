-- Łukaszek become Analyst
-- Days 59–61
-- Engine: PostgreSQL
-- Topic: Cohort polish + Real business queries (MoM, Pareto 80%, Monthly KPIs)

/* =========================================================
   DAY 59 — Cohort retention: tidy + retention % (long format)
   ========================================================= */

-- Cohort = first purchase month
-- Retention = active customers by months since first purchase

WITH tx AS (
    SELECT
        customer_id,
        transaction_date,
        MIN(transaction_date) OVER (PARTITION BY customer_id) AS first_purchase_date
    FROM transactions
),
cohortized AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', first_purchase_date) AS cohort_month,
        DATE_TRUNC('month', transaction_date)    AS activity_month,
        (
            (EXTRACT(YEAR  FROM DATE_TRUNC('month', transaction_date)) -
             EXTRACT(YEAR  FROM DATE_TRUNC('month', first_purchase_date))) * 12
            +
            (EXTRACT(MONTH FROM DATE_TRUNC('month', transaction_date)) -
             EXTRACT(MONTH FROM DATE_TRUNC('month', first_purchase_date)))
        ) AS months_since_first_purchase
    FROM tx
),
retention AS (
    SELECT
        cohort_month,
        months_since_first_purchase,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM cohortized
    GROUP BY 1, 2
),
cohort_sizes AS (
    SELECT
        cohort_month,
        MAX(CASE WHEN months_since_first_purchase = 0 THEN active_customers END) AS cohort_size
    FROM retention
    GROUP BY 1
)
SELECT
    r.cohort_month,
    r.months_since_first_purchase,
    r.active_customers,
    cs.cohort_size,
    ROUND(1.0 * r.active_customers / NULLIF(cs.cohort_size, 0), 4) AS retention_rate
FROM retention r
JOIN cohort_sizes cs
    ON cs.cohort_month = r.cohort_month
ORDER BY r.cohort_month, r.months_since_first_purchase;


/* =========================================================
   DAY 60 — PostgreSQL environment: “first real run” checklist
   ========================================================= */

-- Day 60 was mostly environment/pgAdmin setup (no single query requirement),
-- but here are a few standard sanity checks you can run anytime.

-- 60.1 How many rows and customers do we have?
SELECT
    COUNT(*) AS transactions_cnt,
    COUNT(DISTINCT customer_id) AS customers_cnt
FROM transactions;

-- 60.2 Date range of the dataset
SELECT
    MIN(transaction_date) AS min_transaction_date,
    MAX(transaction_date) AS max_transaction_date
FROM transactions;

-- 60.3 Quick monthly revenue overview (basic)
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS monthly_revenue
FROM transactions
GROUP BY 1
ORDER BY month;


/* =========================================================
   DAY 61 — Real Queries Start: MoM, Pareto 80%, Monthly KPIs
   ========================================================= */

-- 61.1 Monthly revenue + MoM % growth

WITH monthly_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue
    FROM transactions
    GROUP BY 1
),
with_prev AS (
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (ORDER BY month) AS previous_month
    FROM monthly_metric
)
SELECT
    month,
    monthly_revenue,
    previous_month,
    ROUND(
        100.0 * (monthly_revenue - previous_month) / NULLIF(previous_month, 0),
        2
    ) AS mom_growth_pct
FROM with_prev
ORDER BY month;


-- 61.2 Pareto: customers contributing to first 80% of revenue (running share)

WITH customer_metric AS (
    SELECT
        customer_id,
        SUM(amount) AS revenue_per_customer
    FROM transactions
    GROUP BY 1
),
metrics AS (
    SELECT
        customer_id,
        revenue_per_customer,
        SUM(revenue_per_customer) OVER (
            ORDER BY revenue_per_customer DESC, customer_id
        ) AS running_revenue,
        SUM(revenue_per_customer) OVER () AS total_revenue
    FROM customer_metric
)
SELECT
    customer_id,
    revenue_per_customer,
    running_revenue,
    ROUND(100.0 * running_revenue / NULLIF(total_revenue, 0), 2) AS run_to_total_percent,
    CASE
        WHEN 100.0 * running_revenue / NULLIF(total_revenue, 0) <= 80 THEN 1
        ELSE 0
    END AS is_within_80_percent
FROM metrics
ORDER BY revenue_per_customer DESC, customer_id;


-- 61.3 Pareto summary: how many customers are needed to reach 80% revenue?

WITH customer_metric AS (
    SELECT
        customer_id,
        SUM(amount) AS revenue_per_customer
    FROM transactions
    GROUP BY 1
),
metrics AS (
    SELECT
        customer_id,
        revenue_per_customer,
        SUM(revenue_per_customer) OVER (
            ORDER BY revenue_per_customer DESC, customer_id
        ) AS running_revenue,
        SUM(revenue_per_customer) OVER () AS total_revenue
    FROM customer_metric
),
flags AS (
    SELECT
        *,
        CASE
            WHEN 100.0 * running_revenue / NULLIF(total_revenue, 0) <= 80 THEN 1
            ELSE 0
        END AS is_within_80_percent
    FROM metrics
)
SELECT
    COUNT(*) FILTER (WHERE is_within_80_percent = 1) AS customers_in_top_80,
    COUNT(*) AS total_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE is_within_80_percent = 1) / NULLIF(COUNT(*), 0),
        2
    ) AS pct_of_customers
FROM flags;


-- 61.4 Monthly performance KPIs (dashboard-ready)

SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS transactions_cnt,
    COUNT(DISTINCT customer_id) AS active_customers,
    SUM(amount) AS total_revenue,
    SUM(amount) / NULLIF(COUNT(*), 0) AS avg_revenue_per_transaction,
    SUM(amount) / NULLIF(COUNT(DISTINCT customer_id), 0) AS avg_revenue_per_customer,
    100.0 * SUM(amount) / NULLIF(SUM(SUM(amount)) OVER (), 0) AS month_vs_total_perc
FROM transactions
GROUP BY 1
ORDER BY month;
