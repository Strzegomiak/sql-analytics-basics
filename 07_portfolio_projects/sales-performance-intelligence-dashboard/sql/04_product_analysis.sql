-- =====================================================
-- 04 PRODUCT ANALYSIS
-- Sales Performance Intelligence Dashboard
-- =====================================================


-- Top 10 products by revenue
SELECT 
    stockcode,
    MAX(description) AS product_name,
    SUM(quantity) AS quantity_sold,
    COUNT(DISTINCT invoice) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(revenue) AS total_revenue
FROM transactions
GROUP BY stockcode
ORDER BY total_revenue DESC
LIMIT 10;