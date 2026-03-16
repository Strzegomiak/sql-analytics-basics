-- =====================================================
-- DAY 70 - Conversion Funnel Analysis
-- =====================================================

-- Task 1
-- Build user-level funnel flags:
-- - visited
-- - added_to_cart
-- - purchased

WITH user_metric AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'visit' THEN 1 ELSE 0 END) AS visited,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM events
    GROUP BY user_id
)

SELECT *
FROM user_metric;


-- Task 2
-- Count how many users reached each funnel step

WITH user_metric AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'visit' THEN 1 ELSE 0 END) AS visited,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM events
    GROUP BY user_id
)

SELECT
    'visit' AS step,
    SUM(visited) AS users
FROM user_metric

UNION ALL

SELECT
    'add_to_cart' AS step,
    SUM(added_to_cart) AS users
FROM user_metric

UNION ALL

SELECT
    'purchase' AS step,
    SUM(purchased) AS users
FROM user_metric;


-- Task 3
-- Show funnel step conversion as percentage of all visitors

WITH user_metric AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'visit' THEN 1 ELSE 0 END) AS visited,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM events
    GROUP BY user_id
)

SELECT
    'visit' AS step,
    SUM(visited) AS users,
    100.0 * SUM(visited) / NULLIF(SUM(visited), 0) AS conversion_rate
FROM user_metric

UNION ALL

SELECT
    'add_to_cart' AS step,
    SUM(added_to_cart) AS users,
    100.0 * SUM(added_to_cart) / NULLIF(SUM(visited), 0) AS conversion_rate
FROM user_metric

UNION ALL

SELECT
    'purchase' AS step,
    SUM(purchased) AS users,
    100.0 * SUM(purchased) / NULLIF(SUM(visited), 0) AS conversion_rate
FROM user_metric;


-- Task 4
-- Show drop-off users between funnel steps

WITH user_metric AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'visit' THEN 1 ELSE 0 END) AS visited,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM events
    GROUP BY user_id
)

SELECT
    'visit' AS step,
    SUM(visited) AS users,
    SUM(visited) - SUM(added_to_cart) AS drop_off_users
FROM user_metric

UNION ALL

SELECT
    'add_to_cart' AS step,
    SUM(added_to_cart) AS users,
    SUM(added_to_cart) - SUM(purchased) AS drop_off_users
FROM user_metric

UNION ALL

SELECT
    'purchase' AS step,
    SUM(purchased) AS users,
    0 AS drop_off_users
FROM user_metric;


-- =====================================================
-- DAY 71 - Conversion Funnel Analysis (Extended Version)
-- =====================================================

-- Task 1
-- Build user-level funnel flags

WITH user_metric AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'visit' THEN 1 ELSE 0 END) AS visited,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM events
    GROUP BY user_id
)

SELECT *
FROM user_metric;


-- Task 2
-- Aggregate funnel totals into one row

WITH user_metric AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'visit' THEN 1 ELSE 0 END) AS visited,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM events
    GROUP BY user_id
),
totals AS (
    SELECT 
        SUM(visited) AS visit_users,
        SUM(added_to_cart) AS add_to_cart_users,
        SUM(purchased) AS purchase_users
    FROM user_metric
)

SELECT *
FROM totals;


-- Task 3
-- Calculate step-by-step conversion rates and overall conversion

WITH user_metric AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'visit' THEN 1 ELSE 0 END) AS visited,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM events
    GROUP BY user_id
),
totals AS (
    SELECT 
        SUM(visited) AS visit_users,
        SUM(added_to_cart) AS add_to_cart_users,
        SUM(purchased) AS purchase_users
    FROM user_metric
)

SELECT
    visit_users,
    add_to_cart_users,
    purchase_users,
    ROUND(100.0 * add_to_cart_users / NULLIF(visit_users, 0), 2) AS visit_to_cart_rate,
    ROUND(100.0 * purchase_users / NULLIF(add_to_cart_users, 0), 2) AS cart_to_purchase_rate,
    ROUND(100.0 * purchase_users / NULLIF(visit_users, 0), 2) AS overall_conversion_rate
