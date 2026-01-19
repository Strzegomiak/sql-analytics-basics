-- ============================================
-- Day 16: Subqueries and data levels
-- ============================================

-- ------------------------------------------------
-- Query 1
-- Calculate the number of transactions per customer
-- and filter customers with more than 3 transactions.
-- ------------------------------------------------
SELECT
    customer_id,
    number_of_transactions
FROM (
    SELECT
        customer_id,
        COUNT(*) AS number_of_transactions
    FROM transactions
    GROUP BY customer_id
) t
WHERE number_of_transactions > 3
ORDER BY number_of_transactions DESC;


-- ------------------------------------------------
-- Query 2
-- Categorize transactions into high and low
-- based on the transaction amount and count
-- how many transactions fall into each category.
-- ------------------------------------------------
SELECT
    transaction_category,
    COUNT(*) AS number_of_transactions
FROM (
    SELECT
        CASE
            WHEN amount >= 200 THEN 'high'
            ELSE 'low'
        END AS transaction_category
    FROM transactions
) t
GROUP BY transaction_category
ORDER BY number_of_transactions DESC;


-- ------------------------------------------------
-- Query 3
-- Calculate the number of transactions per customer
-- using data from two different tables by joining
-- aggregated transaction data with customer details.
-- ------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    t.number_of_transactions
FROM customers c
JOIN (
    SELECT
        customer_id,
        COUNT(*) AS number_of_transactions
    FROM transactions
    GROUP BY customer_id
) t
    ON c.customer_id = t.customer_id
WHERE t.number_of_transactions > 3
ORDER BY t.number_of_transactions DESC;
