-- Day 15: JOIN + aggregation (avoid double counting)
-- Tables used: customers(customer_id, customer_name), transactions(transaction_id, customer_id, amount)

-- =========================================================
-- Task 1: Total revenue per customer (include customers with no transactions)
-- Business idea: show revenue per customer; missing revenue should be 0.
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(tr.total_revenue, 0) AS total_revenue
FROM customers c
LEFT JOIN (
    SELECT
        customer_id,
        SUM(amount) AS total_revenue
    FROM transactions
    GROUP BY customer_id
) tr
    ON c.customer_id = tr.customer_id
ORDER BY c.customer_id;

-- =========================================================
-- Task 2: Number of transactions + total revenue per customer
-- Business idea: frequency (COUNT) + value (SUM) in one customer-level summary.
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(tr.transaction_count, 0) AS transaction_count,
    COALESCE(tr.total_revenue, 0) AS total_revenue
FROM customers c
LEFT JOIN (
    SELECT
        customer_id,
        COUNT(transaction_id) AS transaction_count,
        SUM(amount) AS total_revenue
    FROM transactions
    GROUP BY customer_id
) tr
    ON c.customer_id = tr.customer_id
ORDER BY c.customer_id;

-- =========================================================
-- Task 3: Only active customers (more than 3 transactions)
-- Business idea: filter after aggregation to keep only high-activity customers.
SELECT
    c.customer_id,
    c.customer_name,
    tr.transaction_count
FROM customers c
JOIN (
    SELECT
        customer_id,
        COUNT(transaction_id) AS transaction_count
    FROM transactions
    GROUP BY customer_id
    HAVING COUNT(transaction_id) > 3
) tr
    ON c.customer_id = tr.customer_id
ORDER BY tr.transaction_count DESC, c.customer_id;

-- =========================================================
-- Task 4 (one sentence, interview-ready):
-- Joining tables before agreggation can change the level of detail by multiplying rows, which can distort aggregates like SUM or COUNT.
