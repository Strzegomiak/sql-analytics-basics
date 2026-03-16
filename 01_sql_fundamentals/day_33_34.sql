/* =========================================================
   DAY 33 — Window Functions (SUM / AVG) + % of total
   Topic: basic window aggregates per customer
   DB: PostgreSQL-style SQL
   ========================================================= */

-- Task A
-- For each transaction, show the customer's total revenue (without collapsing rows).
SELECT
  transaction_id,
  customer_id,
  amount,
  SUM(amount) OVER (PARTITION BY customer_id) AS total_revenue_per_customer
FROM transactions
ORDER BY customer_id, transaction_id;


-- Task B
-- Add average transaction value per customer and show the difference vs that average.
-- Note: you cannot reuse SELECT aliases (like avg_revenue_per_customer) inside the same SELECT expression,
-- so we either repeat the window expression or use a CTE/subquery.
SELECT
  transaction_id,
  customer_id,
  amount,
  SUM(amount) OVER (PARTITION BY customer_id) AS total_revenue_per_customer,
  AVG(amount) OVER (PARTITION BY customer_id) AS avg_transaction_value_per_customer,
  amount - AVG(amount) OVER (PARTITION BY customer_id) AS diff_vs_avg_transaction_value
FROM transactions
ORDER BY customer_id, transaction_id;


-- Task C
-- Show what % of the customer's total revenue each transaction represents.
-- Again: we repeat the window SUM(...) because aliases can't be referenced in the same SELECT list.
-- "* 1.0" (or casting to numeric) is used in some DBs to force decimal division (avoid integer division).
-- In PostgreSQL, amount is usually numeric, so it's often not needed, but it's a good habit when types are integers.
SELECT
  transaction_id,
  customer_id,
  amount,
  SUM(amount) OVER (PARTITION BY customer_id) AS total_revenue_per_customer,
  (amount * 1.0) / SUM(amount) OVER (PARTITION BY customer_id) AS percent_of_total_revenue_per_customer
FROM transactions
ORDER BY customer_id, transaction_id;
/* =========================================================
   DAY 34 — Window Functions (Ranking + customer vs average)
   Topic: keep all customers (including those with 0 transactions)
   DB: PostgreSQL-style SQL
   ========================================================= */

-- Task A
-- For each transaction, show total revenue per customer (window SUM).
SELECT
  transaction_id,
  customer_id,
  amount,
  SUM(amount) OVER (PARTITION BY customer_id) AS total_revenue_per_customer
FROM transactions
ORDER BY customer_id, transaction_id;


-- Task B
-- Rank customers by total revenue (include ALL customers, even those with no transactions).
-- Step 1: aggregate to 1 row per customer
-- Step 2: rank using a window function
WITH revenue_per_customer AS (
  SELECT
    c.customer_id,
    COALESCE(SUM(t.amount), 0) AS total_revenue_per_customer
  FROM customers c
  LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
  GROUP BY c.customer_id
)
SELECT
  customer_id,
  total_revenue_per_customer,
  RANK() OVER (ORDER BY total_revenue_per_customer DESC) AS revenue_rank
FROM revenue_per_customer
ORDER BY revenue_rank, customer_id;


-- Task C
-- Compare each customer's total revenue to the average revenue per customer.
-- Important: "average revenue per customer" = AVG(total_revenue_per_customer) across customers,
-- NOT AVG(transaction amount).
WITH revenue_per_customer AS (
  SELECT
    c.customer_id,
    COALESCE(SUM(t.amount), 0) AS total_revenue_per_customer
  FROM customers c
  LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
  GROUP BY c.customer_id
)
SELECT
  customer_id,
  total_revenue_per_customer,
  AVG(total_revenue_per_customer) OVER () AS average_revenue_all_customers,
  total_revenue_per_customer - AVG(total_revenue_per_customer) OVER () AS diff_vs_avg
FROM revenue_per_customer
ORDER BY diff_vs_avg DESC, customer_id;

