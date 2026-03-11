-- =====================================================
-- Day 69 - Funnel Analysis
-- =====================================================

-- =====================================================
-- Create sample table
-- =====================================================

DROP TABLE IF EXISTS events;

CREATE TABLE events (
    event_id SERIAL PRIMARY KEY,
    user_id INT,
    event_name TEXT,
    event_date DATE
);

-- =====================================================
-- Insert sample data
-- =====================================================

INSERT INTO events (user_id, event_name, event_date) VALUES
(1, 'visit', '2024-01-01'),
(1, 'add_to_cart', '2024-01-01'),
(1, 'purchase', '2024-01-01'),

(2, 'visit', '2024-01-01'),
(2, 'add_to_cart', '2024-01-02'),

(3, 'visit', '2024-01-01'),

(4, 'visit', '2024-01-01'),
(4, 'add_to_cart', '2024-01-01'),
(4, 'purchase', '2024-01-03'),

(5, 'visit', '2024-01-02'),

(6, 'visit', '2024-01-02'),
(6, 'add_to_cart', '2024-01-02'),

(7, 'visit', '2024-01-03'),

(8, 'visit', '2024-01-03'),
(8, 'add_to_cart', '2024-01-03'),
(8, 'purchase', '2024-01-04'),

(9, 'visit', '2024-01-03'),

(10, 'visit', '2024-01-04'),
(10, 'add_to_cart', '2024-01-04');

-- =====================================================
-- Task 1
-- Create user-level event flags
-- =====================================================

SELECT 
    user_id,
    MAX(CASE WHEN event_name = 'visit' THEN 1 ELSE 0 END) AS visited,
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
FROM events
GROUP BY user_id
ORDER BY user_id;

-- This query shows whether a specific type of event exists for each user

-- =====================================================
-- Task 2
-- Convert user-level flags into funnel step counts
-- =====================================================

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

-- Aggregate user-level event flags into funnel step counts

-- =====================================================
-- Task 3
-- Calculate conversion from visit
-- =====================================================

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
    100.0 * SUM(visited) / NULLIF(SUM(visited), 0) AS conversion_from_visit
FROM user_metric

UNION ALL

SELECT
    'add_to_cart' AS step,
    SUM(added_to_cart) AS users,
    100.0 * SUM(added_to_cart) / NULLIF(SUM(visited), 0) AS conversion_from_visit
FROM user_metric

UNION ALL

SELECT
    'purchase' AS step,
    SUM(purchased) AS users,
    100.0 * SUM(purchased) / NULLIF(SUM(visited), 0) AS conversion_from_visit
FROM user_metric;

-- Build funnel step counts and calculate conversion from visit

-- =====================================================
-- Task 4
-- Calculate conversion from previous step
-- =====================================================

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
    100.0 * SUM(visited) / NULLIF(SUM(visited), 0) AS conversion_from_previous_step
FROM user_metric

UNION ALL

SELECT
    'add_to_cart' AS step,
    SUM(added_to_cart) AS users,
    100.0 * SUM(added_to_cart) / NULLIF(SUM(visited), 0) AS conversion_from_previous_step
FROM user_metric

UNION ALL

SELECT
    'purchase' AS step,
    SUM(purchased) AS users,
    100.0 * SUM(purchased) / NULLIF(SUM(added_to_cart), 0) AS conversion_from_previous_step
FROM user_metric;

-- Calculate step-to-step funnel conversion

-- =====================================================
-- Task 5
-- Calculate drop-off users between funnel steps
-- =====================================================

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

-- Calculate drop-off users between funnel steps

-- =====================================================
-- Final production-style version
-- =====================================================

WITH user_metric AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'visit' THEN 1 ELSE 0 END) AS visited,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM events
    GROUP BY user_id
),

funnel_base AS (
    SELECT
        SUM(visited) AS visit_users,
        SUM(added_to_cart) AS add_to_cart_users,
        SUM(purchased) AS purchase_users
    FROM user_metric
)

SELECT
    'visit' AS step,
    visit_users AS users,
    100.0 AS conversion_from_previous_step,
    visit_users - add_to_cart_users AS drop_off_users
FROM funnel_base

UNION ALL

SELECT
    'add_to_cart' AS step,
    add_to_cart_users AS users,
    100.0 * add_to_cart_users / NULLIF(visit_users, 0) AS conversion_from_previous_step,
    add_to_cart_users - purchase_users AS drop_off_users
FROM funnel_base

UNION ALL

SELECT
    'purchase' AS step,
    purchase_users AS users,
    100.0 * purchase_users / NULLIF(add_to_cart_users, 0) AS conversion_from_previous_step,
    0 AS drop_off_users
FROM funnel_base;

-- Create a production-style funnel summary
