-- ============================================================
-- 05_final_recommendation.sql
-- Project: Checkout A/B Test Analysis
-- Purpose: Final executive recommendation summary
-- ============================================================


-- ============================================================
-- Executive summary table
-- ============================================================

-- Final business recommendation
-- based on experiment results

WITH executive_summary AS (

    SELECT
        'Conversion uplift' AS area,
        'Positive' AS status,
        'Treatment improves conversion rate' AS interpretation


    UNION ALL


    SELECT
        'Revenue impact' AS area,
        'Positive' AS status,
        'Treatment increases revenue per user' AS interpretation


    UNION ALL


    SELECT
        'Guardrail metrics' AS area,
        'Healthy' AS status,
        'No negative impact detected' AS interpretation


    UNION ALL


    SELECT
        'Segment performance' AS area,
        'Stable' AS status,
        'Positive uplift across major segments' AS interpretation


    UNION ALL


    SELECT
        'Final recommendation' AS area,
        'Ship treatment' AS status,
        'Rollout recommended' AS interpretation
)

SELECT
    area,
    status,
    interpretation

FROM executive_summary;