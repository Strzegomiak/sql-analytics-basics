-- DAY 40: Running totals (kumulacja per klient)

-- A) Kumulacja kwoty per klient po dacie (running total)
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    -- TODO: dodaj świadomie ramkę (np. RANGE/ROWS)
  ) AS running_total
FROM transactions;

-- B) Kumulacja globalna (bez PARTITION BY) po dacie
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  SUM(amount) OVER (
    ORDER BY transaction_date, transaction_id
  ) AS running_total_all
FROM transactions;

-- DAY 41: ROWS vs RANGE

-- A) Suma z ostatnich 3 transakcji klienta (bieżąca + 2 poprzednie) => ROWS
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS sum_last_3_txn
FROM transactions;

-- B) Suma w oknie czasowym 7 dni (jeśli DB wspiera INTERVAL w RANGE)
-- TODO: jeśli Twoja baza nie wspiera INTERVAL w RANGE, zrobimy to jutro inaczej
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date
    -- TODO: spróbuj:
    -- RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW
  ) AS sum_last_7_days
FROM transactions;

-- DAY 42: LAG / LEAD

-- A) Poprzednia transakcja klienta (kwota)
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  LAG(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
  ) AS prev_amount
FROM transactions;

-- B) Następna transakcja klienta (kwota)
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  LEAD(amount) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date, transaction_id
  ) AS next_amount
FROM transactions;

-- DAY 44: Change classification (trend)

WITH m AS (
  SELECT
    transaction_id,
    customer_id,
    transaction_date,
    amount,
    LAG(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date, transaction_id
    ) AS prev_amount
  FROM transactions
)
SELECT
  transaction_id,
  customer_id,
  transaction_date,
  amount,
  prev_amount,
  amount - prev_amount AS diff_vs_prev,
  CASE
    WHEN prev_amount IS NULL THEN 'first_transaction'
    WHEN amount IS NULL THEN 'missing_amount'
    WHEN amount > prev_amount THEN 'increase'
    WHEN amount < prev_amount THEN 'decrease'
    ELSE 'no_change'
  END AS change_type
FROM m;
