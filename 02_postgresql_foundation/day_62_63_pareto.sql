/*
===========================================================
Łukaszek become Analyst
Day 62–63
Topic: Customer Revenue Analysis (PostgreSQL)

Concepts practiced:
- Aggregations
- Window functions
- Ranking
- Revenue share
- Quartiles (NTILE)
- Pareto analysis (80/20 rule)

Dataset: transactions
===========================================================
*/


/*
===========================================================
CREATE TABLE AND SAMPLE DATA
===========================================================
*/

DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    amount NUMERIC(10,2)
);

INSERT INTO transactions (transaction_id, customer_id, transaction_date, amount) VALUES
(1, 101, '2024-01-03', 120.50),
(2, 102, '2024-01-05', 75.00),
(3, 103, '2024-01-08', 210.30),
(4, 101, '2024-01-10', 95.20),
(5, 104, '2024-01-12', 40.00),
(6, 105, '2024-01-14', 310.00),
(7, 102, '2024-01-15', 55.90),
(8, 106, '2024-01-18', 480.00),
(9, 103, '2024-01-21', 150.00),
(10, 107, '2024-01-22', 60.00),

(11, 108, '2024-02-01', 520.00),
(12, 101, '2024-02-02', 130.00),
(13, 105, '2024-02-05', 90.00),
(14, 104, '2024-02-06', 75.50),
(15, 109, '2024-02-08', 260.00),
(16, 110, '2024-02-10', 340.00),
(17, 103, '2024-02-11', 80.00),
(18, 102, '2024-02-13', 45.00),
(19, 106, '2024-02-15', 120.00),
(20, 107, '2024-02-18', 200.00),

(21, 108, '2024-03-01', 310.00),
(22, 105, '2024-03-02', 70.00),
(23, 101, '2024-03-04', 150.00),
(24, 109, '2024-03-05', 90.00),
(25, 110, '2024-03-06', 400.00),
(26, 104, '2024-03-08', 35.00),
(27, 102, '2024-03-10', 60.00),
(28, 103, '2024-03-12', 140.00),
(29, 106, '2024-03-15', 220.00),
(30, 108, '2024-03-18', 180.00);


/*
===========================================================
TASK 1
Customer revenue metrics
===========================================================
Calculate:
- number of transactions
- total revenue
- average transaction value
per customer
*/

SELECT
    customer_id,
    COUNT(*) AS transactions_cnt,
    SUM(amount) AS total_revenue,
    ROUND(AVG(amount),2) AS avg_transaction_value
FROM transactions
GROUP BY customer_id;


/*
===========================================================
TASK 2
Customer revenue ranking
===========================================================
Rank customers based on total revenue
*/

SELECT
    customer_id,
    SUM(amount) AS customer_revenue,
    RANK() OVER(ORDER BY SUM(amount) DESC) AS revenue_rank
FROM transactions
GROUP BY customer_id;


/*
===========================================================
TASK 3
Customer share of total revenue
===========================================================
Calculate percentage contribution of each customer
to total revenue
*/

WITH customer_metric AS (
    SELECT
        customer_id,
        SUM(amount) AS customer_revenue,
        RANK() OVER(ORDER BY SUM(amount) DESC) AS revenue_rank
    FROM transactions
    GROUP BY customer_id
),
revenue_metric AS (
    SELECT
        *,
        SUM(customer_revenue) OVER() AS total_revenue
    FROM customer_metric
)

SELECT
    customer_id,
    customer_revenue,
    revenue_rank,
    ROUND(
        100.0 * customer_revenue / NULLIF(total_revenue,0),
        2
    ) AS revenue_share_perc
FROM revenue_metric;


/*
===========================================================
TASK 4
Customer revenue quartiles
===========================================================
Segment customers into 4 groups based on revenue
*/

SELECT
    customer_id,
    SUM(amount) AS customer_revenue,
    NTILE(4) OVER(ORDER BY SUM(amount) DESC) AS revenue_quartile
FROM transactions
GROUP BY customer_id;


/*
===========================================================
BONUS
Top 10 customers revenue contribution
===========================================================
What percentage of total revenue is generated
by the top 10 customers?
*/

WITH customer_metric AS (
    SELECT
        customer_id,
        SUM(amount) AS customer_revenue,
        RANK() OVER(ORDER BY SUM(amount) DESC) AS revenue_rank
    FROM transactions
    GROUP BY customer_id
)

SELECT
    SUM(customer_revenue) FILTER(WHERE revenue_rank <= 10) AS top10_revenue,
    SUM(customer_revenue) AS total_revenue,
    ROUND(
        100.0 * SUM(customer_revenue) FILTER(WHERE revenue_rank <= 10)
        / NULLIF(SUM(customer_revenue),0),
        2
    ) AS top10_vs_total_revenue_perc
FROM customer_metric;


/*
===========================================================
PARETO ANALYSIS (80/20 RULE)
===========================================================
Identify how many customers generate 80% of revenue
*/

WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(amount) AS customer_revenue
    FROM transactions
    GROUP BY customer_id
),

pareto AS (
    SELECT
        customer_id,
        customer_revenue,
        SUM(customer_revenue) OVER(ORDER BY customer_revenue DESC) AS cumulative_revenue,
        SUM(customer_revenue) OVER() AS total_revenue
    FROM customer_revenue
)

SELECT
    COUNT(*) AS customers_generating_80_percent_revenue
FROM pareto
WHERE cumulative_revenue <= 0.8 * total_revenue;


/*
===========================================================
FULL PARETO TABLE
===========================================================
Useful for building Pareto charts
*/

WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(amount) AS customer_revenue
    FROM transactions
    GROUP BY customer_id
)

SELECT
    customer_id,
    customer_revenue,
    RANK() OVER(ORDER BY customer_revenue DESC) AS revenue_rank,
    SUM(customer_revenue) OVER(ORDER BY customer_revenue DESC) AS cumulative_revenue,
    SUM(customer_revenue) OVER() AS total_revenue,
    ROUND(
        100.0 *
        SUM(customer_revenue) OVER(ORDER BY customer_revenue DESC)
        / SUM(customer_revenue) OVER(),
        2
    ) AS cumulative_revenue_perc
FROM customer_revenue;
