-- ============================================
-- CASE STUDY 2
-- Customer Retention & Sales Performance
-- ============================================


-- ============================================
-- 1. Monthly sales performance (2025)
-- ============================================

SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(amount) AS gross_revenue,
    AVG(amount) AS avg_order_value
FROM orders
WHERE order_date BETWEEN '2025-01-01' AND '2025-12-31'
  AND status = 'completed'
GROUP BY 1
ORDER BY month;


-- ============================================
-- 2. Month-over-Month revenue change
-- ============================================

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(amount) AS gross_revenue
    FROM orders
    WHERE order_date BETWEEN '2025-01-01' AND '2025-12-31'
      AND status = 'completed'
    GROUP BY 1
)

SELECT
    month,
    gross_revenue,
    LAG(gross_revenue) OVER (ORDER BY month) AS previous_month_revenue,
    gross_revenue
        - LAG(gross_revenue) OVER (ORDER BY month) AS revenue_change,
    100.0 *
        (
            gross_revenue
            - LAG(gross_revenue) OVER (ORDER BY month)
        )
        / NULLIF(
            LAG(gross_revenue) OVER (ORDER BY month),
            0
        ) AS revenue_change_pct
FROM monthly_revenue
ORDER BY month;


-- ============================================
-- 3. Repeat customers (>=2 orders in 2025)
-- ============================================

WITH customer_orders AS (
    SELECT
        o.customer_id,
        c.customer_name,
        COUNT(*) AS total_completed_orders_2025,
        SUM(o.amount) AS total_revenue_2025
    FROM orders o
    LEFT JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_date BETWEEN '2025-01-01' AND '2025-12-31'
      AND o.status = 'completed'
    GROUP BY 1,2
)

SELECT
    customer_id,
    customer_name,
    total_completed_orders_2025,
    total_revenue_2025
FROM customer_orders
WHERE total_completed_orders_2025 >= 2
ORDER BY total_completed_orders_2025 DESC,
         total_revenue_2025 DESC;


-- ============================================
-- 4. First purchase & customer type
-- ============================================

WITH customer_orders AS (
    SELECT
        o.customer_id,
        c.customer_name,
        MIN(o.order_date) AS first_order_date_2025,
        COUNT(*) AS total_completed_orders_2025
    FROM orders o
    LEFT JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_date BETWEEN '2025-01-01' AND '2025-12-31'
      AND o.status = 'completed'
    GROUP BY 1,2
)

SELECT
    customer_id,
    customer_name,
    first_order_date_2025,
    total_completed_orders_2025,
    CASE
        WHEN total_completed_orders_2025 = 1 THEN 'one-time'
        ELSE 'repeat'
    END AS customer_type
FROM customer_orders
ORDER BY first_order_date_2025,
         customer_id;


-- ============================================
-- 5. Monthly returning customers
-- ============================================

WITH customer_orders AS (
    SELECT
        customer_id,
        order_date,
        MIN(order_date) OVER (PARTITION BY customer_id) AS first_order_date_2025
    FROM orders
    WHERE order_date BETWEEN '2025-01-01' AND '2025-12-31'
      AND status = 'completed'
),

customer_status AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', order_date) AS month,
        CASE
            WHEN DATE_TRUNC('month', first_order_date_2025)
                 < DATE_TRUNC('month', order_date)
            THEN 'returning'
            ELSE 'new'
        END AS customer_category
    FROM customer_orders
)

SELECT
    month,
    COUNT(DISTINCT customer_id) AS customers_in_month,
    COUNT(DISTINCT customer_id)
        FILTER (WHERE customer_category = 'returning')
        AS returning_customers,
    100.0 *
        COUNT(DISTINCT customer_id)
            FILTER (WHERE customer_category = 'returning')
        / NULLIF(
            COUNT(DISTINCT customer_id),
            0
        ) AS returning_customers_pct
FROM customer_status
GROUP BY month
ORDER BY month;


-- ============================================
-- 6. Returns impact on revenue
-- ============================================

WITH monthly_metrics AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(o.amount) AS gross_revenue,
        SUM(COALESCE(r.return_amount, 0)) AS returned_amount
    FROM orders o
    LEFT JOIN returns r
        ON o.order_id = r.order_id
    WHERE o.order_date BETWEEN '2025-01-01' AND '2025-12-31'
      AND o.status = 'completed'
    GROUP BY 1
)

SELECT
    month,
    gross_revenue,
    returned_amount,
    gross_revenue - returned_amount AS net_revenue,
    100.0 *
        returned_amount
        / NULLIF(gross_revenue, 0) AS return_rate_pct
FROM monthly_metrics
ORDER BY month;


-- ============================================
-- 7. Category performance
-- ============================================

WITH category_metrics AS (
    SELECT
        category,
        COUNT(*) AS total_orders,
        SUM(amount) AS gross_revenue,
        AVG(amount) AS avg_order_value,
        SUM(SUM(amount)) OVER () AS company_total_revenue
    FROM orders
    WHERE order_date BETWEEN '2025-01-01' AND '2025-12-31'
      AND status = 'completed'
    GROUP BY category
)

SELECT
    category,
    total_orders,
    gross_revenue,
    avg_order_value,
    100.0 *
        gross_revenue
        / NULLIF(company_total_revenue, 0) AS revenue_share_pct
FROM category_metrics
ORDER BY gross_revenue DESC;


-- ============================================
-- 8. Customer segmentation (NTILE)
-- ============================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        c.customer_name,
        COUNT(*) AS total_orders_2025,
        SUM(o.amount) AS total_revenue_2025
    FROM orders o
    LEFT JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_date BETWEEN '2025-01-01' AND '2025-12-31'
      AND o.status = 'completed'
    GROUP BY 1,2
),

segmented_customers AS (
    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY total_revenue_2025 DESC
        ) AS revenue_quintile
    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    total_orders_2025,
    total_revenue_2025,
    CASE
        WHEN revenue_quintile = 1 THEN 'top_customers'
        WHEN revenue_quintile BETWEEN 2 AND 4 THEN 'mid_customers'
        ELSE 'low_customers'
    END AS customer_segment
FROM segmented_customers
ORDER BY total_revenue_2025 DESC;