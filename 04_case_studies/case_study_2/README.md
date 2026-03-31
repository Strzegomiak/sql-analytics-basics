# Case Study 2 — Customer Retention & Sales Performance

## Goal

Analyze customer behavior, retention patterns, and sales performance using SQL, Excel, and Power BI.

The objective was to simulate a real business scenario where a data analyst evaluates:

* revenue trends over time
* repeat vs one-time customers
* product category performance
* impact of returns on revenue
* customer value segmentation

---

## Tools used

* PostgreSQL (SQL analysis)
* Excel (data preparation & pivot validation)
* Power BI (dashboard visualization)

---

## Dataset structure

### customers

* customer_id
* customer_name
* city
* signup_date

### orders

* order_id
* customer_id
* order_date
* category
* amount
* status

### returns

* return_id
* order_id
* return_date
* return_amount

---

## SQL analysis

### 1. Monthly sales performance

Metrics:

* total orders
* unique customers
* gross revenue
* average order value

Purpose:
Evaluate overall company performance across time.

---

### 2. Month-over-Month revenue change

Metrics:

* previous month revenue
* revenue change
* percentage change

Purpose:
Understand growth dynamics and detect trends.

---

### 3. Repeat customers analysis

Metrics:

* number of orders per customer
* total revenue per customer

Purpose:
Identify customers who purchase more than once.

---

### 4. First purchase analysis

Metrics:

* first order date
* one-time vs repeat customers

Purpose:
Understand customer lifecycle behavior.

---

### 5. Monthly returning customers

Metrics:

* customers per month
* returning customers
* returning customer %

Purpose:
Measure customer retention quality.

---

### 6. Returns impact on revenue

Metrics:

* gross revenue
* returned amount
* net revenue
* return rate %

Purpose:
Evaluate how product returns affect real revenue.

---

### 7. Category performance

Metrics:

* revenue per category
* average order value
* share of total revenue

Purpose:
Identify key product segments.

---

### 8. Customer segmentation

Method:
NTILE(5) based segmentation by revenue.

Segments:

* top customers (top 20%)
* mid customers (middle 60%)
* low customers (bottom 20%)

Purpose:
Understand distribution of customer value.

---

## Excel analysis

Excel was used to:

* validate SQL outputs
* create pivot tables
* simulate business reporting workflow
* prepare data for Power BI

Key operations:

* filtering by year
* SUBTOTAL calculations
* pivot tables for revenue trends
* category performance validation

---

## Power BI dashboard

Visualizations created:

* monthly revenue trend
* revenue by category
* category slicer filter

Purpose:
present insights in a business-friendly format.

---

## Key insights

Example business conclusions:

* revenue trend shows seasonal growth pattern
* a portion of customers generates majority of revenue
* some categories dominate sales performance
* return rate impacts net revenue stability
* repeat customers contribute significantly to revenue stability

---

## Project structure

```
case_study_2/
│
├── SQL_queries.sql
├── orders_dataset.xlsx
├── dashboard.pbix
└── README.md
```

---

## Skills demonstrated

SQL:

* CTE
* window functions
* LAG
* NTILE
* DATE_TRUNC
* aggregation logic
* retention calculations

Excel:

* structured tables
* SUBTOTAL
* pivot tables
* data cleaning

Power BI:

* data import
* slicers
* line chart
* column chart
* basic dashboard layout

---

## Author

Łukasz
Aspiring Data Analyst
