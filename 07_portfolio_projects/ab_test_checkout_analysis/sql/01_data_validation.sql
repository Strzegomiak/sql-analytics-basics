-- ============================================================
-- 01_data_validation.sql
-- Project: Checkout A/B Test Analysis
-- Purpose: Validate experiment data before KPI analysis
-- ============================================================


-- 1. Traffic split between control and treatment
WITH traffic_split AS (
    SELECT 
        COUNT(*) FILTER (WHERE variant = 'control') AS control_users,
        COUNT(*) FILTER (WHERE variant = 'treatment') AS treatment_users,
        COUNT(*) AS total_users
    FROM ab_test_data
)

SELECT
    control_users,
    treatment_users,
    total_users,
    ROUND(100.0 * control_users / total_users, 2) AS pct_control,
    ROUND(100.0 * treatment_users / total_users, 2) AS pct_treatment
FROM traffic_split;



-- 2. Experiment date coverage
SELECT 
    MIN(experiment_timestamp) AS test_start,
    MAX(experiment_timestamp) AS test_end,
    COUNT(DISTINCT experiment_timestamp::date) AS test_days
FROM ab_test_data;



-- 3. Daily user volume by variant
SELECT
    experiment_timestamp::date AS experiment_date,
    variant,
    COUNT(DISTINCT user_id) AS users_per_day
FROM ab_test_data
GROUP BY experiment_timestamp::date, variant
ORDER BY experiment_date, variant;



-- 4. Duplicate user validation
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT user_id) AS distinct_users,
    COUNT(*) - COUNT(DISTINCT user_id) AS duplicate_rows
FROM ab_test_data;



-- 5. List duplicate users if any exist
SELECT
    user_id,
    COUNT(*) AS records_count
FROM ab_test_data
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY records_count DESC;



-- 6. Device distribution by variant
WITH device_distribution AS (
    SELECT
        variant,
        COUNT(*) FILTER (WHERE device = 'desktop') AS desktop_users,
        COUNT(*) FILTER (WHERE device = 'mobile') AS mobile_users,
        COUNT(*) FILTER (WHERE device = 'tablet') AS tablet_users,
        COUNT(*) AS total_users
    FROM ab_test_data
    GROUP BY variant
)

SELECT
    variant,
    desktop_users,
    mobile_users,
    tablet_users,
    total_users,
    ROUND(100.0 * desktop_users / total_users, 2) AS pct_desktop,
    ROUND(100.0 * mobile_users / total_users, 2) AS pct_mobile,
    ROUND(100.0 * tablet_users / total_users, 2) AS pct_tablet
FROM device_distribution
ORDER BY variant;



-- 7. New vs returning user balance by variant
WITH user_type_distribution AS (
    SELECT
        variant,
        COUNT(*) FILTER (WHERE new_user = 1) AS new_users,
        COUNT(*) FILTER (WHERE new_user = 0) AS returning_users,
        COUNT(*) AS total_users
    FROM ab_test_data
    GROUP BY variant
)

SELECT
    variant,
    new_users,
    returning_users,
    total_users,
    ROUND(100.0 * new_users / total_users, 2) AS pct_new_users,
    ROUND(100.0 * returning_users / total_users, 2) AS pct_returning_users
FROM user_type_distribution
ORDER BY variant;



-- 8. Revenue and conversion logic validation
SELECT
    COUNT(*) FILTER (WHERE converted = 0 AND revenue <> 0) AS non_converted_with_revenue,
    COUNT(*) FILTER (WHERE converted = 1 AND revenue <= 0) AS converted_without_revenue,
    COUNT(*) FILTER (WHERE converted = 1 AND revenue > 0) AS valid_converted_users,
    COUNT(*) FILTER (WHERE converted = 0 AND revenue = 0) AS valid_non_converted_users
FROM ab_test_data;