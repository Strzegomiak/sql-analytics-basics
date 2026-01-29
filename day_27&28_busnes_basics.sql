 /* =========================================================
   DAY 27–28: Business Metrics & Customer KPIs
   Author: Lukasz
   Description:
   This file contains basic and intermediate business KPI
   calculations using SQL. The focus is on correct aggregation
   levels and business interpretation of metrics.
   ========================================================= */


/* ---------------------------------------------------------
   DAY 27 – Basic Customer Metrics
   --------------------------------------------------------- */


/* Task A: Total number of customers
   This query returns the total number of customers
   based on the customers table.
*/
SELECT
  COUNT(*) AS total_number_of_customers
FROM customers;


/* Task B: Number of active customers
   An active customer is defined as a customer who has
   at least one transaction.
*/
SELECT
  COUNT(DISTINCT customer_id) AS number_of_active_customers
FROM transactions;


/* Task C: Total revenue
   This query calculates the total revenue generated
   from all transactions.
*/
SELECT
  SUM(amount) AS total_revenue
FROM transactions;


/* ---------------------------------------------------------
   DAY 28 – Revenue-Based KPIs
   --------------------------------------------------------- */


/* Task D: Average transaction value (AOV)
   This query calculates the average value of a single
   transaction. NULL values are ignored by AVG().
*/
SELECT
  AVG(amount) AS average_transaction_value
FROM transactions;


/* Task E: Average revenue per customer (ARPU)
   This query calculates the average total revenue
   generated per customer.
   First, total revenue is calculated per customer.
   Then, the average of those values is returned.
*/
WITH per_customer_metric AS (
  SELECT
    c.customer_id,
    COALESCE(SUM(t.amount), 0) AS total_revenue_per_customer
  FROM customers c
  LEFT JOIN transactions t
    ON t.customer_id = c.customer_id
  GROUP BY c.customer_id
)
SELECT
  AVG(total_revenue_per_customer) AS avg_revenue_per_customer
FROM per_customer_metric;
