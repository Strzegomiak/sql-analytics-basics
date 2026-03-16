-- =========================
-- DAY 24 – CASE / BUSINESS LOGIC
-- =========================


-- Task A: Classify transactions by amount (low / medium / high)
SELECT
    transaction_id,
    amount,
    CASE 
        WHEN amount < 100 THEN 'low'
        WHEN amount BETWEEN 100 AND 299 THEN 'medium'
        ELSE 'high'
    END AS transaction_category
FROM transactions
ORDER BY transaction_category;


-- Task B: Logical flag (0 / 1) for high-value transactions
SELECT
    transaction_id,
    amount,
    CASE 
        WHEN amount >= 200 THEN 1
        ELSE 0
    END AS is_high_value
FROM transactions
ORDER BY is_high_value;


-- Task C: Number of transactions per category (CASE + GROUP BY)
SELECT
    CASE 
        WHEN amount < 100 THEN 'low'
        WHEN amount BETWEEN 100 AND 299 THEN 'medium'
        ELSE 'high'
    END AS transaction_category,
    COUNT(*) AS number_of_transactions
FROM transactions
GROUP BY 
    CASE 
        WHEN amount < 100 THEN 'low'
        WHEN amount BETWEEN 100 AND 299 THEN 'medium'
        ELSE 'high'
    END
ORDER BY transaction_category;


-- Task C (simplified version using CTE)
WITH categorized_transactions AS (
    SELECT
        CASE 
            WHEN amount < 100 THEN 'low'
            WHEN amount BETWEEN 100 AND 299 THEN 'medium'
            ELSE 'high'
        END AS transaction_category
    FROM transactions
)
SELECT
    transaction_category,
    COUNT(*) AS number_of_transactions
FROM categorized_transactions
GROUP BY transaction_category
ORDER BY transaction_category;


-- Task D: Customer classification (active / inactive)
WITH transactions_per_customer AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(t.transaction_id) AS number_of_transactions
    FROM customers c
    LEFT JOIN transactions t
        ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    number_of_transactions,
    CASE
        WHEN number_of_transactions >= 5 THEN 'active'
        ELSE 'inactive'
    END AS customer_status
FROM transactions_per_customer;
