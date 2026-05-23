-- =====================================================
-- 06 CUSTOMER SEGMENTATION
-- Sales Performance Intelligence Dashboard
-- =====================================================


-- Customer segmentation using revenue tiers
WITH customer_metric AS (
    SELECT
        customer_id,
        SUM(revenue) AS total_revenue,
        NTILE(3) OVER (ORDER BY SUM(revenue) DESC) AS value_customer
    FROM transactions
    GROUP BY customer_id
)

SELECT 
    customer_id,
    total_revenue,
    CASE 
        WHEN value_customer = 1 THEN 'High Value'
        WHEN value_customer = 2 THEN 'Medium Value'
        WHEN value_customer = 3 THEN 'Low Value'
    END AS segment
FROM customer_metric
ORDER BY total_revenue DESC;