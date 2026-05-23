-- =====================================================
-- 01 DATA CLEANING
-- Sales Performance Intelligence Dashboard
-- =====================================================


-- Create raw staging table for CSV import
DROP TABLE IF EXISTS transactions_raw;

CREATE TABLE transactions_raw (
    invoice TEXT,
    stockcode TEXT,
    description TEXT,
    quantity TEXT,
    invoicedate TEXT,
    price TEXT,
    customer_id TEXT,
    country TEXT
);


-- Create cleaned analytical table
DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions AS
SELECT
    invoice,
    stockcode,
    description,
    CAST(quantity AS INT) AS quantity,
    TO_TIMESTAMP(invoicedate, 'DD.MM.YYYY HH24:MI') AS invoicedate,
    CAST(REPLACE(price, ',', '.') AS NUMERIC) AS price,
    CAST(customer_id AS INT) AS customer_id,
    country,
    CAST(quantity AS INT) * CAST(REPLACE(price, ',', '.') AS NUMERIC) AS revenue,
    EXTRACT(YEAR FROM TO_TIMESTAMP(invoicedate, 'DD.MM.YYYY HH24:MI')) AS year,
    EXTRACT(MONTH FROM TO_TIMESTAMP(invoicedate, 'DD.MM.YYYY HH24:MI')) AS month,
    TO_CHAR(TO_TIMESTAMP(invoicedate, 'DD.MM.YYYY HH24:MI'), 'YYYY-MM') AS yearmonth,
    EXTRACT(DOW FROM TO_TIMESTAMP(invoicedate, 'DD.MM.YYYY HH24:MI')) AS dayofweek,
    EXTRACT(HOUR FROM TO_TIMESTAMP(invoicedate, 'DD.MM.YYYY HH24:MI')) AS hour
FROM transactions_raw
WHERE customer_id IS NOT NULL
  AND quantity ~ '^[0-9-]+$'
  AND price IS NOT NULL;


-- Basic data quality checks
SELECT
    COUNT(*) AS raw_rows,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE invoice IS NULL) AS missing_invoice,
    COUNT(*) FILTER (WHERE price IS NULL) AS missing_price
FROM transactions_raw;


-- Cleaned table row count
SELECT
    COUNT(*) AS cleaned_rows
FROM transactions;


-- Preview cleaned data
SELECT *
FROM transactions
LIMIT 10;