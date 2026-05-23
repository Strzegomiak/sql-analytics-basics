-- =====================================================
-- 05 CUSTOMER ANALYSIS
-- Sales Performance Intelligence Dashboard
-- =====================================================


-- Top 10 customers by revenue
SELECT
    customer_id,
    SUM(revenue) AS total_revenue,
    COUNT(DISTINCT invoice) AS total_orders,
    SUM(revenue) / NULLIF(COUNT(DISTINCT invoice), 0) AS avg_order_value
FROM transactions
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Customer Pareto analysis (running revenue contribution)
WITH customer_metric AS (
    SELECT
        customer_id,
        SUM(revenue) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
    FROM transactions
    GROUP BY customer_id
)

SELECT 
    customer_id,
    total_revenue,
    revenue_rank,
    SUM(total_revenue) OVER (
        ORDER BY total_revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue,
    
    100.0 * SUM(total_revenue) OVER (
        ORDER BY total_revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) / SUM(total_revenue) OVER () AS cumulative_revenue_pct

FROM customer_metric
ORDER BY total_revenue DESC;