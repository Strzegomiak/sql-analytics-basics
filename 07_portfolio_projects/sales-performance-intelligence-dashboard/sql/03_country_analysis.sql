-- =====================================================
-- 03 COUNTRY ANALYSIS
-- Sales Performance Intelligence Dashboard
-- =====================================================


-- Top 10 countries by total revenue
SELECT
    country,
    SUM(revenue) AS country_total_revenue,
    COUNT(DISTINCT invoice) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(revenue) / COUNT(DISTINCT invoice) AS avg_order_value
FROM transactions
GROUP BY country
ORDER BY country_total_revenue DESC
LIMIT 10;


-- Country revenue share
WITH country_metric AS (
    SELECT
        country,
        SUM(revenue) AS country_total_revenue,
        COUNT(DISTINCT invoice) AS total_orders,
        COUNT(DISTINCT customer_id) AS unique_customers
    FROM transactions
    GROUP BY country
)

SELECT
    country,
    country_total_revenue,
    100.00 * country_total_revenue / SUM(country_total_revenue) OVER () AS revenue_share_pct,
    total_orders,
    unique_customers
FROM country_metric
ORDER BY country_total_revenue DESC;