-- Day 29
-- This query returns customers who have at least one transaction
-- with an amount greater than 1000.
-- The EXISTS clause is used to check the existence of such a transaction
-- without counting or aggregating data.

SELECT 
  c.customer_id,
  c.customer_name
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM transactions t
  WHERE t.customer_id = c.customer_id
    AND t.amount > 1000
);

-- Day 30
-- Step 1: Calculate revenue metrics per customer.
-- One row represents one customer.
-- LEFT JOIN is used to include customers without transactions.

WITH customer_metrics AS (
  SELECT
    c.customer_id,
    COUNT(t.transaction_id) AS number_of_transactions,
    SUM(t.amount) AS total_revenue_per_customer,
    AVG(t.amount) AS average_transaction_value
  FROM customers c
  LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
  GROUP BY c.customer_id
)

-- Step 2: Calculate average revenue per customer.
-- This is NOT the same as AVG(amount) from transactions table.
-- First we calculate revenue per customer, then we average across customers.

SELECT
  AVG(total_revenue_per_customer) AS average_revenue_per_customer
FROM customer_metrics;

-- Day 31
-- Step 1: Calculate metrics per customer.
-- One row represents one customer.
-- We calculate number of transactions and total revenue per customer.

WITH customer_metric AS (
  SELECT 
    c.customer_id,
    COUNT(t.transaction_id) AS number_of_transactions,
    SUM(t.amount) AS total_revenue_per_customer
  FROM customers c
  LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
  GROUP BY c.customer_id
),

-- Step 2: Assign customer status based on number of transactions.
-- The business logic is applied after metrics are calculated.

customer_status AS (
  SELECT
    customer_id,
    number_of_transactions,
    total_revenue_per_customer,
    CASE 
      WHEN number_of_transactions >= 10 THEN 'vip'
      WHEN number_of_transactions BETWEEN 4 AND 9 THEN 'active'
      ELSE 'inactive'
    END AS customer_status
  FROM customer_metric
)

-- Step 3: Aggregate results at customer status level.
-- One row represents one customer status.
-- We count customers and sum their revenues.

SELECT 
  customer_status,
  COUNT(*) AS number_of_customers,
  SUM(total_revenue_per_customer) AS total_revenue_per_status
FROM customer_status
GROUP BY customer_status
ORDER BY total_revenue_per_status DESC;
