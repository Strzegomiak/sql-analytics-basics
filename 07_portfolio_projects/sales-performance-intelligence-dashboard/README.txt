 # Sales Performance Intelligence Dashboard

## Project Overview

This project analyzes e-commerce sales performance using SQL and Power BI.

The goal of the analysis was to identify:
- revenue trends,
- customer behavior,
- product performance,
- return patterns,
- customer segmentation,
- and key business insights.

The project was built using a real-world retail dataset and focuses on business-oriented analytical thinking rather than only dashboard creation.

---

## Tools Used

- PostgreSQL
- SQL
- Power BI
- Excel

---

## Business Questions

The analysis aimed to answer the following questions:

1. Which products generate the highest revenue?
2. Which products have the highest return rates?
3. How concentrated is customer revenue?
4. Which countries generate the most revenue?
5. What sales seasonality patterns can be observed?
6. When are customers most active during the week and during the day?
7. How significant are cancellations and returns?

---

## Key Insights

### Revenue & Seasonality
- Strong revenue growth was observed during Q4 periods.
- Significant revenue drops appeared after holiday seasons.
- December 2011 data appears incomplete.

### Customer Analysis
- Revenue is highly concentrated among high-value customers.
- A relatively small group of customers generates the majority of revenue.
- Customer segmentation revealed strong Pareto-like distribution patterns.

### Product Analysis
- Several best-selling products also showed high return rates.
- High return rates may indicate product quality issues, shipping problems, or mismatched customer expectations.
- Returns and cancellations significantly impact net revenue.

### Behavioral Analysis
- Thursday generated the highest revenue.
- Customer activity peaked around midday business hours.
- Saturday showed extremely low sales activity.

---

## Dashboard Pages

### Executive Overview
High-level KPI summary of revenue, orders, customers, and cancellations.

### Revenue Analysis
Analysis of:
- monthly revenue trends,
- country-level performance,
- hourly and weekday customer activity.

### Product Analysis
Analysis of:
- top-selling products,
- returned products,
- return rate performance.

### Customer Analysis
Analysis of:
- customer segmentation,
- revenue concentration,
- top customers.

---

## SQL Analysis Highlights

The SQL analysis included:
- CTEs,
- window functions,
- NTILE segmentation,
- revenue calculations,
- cumulative metrics,
- return analysis,
- customer analytics.

---

## Project Structure

```text
sales-performance-intelligence-dashboard/
│
├── data/
├── sql/
├── dashboard/
├── README.md
└── sales_performance_dashboard.pbix
```

---
## Dashboard Preview


### Executive Overview

![Executive Overview](img/executive_overview.png)

---

### Revenue Analysis

![Revenue Analysis](img/revenue_analysis.png)

---

### Product Analysis

![Product Analysis](img/product_analysis.png)

---

### Customer Analysis

![Customer Analysis](img/customer_analysis.png)

## Dataset

Dataset source:
https://archive.ics.uci.edu/ml/datasets/online+retail

## Author

Łukasz Strzegomiak