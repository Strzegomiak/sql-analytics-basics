-- ============================================================
-- Day 32 — Simplified Customer Lifetime Value (CLV)
-- Tables: customers, transactions
-- Goal: Calculate CLV per customer, average CLV, and CLV segments.
-- ============================================================


-- ------------------------------------------------------------
-- Task A: CLV per customer (total revenue per customer)
-- Business meaning: How much revenue each customer generated in total.
-- Note: LEFT JOIN keeps customers with no transactions (CLV = 0).
-- ------------------------------------------------------------
SELECT
  c.customer_id,
  COALESCE(SUM(t.amount), 0) AS total_revenue_per_customer
FROM customers c
LEFT JOIN transactions t
  ON c.customer_id = t.customer_id
GROUP BY c.customer_id
ORDER BY total_revenue_per_customer DESC;


-- ------------------------------------------------------------
-- Task B: Average CLV (company-level)
-- Business meaning: The average total revenue generated per customer.
-- ------------------------------------------------------------
WITH customer_metric AS (
  SELECT
    c.customer_id,
    COALESCE(SUM(t.amount), 0) AS total_revenue_per_customer
  FROM customers c
  LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
  GROUP BY c.customer_id
)
SELECT
  AVG(total_revenue_per_customer) AS avg_clv
FROM customer_metric;


-- ------------------------------------------------------------
-- Task C: CLV segmentation (mini-dashboard)
-- Segments:
--   low value    : CLV < 500
--   medium value : 500–2000
--   high value   : > 2000
--
-- Output:
--   - value_category
--   - number of customers per category
--   - total revenue per category
-- ------------------------------------------------------------
WITH customer_metric AS (
  SELECT
    c.customer_id,
    COALESCE(SUM(t.amount), 0) AS total_revenue_per_customer,
    CASE
      WHEN COALESCE(SUM(t.amount), 0) < 500 THEN 'low value'
      WHEN COALESCE(SUM(t.amount), 0) BETWEEN 500 AND 2000 THEN 'medium value'
      ELSE 'high value'
    END AS value_category
  FROM customers c
  LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
  GROUP BY c.customer_id
)
SELECT
  value_category,
  COUNT(*) AS number_of_customers_per_category,
  SUM(total_revenue_per_customer) AS revenue_per_category
FROM customer_metric
GROUP BY value_category
ORDER BY revenue_per_category DESC;


-- ------------------------------------------------------------
-- Business explanation (English)
-- This analysis segments customers into value categories based on their total revenue.
-- It shows the number of customers and the total revenue generated in each segment.
-- ------------------------------------------------------------
