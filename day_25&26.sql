-- DAY 25
-- Topic: Common Table Expressions (CTE) and customer-level aggregation
-- Goal: Improve query readability and structure complex logic step by step

-- This CTE calculates the number of transactions per customer
WITH transactions_per_customer AS (
    SELECT
        customer_id,
        COUNT(transaction_id) AS number_of_transactions
    FROM transactions
    GROUP BY customer_id
)

-- The final SELECT simply reads from the CTE
SELECT
    customer_id,
    number_of_transactions
FROM transactions_per_customer;
-- DAY 25 (extended version)
-- Topic: Filtering aggregated results using HAVING inside a CTE

-- This CTE keeps only customers with more than 3 transactions
WITH transactions_per_customer AS (
    SELECT
        customer_id,
        COUNT(transaction_id) AS number_of_transactions
    FROM transactions
    GROUP BY customer_id
    HAVING COUNT(transaction_id) > 3
)

-- Final result shows only active customers
SELECT
    customer_id,
    number_of_transactions
FROM transactions_per_customer;
-- DAY 26
-- Topic: Customer segmentation using aggregation and CASE
-- Goal: Move from transaction-level analysis to customer-level insights

-- This CTE calculates customer-level metrics
WITH customer_metrics AS (
    SELECT
        customer_id,
        COUNT(transaction_id) AS number_of_transactions,
        SUM(amount) AS total_amount
    FROM transactions
    GROUP BY customer_id
)

-- This CTE assigns each customer to an activity segment
, customer_segments AS (
    SELECT
        customer_id,
        total_amount,
        CASE
            WHEN number_of_transactions >= 5 THEN 'very active'
            WHEN number_of_transactions BETWEEN 3 AND 4 THEN 'active'
            ELSE 'inactive'
        END AS customer_segment
    FROM customer_metrics
)

-- Final query aggregates results at segment level
SELECT
    customer_segment,
    COUNT(*) AS number_of_customers,
    SUM(total_amount) AS segment_revenue
FROM customer_segments
GROUP BY customer_segment
ORDER BY segment_revenue DESC;
