-- ============================================================
-- 03_guardrail_metrics.sql
-- Project: Checkout A/B Test Analysis
-- Purpose: Evaluate whether the treatment negatively
-- impacts key guardrail metrics
-- ============================================================


-- ============================================================
-- Guardrail metrics comparison
-- ============================================================

-- Compare key safety and UX metrics
-- between control and treatment variants

WITH guardrails_long AS (

    SELECT
        'cart_abandonment_rate' AS metric,
        
        MAX(cart_abandonment_rate)
            FILTER (WHERE variant = 'control') AS control_value,
            
        MAX(cart_abandonment_rate)
            FILTER (WHERE variant = 'treatment') AS treatment_value
            
    FROM guardrail_metrics


    UNION ALL


    SELECT
        'avg_page_load_time' AS metric,
        
        MAX(avg_page_load_time)
            FILTER (WHERE variant = 'control') AS control_value,
            
        MAX(avg_page_load_time)
            FILTER (WHERE variant = 'treatment') AS treatment_value
            
    FROM guardrail_metrics


    UNION ALL


    SELECT
        'error_rate' AS metric,
        
        MAX(error_rate)
            FILTER (WHERE variant = 'control') AS control_value,
            
        MAX(error_rate)
            FILTER (WHERE variant = 'treatment') AS treatment_value
            
    FROM guardrail_metrics


    UNION ALL


    SELECT
        'bounce_rate' AS metric,
        
        MAX(bounce_rate)
            FILTER (WHERE variant = 'control') AS control_value,
            
        MAX(bounce_rate)
            FILTER (WHERE variant = 'treatment') AS treatment_value
            
    FROM guardrail_metrics
)

SELECT
    metric,
    
    control_value,
    treatment_value,
    
    ROUND(
        treatment_value - control_value,
        4
    ) AS absolute_change,
    
    ROUND(
        100.0 * (
            treatment_value - control_value
        ) / control_value,
        2
    ) AS relative_change_pct

FROM guardrails_long;