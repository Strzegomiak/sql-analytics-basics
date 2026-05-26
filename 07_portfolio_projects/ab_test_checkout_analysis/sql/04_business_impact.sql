-- ============================================================
-- 04_business_impact.sql
-- Project: Checkout A/B Test Analysis
-- Purpose: Estimate business and revenue impact
-- of the treatment rollout
-- ============================================================


-- ============================================================
-- Revenue impact summary
-- ============================================================

-- Estimate additional revenue generated
-- by the treatment variant

WITH conversion_by_variant AS (
    SELECT
        variant,
        
        SUM(revenue) / NULLIF(COUNT(DISTINCT user_id), 0) AS revenue_per_user,
        
        COUNT(*) AS users,
        
        COUNT(*) FILTER (WHERE converted = 1) AS conversions,
        
        1.0 * COUNT(*) FILTER (WHERE converted = 1)
        / COUNT(*) AS conversion_rate
        
    FROM ab_test_data
    
    GROUP BY variant
),

variant_uplift AS (
    SELECT 
        control.users AS control_users,
        treatment.users AS treatment_users,
        
        control.conversions AS control_conversions,
        treatment.conversions AS treatment_conversions,
        
        control.conversion_rate AS control_conversion_rate,
        treatment.conversion_rate AS treatment_conversion_rate,

        control.revenue_per_user AS control_rpu,
        treatment.revenue_per_user AS treatment_rpu
        
    FROM conversion_by_variant control
    
    CROSS JOIN conversion_by_variant treatment
        
    WHERE control.variant = 'control'
      AND treatment.variant = 'treatment'
)

SELECT
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
    ) AS relative_uplift_pct,
    
    ROUND(control_rpu, 2) AS control_revenue_per_user,
    
    ROUND(treatment_rpu, 2) AS treatment_revenue_per_user,
    
    ROUND(
        treatment_rpu - control_rpu,
        2
    ) AS additional_revenue_per_user,
    
    ROUND(
        100000 * (
            treatment_rpu - control_rpu
        ),
        2
    ) AS estimated_additional_revenue_per_100k_users,
    
    ROUND(
        100.0 * (
            treatment_rpu - control_rpu
        ) / control_rpu,
        2
    ) AS relative_revenue_uplift_pct

FROM variant_uplift;