-- Day 54 - Task D
-- Customer segmentation based on revenue quartiles

WITH customer_metric AS (
  SELECT
    customer_id,
    SUM(amount) AS total_revenue
  FROM transactions
  GROUP BY customer_id
),
customer_quartiles AS (
  SELECT
    customer_id,
    total_revenue,
    NTILE(4) OVER (ORDER BY total_revenue DESC, customer_id) AS quartile
  FROM customer_metric
)

SELECT
  customer_id,
  total_revenue,
  quartile,
  CASE
    WHEN quartile = 1 THEN 'VIP'
    WHEN quartile = 2 THEN 'Loyal'
    WHEN quartile = 3 THEN 'Regular'
    WHEN quartile = 4 THEN 'Low value'
  END AS customer_segment
FROM customer_quartiles
ORDER BY quartile, total_revenue DESC;
