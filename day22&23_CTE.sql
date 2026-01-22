 -- ============================================
-- DAY 22 & DAY 23
-- WINDOW FUNCTIONS – TOP-N ANALYSIS
-- RANK / ROW_NUMBER / PARTITION BY
-- ============================================


-- ============================================
-- DAY 22
-- Global TOP-N (bez podziału na grupy)
-- ============================================


-- Zadanie A
-- Top 3 transakcje GLOBALNIE według customer_id (malejąco)

SELECT
    transaction_id,
    customer_id,
    amount,
    rank_by_customer
FROM (
    SELECT
        transaction_id,
        customer_id,
        amount,
        RANK() OVER (
            ORDER BY customer_id DESC
        ) AS rank_by_customer
    FROM transactions
) t
WHERE rank_by_customer <= 3
ORDER BY rank_by_customer;


-- Zadanie B
-- Top 1 transakcja GLOBALNIE według customer_id

SELECT
    transaction_id,
    customer_id,
    amount,
    customer_top1
FROM (
    SELECT
        transaction_id,
        customer_id,
        amount,
        RANK() OVER (
            ORDER BY customer_id DESC
        ) AS customer_top1
    FROM transactions
) t
WHERE customer_top1 <= 1
ORDER BY customer_top1;



-- ============================================
-- DAY 23
-- TOP-N PER GROUP (PARTITION BY)
-- ============================================


-- Zadanie A
-- Top 3 transakcje dla KAŻDEGO klienta według amount

SELECT
    transaction_id,
    customer_id,
    amount,
    transaction_rank
FROM (
    SELECT
        transaction_id,
        customer_id,
        amount,
        RANK() OVER (
            PARTITION BY customer_id
            ORDER BY amount DESC
        ) AS transaction_rank
    FROM transactions
) t
WHERE transaction_rank <= 3
ORDER BY customer_id, transaction_rank;


-- Zadanie B
-- Najdroższa transakcja per klient (TOP 1)

SELECT
    transaction_id,
    customer_id,
    amount
FROM (
    SELECT
        transaction_id,
        customer_id,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY amount DESC
        ) AS rn
    FROM transactions
) t
WHERE rn = 1
ORDER BY customer_id;


-- Zadanie C
-- Top 2 transakcje per klient (bez remisów)

SELECT
    transaction_id,
    customer_id,
    amount,
    rn
FROM (
    SELECT
        transaction_id,
        customer_id,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY amount DESC
        ) AS rn
    FROM transactions
) t
WHERE rn <= 2
ORDER BY customer_id, rn;
