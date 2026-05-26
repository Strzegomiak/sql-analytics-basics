-- ============================================================
-- 02_conversion_analysis.sql
-- Project: Checkout A/B Test Analysis
-- Purpose: Analyze conversion and revenue performance
-- between control and treatment variants
-- ============================================================


-- ============================================================
-- 1. Core KPI comparison by variant
-- ============================================================

-- Compare core conversion and revenue KPIs
-- between control and treatment

SELECT
    variant,
    
    COUNT(*) AS users,
    
    COUNT(*) FILTER (WHERE converted = 1) AS conversions,
    
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE converted = 1) / COUNT(*),
        2
    ) AS conversion_rate_pct,
    
    ROUND(SUM(revenue), 2) AS total_revenue,
    
    ROUND(
        SUM(revenue) / COUNT(*),
        2
    ) AS avg_revenue_per_user,
    
    ROUND(
        SUM(revenue) /
        NULLIF(COUNT(*) FILTER (WHERE converted = 1), 0),
        2
    ) AS avg_order_value

FROM ab_test_data

GROUP BY variant

ORDER BY variant;



-- ============================================================
-- 2. Overall conversion uplift
-- ============================================================

-- Calculate absolute and relative conversion uplift

WITH conversion_summary AS (
    SELECT
        variant,
        COUNT(*) AS users,
        COUNT(*) FILTER (WHERE converted = 1) AS conversions,
        
        1.0 * COUNT(*) FILTER (WHERE converted = 1)
        / COUNT(*) AS conversion_rate
        
    FROM ab_test_data
    
    GROUP BY variant
),

conversion_uplift AS (
    SELECT
        control.conversion_rate AS control_conversion_rate,
        treatment.conversion_rate AS treatment_conversion_rate
        
    FROM conversion_summary control
    
    CROSS JOIN conversion_summary treatment
    
    WHERE control.variant = 'control'
      AND treatment.variant = 'treatment'
)

SELECT
    ROUND(
        100.0 * control_conversion_rate,
        2
    ) AS control_conversion_rate_pct,
    
    ROUND(
        100.0 * treatment_conversion_rate,
        2
    ) AS treatment_conversion_rate_pct,
    
    ROUND(
        100.0 * (
            treatment_conversion_rate
            - control_conversion_rate
        ),
        2
    ) AS absolute_uplift_pp,
    
    ROUND(
        100.0 * (
            treatment_conversion_rate
            - control_conversion_rate
        )
        / control_conversion_rate,
        2
    ) AS relative_uplift_pct

FROM conversion_uplift;



-- ============================================================
-- 3. Conversion uplift by device segment
-- ============================================================

-- Compare conversion performance
-- between control and treatment by device

WITH conversion_by_device AS (
    SELECT
        device,
        variant,
        
        COUNT(*) AS users,
        
        COUNT(*) FILTER (WHERE converted = 1) AS conversions,
        
        1.0 * COUNT(*) FILTER (WHERE converted = 1)
        / COUNT(*) AS conversion_rate
        
    FROM ab_test_data
    
    GROUP BY device, variant
),

device_uplift AS (
    SELECT
        control.device,
        
        control.users AS control_users,
        treatment.users AS treatment_users,
        
        control.conversions AS control_conversions,
        treatment.conversions AS treatment_conversions,
        
        control.conversion_rate AS control_conversion_rate,
        treatment.conversion_rate AS treatment_conversion_rate
        
    FROM conversion_by_device control
    
    JOIN conversion_by_device treatment
        ON control.device = treatment.device
        
    WHERE control.variant = 'control'
      AND treatment.variant = 'treatment'
)

SELECT
    device,
    
    control_users,
    treatment_users,
    
    control_conversions,
    treatment_conversions,
    
    ROUND(
        100.0 * control_conversion_rate,
        2
    ) AS control_conversion_rate_pct,
    
    ROUND(
        100.0 * treatment_conversion_rate,
        2
    ) AS treatment_conversion_rate_pct,
    
    ROUND(
        100.0 * (
            treatment_conversion_rate
            - control_conversion_rate
        ),
        2
    ) AS absolute_uplift_pp,
    
    ROUND(
        100.0 * (
            treatment_conversion_rate
            - control_conversion_rate
        )
        / control_conversion_rate,
        2
    ) AS relative_uplift_pct

FROM device_uplift

ORDER BY absolute_uplift_pp DESC;



-- ============================================================
-- 4. Conversion uplift by user type
-- ============================================================

-- Compare conversion performance
-- between control and treatment
-- for new and returning users

WITH conversion_by_user_type AS (
    SELECT
        CASE
            WHEN new_user = 1 THEN 'New Users'
            WHEN new_user = 0 THEN 'Returning Users'
        END AS user_type,
        
        variant,
        
        COUNT(*) AS users,
        
        COUNT(*) FILTER (WHERE converted = 1) AS conversions,
        
        1.0 * COUNT(*) FILTER (WHERE converted = 1)
        / COUNT(*) AS conversion_rate
        
    FROM ab_test_data
    
    GROUP BY user_type, variant
),

user_type_uplift AS (
    SELECT
        control.user_type,
        
        control.users AS control_users,
        treatment.users AS treatment_users,
        
        control.conversions AS control_conversions,
        treatment.conversions AS treatment_conversions,
        
        control.conversion_rate AS control_conversion_rate,
        treatment.conversion_rate AS treatment_conversion_rate
        
    FROM conversion_by_user_type control
    
    JOIN conversion_by_user_type treatment
        ON control.user_type = treatment.user_type
        
    WHERE control.variant = 'control'
      AND treatment.variant = 'treatment'
)

SELECT
    user_type,
    
    control_users,
    treatment_users,
    
    control_conversions,
    treatment_conversions,
    
    ROUND(
        100.0 * control_conversion_rate,
        2
    ) AS control_conversion_rate_pct,
    
    ROUND(
        100.0 * treatment_conversion_rate,
        2
    ) AS treatment_conversion_rate_pct,
    
    ROUND(
        100.0 * (
            treatment_conversion_rate
            - control_conversion_rate
        ),
        2
    ) AS absolute_uplift_pp,
    
    ROUND(
        100.0 * (
            treatment_conversion_rate
            - control_conversion_rate
        )
        / control_conversion_rate,
        2
    ) AS relative_uplift_pct

FROM user_type_uplift

ORDER BY absolute_uplift_pp DESC;