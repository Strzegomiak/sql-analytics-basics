 -- DAY 36
-- Topic: Benchmarking customers vs average revenue per customer
-- Goal: Calculate revenue per customer, compute benchmark once, compare each customer to it.

-- Task A: Customer metrics (transactions count + total revenue)
WITH customer_metric AS (
  SELECT
    c.customer_id,
    COUNT(t.transaction_id) AS number_of_transactions,          -- IMPORTANT: COUNT(*) would count 1 even for customers with no transactions (LEFT JOIN)
    COALESCE(SUM(t.amount), 0) AS total_revenue_per_customer
  FROM customers c
  LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
  GROUP BY c.customer_id
),

-- Task B: Benchmark (one number)
avg_metric AS (
  SELECT
    AVG(total_revenue_per_customer) AS average_revenue_per_customer
  FROM customer_metric
)

-- Task C: Compare each customer to the benchmark
SELECT
  cm.customer_id,
  cm.number_of_transactions,
  cm.total_revenue_per_customer,
  am.average_revenue_per_customer,
  cm.total_revenue_per_customer - am.average_revenue_per_customer AS diff_vs_avg,
  CASE
    WHEN cm.total_revenue_per_customer > am.average_revenue_per_customer THEN 'above average'
    WHEN cm.total_revenue_per_customer < am.average_revenue_per_customer THEN 'below average'
    ELSE 'equal to the average'
  END AS revenue_flag
FROM customer_metric cm
CROSS JOIN avg_metric am
ORDER BY cm.total_revenue_per_customer DESC;

-- DAY 36 (Alternative)
-- Using a window function to attach the same benchmark to every row.

WITH customer_metric AS (
  SELECT
    c.customer_id,
    COUNT(t.transaction_id) AS number_of_transactions,
    COALESCE(SUM(t.amount), 0) AS total_revenue_per_customer
  FROM customers c
  LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
  GROUP BY c.customer_id
)
SELECT
  customer_id,
  number_of_transactions,
  total_revenue_per_customer,
  AVG(total_revenue_per_customer) OVER () AS average_revenue_per_customer,
  total_revenue_per_customer - AVG(total_revenue_per_customer) OVER () AS diff_vs_avg,
  CASE
    WHEN total_revenue_per_customer > AVG(total_revenue_per_customer) OVER () THEN 'above average'
    WHEN total_revenue_per_customer < AVG(total_revenue_per_customer) OVER () THEN 'below average'
    ELSE 'equal to the average'
  END AS revenue_flag
FROM customer_metric
ORDER BY total_revenue_per_customer DESC;
-- DAY 35
-- Topic: Window Functions recap
-- Goal: Use window functions for per-customer totals, averages, percentage share, and ranking.

-- A) Total revenue per customer (repeat the total on every transaction row)
SELECT
  transaction_id,
  customer_id,
  amount,
  SUM(amount) OVER (PARTITION BY customer_id) AS total_revenue_per_customer
FROM transactions;

-- B) Add average transaction amount per customer and difference vs that average
SELECT
  transaction_id,
  customer_id,
  amount,
  AVG(amount) OVER (PARTITION BY customer_id) AS avg_transaction_per_customer,
  amount - AVG(amount) OVER (PARTITION BY customer_id) AS diff_vs_customer_avg
FROM transactions;

-- C) Percent of customer's total revenue (needs repeating SUM(...) expression, not alias)
-- NOTE: * 1.0 forces decimal division (avoid integer division in some SQL engines).
SELECT
  transaction_id,
  customer_id,
  amount,
  SUM(amount) OVER (PARTITION BY customer_id) AS total_revenue_per_customer,
  amount * 1.0
    / SUM(amount) OVER (PARTITION BY customer_id) AS percent_of_total_revenue_per_customer
FROM transactions;

-- D) Rank customers by total revenue (customer-level output)
WITH customer_metric AS (
  SELECT
    customer_id,
    SUM(amount) AS total_revenue_per_customer
  FROM transactions
  GROUP BY customer_id
)
SELECT
  customer_id,
  total_revenue_per_customer,
  RANK() OVER (ORDER BY total_revenue_per_customer DESC) AS revenue_rank
FROM customer_metric
ORDER BY revenue_rank;