FROM totals;


-- Task 4
-- Add drop-off counts between steps

WITH user_metric AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'visit' THEN 1 ELSE 0 END) AS visited,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM events
    GROUP BY user_id
),
totals AS (
    SELECT 
        SUM(visited) AS visit_users,
        SUM(added_to_cart) AS add_to_cart_users,
        SUM(purchased) AS purchase_users
    FROM user_metric
)

SELECT
    visit_users,
    add_to_cart_users,
    purchase_users,
    visit_users - add_to_cart_users AS drop_off_after_visit,
    add_to_cart_users - purchase_users AS drop_off_after_cart,
    ROUND(100.0 * add_to_cart_users / NULLIF(visit_users, 0), 2) AS visit_to_cart_rate,
    ROUND(100.0 * purchase_users / NULLIF(add_to_cart_users, 0), 2) AS cart_to_purchase_rate,
    ROUND(100.0 * purchase_users / NULLIF(visit_users, 0), 2) AS overall_conversion_rate
FROM totals;


-- =====================================================
-- DAY 72 - Customer Revenue Contribution / Pareto Logic
-- =====================================================

-- Task 1
-- Calculate revenue share per customer

WITH customer_metric AS (
    SELECT
        customer_id,
        SUM(amount) AS customer_revenue
    FROM transactions
    GROUP BY customer_id
)

SELECT
    customer_id,
    customer_revenue,
    SUM(customer_revenue) OVER () AS total_revenue,
    ROUND(
        100.0 * customer_revenue / NULLIF(SUM(customer_revenue) OVER (), 0),
        2
    ) AS revenue_share_percent
FROM customer_metric;


-- Task 2
-- Rank customers by revenue using DENSE_RANK

WITH customer_metric AS (
    SELECT
        customer_id,
        SUM(amount) AS customer_revenue
    FROM transactions
    GROUP BY customer_id
)

SELECT
    customer_id,
    customer_revenue,
    DENSE_RANK() OVER (ORDER BY customer_revenue DESC) AS revenue_rank
FROM customer_metric;


-- Task 3
-- Calculate cumulative revenue ordered by highest customer revenue

WITH customer_metric AS (
    SELECT
        customer_id,
        SUM(amount) AS customer_revenue
    FROM transactions
    GROUP BY customer_id
)

SELECT
    customer_id,
    customer_revenue,
    SUM(customer_revenue) OVER (ORDER BY customer_revenue DESC) AS cumulative_revenue
FROM customer_metric;


-- Task 4
-- Calculate cumulative revenue percentage

WITH customer_metric AS (
    SELECT
        customer_id,
        SUM(amount) AS customer_revenue
    FROM transactions
    GROUP BY customer_id
),
cumulative_metric AS (
    SELECT
        customer_id,
        customer_revenue,
        SUM(customer_revenue) OVER (ORDER BY customer_revenue DESC) AS cumulative_revenue
    FROM customer_metric
)

SELECT
    customer_id,
    customer_revenue,
    cumulative_revenue,
    ROUND(
        100.0 * cumulative_revenue / NULLIF(SUM(customer_revenue) OVER (), 0),
        2
    ) AS cumulative_revenue_percent
FROM cumulative_metric;


-- Task 5
-- Count how many top customers are needed to reach at least 80% of total revenue

WITH customer_metric AS (
    SELECT
        customer_id,
        SUM(amount) AS customer_revenue
    FROM transactions
    GROUP BY customer_id
),
final_metric AS (
    SELECT
        customer_id,
        customer_revenue,
        SUM(customer_revenue) OVER (ORDER BY customer_revenue DESC) AS cumulative_revenue,
        SUM(customer_revenue) OVER () AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY customer_revenue DESC) AS rn
    FROM customer_metric
)

SELECT
    MIN(rn) FILTER (WHERE cumulative_revenue >= 0.8 * total_revenue) AS customers_80_percent_revenue
FROM final_metric;
