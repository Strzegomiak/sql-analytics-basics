-- =====================================================
-- 02 REVENUE ANALYSIS
-- Sales Performance Intelligence Dashboard
-- =====================================================


-- Monthly revenue trend
SELECT 
    yearmonth,
    SUM(revenue) AS total_revenue,
    COUNT(DISTINCT invoice) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM transactions
GROUP BY yearmonth
ORDER BY yearmonth;


-- Monthly revenue trend with MoM growth
WITH month_metric AS (
    SELECT 
        yearmonth,
        SUM(revenue) AS total_month_revenue,
        LAG(SUM(revenue)) OVER (ORDER BY yearmonth) AS prev_total_month_revenue,
        COUNT(DISTINCT invoice) AS total_orders,
        COUNT(DISTINCT customer_id) AS unique_customers
    FROM transactions
    GROUP BY yearmonth
)

SELECT
    yearmonth,
    total_month_revenue,
    100.00 * (total_month_revenue - prev_total_month_revenue) 
        / NULLIF(prev_total_month_revenue, 0) AS revenue_growth_pct,
    total_orders,
    unique_customers
FROM month_metric
ORDER BY yearmonth;