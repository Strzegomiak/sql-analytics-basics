# Power BI – Sales Dashboard (Training Project)

## Project overview

This project presents a basic analytical dashboard built in Power BI using transactional sales data.

The goal was to practice a typical Data Analyst workflow:

SQL-style thinking → data preparation → data modeling → KPI creation → business interpretation.

The dataset contains transaction-level sales data with customer and product information.

---

## Data sources

### Transactions table
Columns:
- transaction_id
- customer
- product
- amount
- transaction_date

### Customers table
Columns:
- customer
- city

---

## Data model

Relationships:

Calendar[Date] (1) → (*) Transactions[transaction_date]

Customers[customer] (1) → (*) Transactions[customer]

Calendar table was created to support time intelligence calculations (MoM, MTD, YTD).

---

## Measures (DAX)

### Total Revenue
```DAX
Total Revenue =
SUM(Arkusz1[amount])
