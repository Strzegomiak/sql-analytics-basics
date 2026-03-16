-- =====================================================
-- DAY 73–75
-- Revenue Analysis & Analytical Workflow
-- =====================================================


-- =====================================================
-- DAY 73
-- Monthly revenue analysis
-- =====================================================


-- Task 1
-- Calculate monthly revenue and number of transactions

WITH month_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue,
        COUNT(*) AS transaction_cnt
    FROM transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
)

SELECT
    month,
    monthly_revenue,
    transaction_cnt
FROM month_metric
ORDER BY month;



-- Task 2
-- Calculate average revenue per transaction in each month

WITH month_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue,
        COUNT(*) AS transaction_cnt
    FROM transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
)

SELECT
    month,
    monthly_revenue,
    transaction_cnt,
    monthly_revenue / NULLIF(transaction_cnt,0) AS avg_revenue_per_transaction
FROM month_metric
ORDER BY month;



-- Task 3
-- Calculate rolling 3-month average revenue

WITH month_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue
    FROM transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
)

SELECT
    month,
    monthly_revenue,
    AVG(monthly_revenue) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3_month_avg
FROM month_metric
ORDER BY month;



-- Task 4
-- Calculate share of total revenue for each month

WITH month_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue
    FROM transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
)

SELECT
    month,
    monthly_revenue,
    100.0 * monthly_revenue
        / NULLIF(SUM(monthly_revenue) OVER (),0)
        AS share_of_total_revenue_percent
FROM month_metric
ORDER BY month;



-- =====================================================
-- DAY 74
-- Rolling metrics and revenue comparison
-- =====================================================


-- Task 1
-- Monthly revenue and rolling 3-month average

WITH month_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue
    FROM transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
)

SELECT
    month,
    monthly_revenue,
    AVG(monthly_revenue) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3_month_avg_revenue
FROM month_metric
ORDER BY month;



-- Task 2
-- Identify months where revenue exceeds rolling average

WITH month_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue
    FROM transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
),

rolling_stats AS (
    SELECT
        month,
        monthly_revenue,
        AVG(monthly_revenue) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS rolling_3_month_avg_revenue
    FROM month_metric
)

SELECT
    month,
    monthly_revenue,
    rolling_3_month_avg_revenue
FROM rolling_stats
WHERE monthly_revenue > rolling_3_month_avg_revenue
ORDER BY month;



-- =====================================================
-- DAY 75
-- Analytical SQL synthesis
-- =====================================================


-- Task 1
-- Calculate Month-over-Month revenue change

WITH month_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue
    FROM transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
),

mom_metric AS (
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM month_metric
)

SELECT
    month,
    monthly_revenue,
    previous_month_revenue,
    ROUND(
        100.0 * (monthly_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue,0),
        2
    ) AS mom_change_percent
FROM mom_metric
ORDER BY month;



-- Task 2
-- Top 3 months with highest MoM growth

WITH month_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue
    FROM transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
),

mom_metric AS (
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM month_metric
),

mom_change AS (
    SELECT
        month,
        ROUND(
            100.0 * (monthly_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue,0),
            2
        ) AS mom_change_percent
    FROM mom_metric
)

SELECT
    month,
    mom_change_percent
FROM mom_change
ORDER BY mom_change_percent DESC
LIMIT 3;



-- Task 3
-- Rolling average comparison

WITH month_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue
    FROM transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
),

rolling_metric AS (
    SELECT
        month,
        monthly_revenue,
        AVG(monthly_revenue) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS rolling_3_month_avg
    FROM month_metric
)

SELECT
    month,
    monthly_revenue,
    rolling_3_month_avg
FROM rolling_metric
WHERE monthly_revenue > rolling_3_month_avg
ORDER BY month;



-- Task 4
-- Rank months by revenue

WITH month_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue
    FROM transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
)

SELECT
    month,
    monthly_revenue,
    DENSE_RANK() OVER (
        ORDER BY monthly_revenue DESC
    ) AS revenue_rank
FROM month_metric
ORDER BY revenue_rank;



-- Task 5
-- Calculate cumulative revenue and cumulative share

WITH month_metric AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount) AS monthly_revenue
    FROM transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
),

cumulative_metric AS (
    SELECT
        month,
        monthly_revenue,
        SUM(monthly_revenue) OVER (
            ORDER BY month
        ) AS cumulative_revenue
    FROM month_metric
)

SELECT
    month,
    monthly_revenue,
    cumulative_revenue,
    ROUND(
        100.0 * cumulative_revenue
        / NULLIF(SUM(monthly_revenue) OVER (),0),
        2
    ) AS cumulative_revenue_percent
FROM cumulative_metric
ORDER BY month;
