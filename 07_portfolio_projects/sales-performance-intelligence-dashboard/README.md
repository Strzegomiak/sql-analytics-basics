# Sales Performance Intelligence Dashboard

## Project Overview

This project presents a business-focused analysis of e-commerce sales performance using SQL and Power BI.

The analysis was designed as an end-to-end portfolio case study simulating a real-world business intelligence workflow — from raw transactional data exploration and KPI analysis to dashboard development and business insight generation.

The primary objective of the project was to identify:

* key revenue drivers,
* customer purchasing behavior,
* product performance trends,
* return and cancellation patterns,
* operational inefficiencies,
* and opportunities for business optimization.

The project emphasizes analytical thinking, KPI interpretation, and business storytelling rather than dashboard creation alone.

---

## Business Problem

Retail and e-commerce businesses generate large volumes of transactional data, but raw sales data alone does not provide actionable business insights.

This project focuses on transforming transactional retail data into business intelligence that can support:

* revenue optimization,
* customer retention strategies,
* inventory and operational planning,
* and product performance evaluation.

The analysis investigates:

* which products and customers drive the majority of revenue,
* how strongly revenue depends on a small customer segment,
* which products generate the highest return impact,
* and how customer activity changes across time periods.

---

## Tools & Technologies

* PostgreSQL
* SQL
* Power BI
* Excel

---

## Analytical Scope

The project covers several key business analytics areas:

### Revenue Analysis

* monthly revenue trends,
* gross vs net revenue,
* seasonal sales patterns,
* revenue concentration analysis.

### Customer Analytics

* customer segmentation,
* high-value customer analysis,
* Pareto-like revenue distribution,
* customer concentration risk analysis.

### Product Performance

* top-performing products,
* return analysis,
* return rate evaluation,
* operational product issues.

### Behavioral Analytics

* weekday purchasing patterns,
* hourly customer activity,
* transaction timing analysis.

---

## Business Questions

The analysis aimed to answer the following business questions:

1. Which products generate the highest revenue?
2. Which products create the largest return impact?
3. How concentrated is revenue among top customers?
4. Which countries generate the highest commercial value?
5. What seasonal patterns affect sales performance?
6. When are customers most active?
7. How strongly do cancellations and returns impact profitability?
8. Which operational or product-related areas may require optimization?

---

## Key Business Insights

### Revenue & Seasonality

* Revenue showed strong Q4 seasonality, indicating significant dependence on holiday sales periods.
* Post-holiday periods generated noticeable revenue slowdowns, particularly during January.
* Revenue patterns suggest the importance of inventory planning and operational preparation before peak periods.
* December 2011 data appears incomplete, highlighting the importance of validating dataset completeness during analytical workflows.

---

### Customer Analysis

* Revenue is highly concentrated among high-value customers.
* A relatively small customer group generates the majority of total revenue, creating potential dependency risk.
* Customer segmentation revealed strong Pareto-like distribution behavior.
* The business may benefit from retention-focused strategies targeting high-value customer groups.

---

### Product & Return Analysis

* Several top-selling products also generated elevated return volumes.
* High return rates may indicate:

  * product quality issues,
  * customer expectation mismatches,
  * packaging or shipping problems,
  * or product description inaccuracies.
* Returns and cancellations significantly reduce net revenue and directly affect overall business performance.
* Operational stock codes such as POST, DISCOUNT, and MANUAL required additional filtering and cleaning during the analytical process.

---

### Behavioral Insights

* Thursday generated the highest revenue levels, suggesting strong mid-week purchasing behavior.
* Customer activity peaked around midday business hours.
* Saturday sales activity remained extremely low, potentially indicating B2B-oriented customer behavior or operational limitations.

---

## Dashboard Structure

### Executive Overview

High-level KPI dashboard focused on:

* revenue,
* net revenue,
* customers,
* orders,
* and cancellation rates.

### Revenue Analysis

Analysis of:

* revenue trends,
* seasonal performance,
* country-level sales,
* weekday and hourly activity patterns.

### Product Analysis

Analysis of:

* top-selling products,
* return-heavy products,
* return rate performance,
* product-related operational insights.

### Customer Analysis

Analysis of:

* customer segmentation,
* revenue concentration,
* top customer performance,
* customer value distribution.

---

## SQL Analysis Highlights

The SQL workflow included:

* Common Table Expressions (CTEs),
* window functions,
* NTILE-based segmentation,
* cumulative calculations,
* revenue and KPI calculations,
* return analysis,
* customer analytics,
* business-oriented aggregations.

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

---

## Project Structure

```text
sales-performance-intelligence-dashboard/
│
├── img/
├── sql/
├── README.md
└── sales_performance_dashboard.pbix
```

---

## Dataset

Dataset source:
https://archive.ics.uci.edu/ml/datasets/online+retail

---

## Portfolio Positioning

This project was designed as a portfolio-ready business analytics case study for Junior Data Analyst recruitment.

The focus was placed on:

* analytical thinking,
* business communication,
* KPI interpretation,
* SQL analytics,
* and executive-style dashboard storytelling.

---

## Author

Łukasz Strzegomiak
