-- =====================================================
-- 07 RETURNS ANALYSIS
-- Sales Performance Intelligence Dashboard
-- =====================================================


-- Gross revenue, returned revenue, net revenue and cancellation rate
WITH positive_revenue AS (
    SELECT 
        SUM(revenue) AS gross_revenue,
        COUNT(DISTINCT invoice) AS total_positive_orders
    FROM transactions
    WHERE quantity > 0
),

negative_revenue AS (
    SELECT
        SUM(revenue) AS returned_revenue,
        COUNT(DISTINCT invoice) AS total_cancelled_orders
    FROM transactions
    WHERE quantity < 0
)

SELECT
    gross_revenue,
    returned_revenue,
    gross_revenue + returned_revenue AS net_revenue,
    100.0 * total_cancelled_orders 
        / NULLIF(total_positive_orders + total_cancelled_orders, 0) AS cancellation_rate_pct
FROM positive_revenue
CROSS JOIN negative_revenue;

-- Top 10 products by returned revenue
SELECT 
    stockcode,
    MAX(description) AS product_name,
    ABS(SUM(quantity)) AS total_return_quantity,
    ABS(SUM(revenue)) AS total_return_revenue,
    COUNT(DISTINCT invoice) AS total_return_transactions
FROM transactions
WHERE quantity < 0
GROUP BY stockcode
ORDER BY total_return_revenue DESC
LIMIT 10;

-- Product return rate analysis
SELECT
    stockcode,
    MAX(description) AS product_name,

    SUM(
        CASE 
            WHEN quantity > 0 THEN quantity
            ELSE 0
        END
    ) AS quantity_sold,

    ABS(SUM(
        CASE 
            WHEN quantity < 0 THEN quantity
            ELSE 0
        END
    )) AS quantity_returned,

    100.0 * ABS(SUM(
        CASE 
            WHEN quantity < 0 THEN quantity
            ELSE 0
        END
    )) / NULLIF(SUM(
        CASE 
            WHEN quantity > 0 THEN quantity
            ELSE 0
        END
    ), 0) AS return_rate_pct

FROM transactions

WHERE stockcode NOT IN ('POST', 'D', 'M')

GROUP BY stockcode

HAVING SUM(
    CASE 
        WHEN quantity > 0 THEN quantity
        ELSE 0
    END
) >= 100

ORDER BY return_rate_pct DESC;