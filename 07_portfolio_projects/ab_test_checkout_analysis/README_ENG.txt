# Checkout A/B Test Analysis

## Project Overview

This project presents a complete A/B test analysis for a hypothetical ecommerce checkout redesign.

The goal of the experiment was to evaluate whether a new checkout flow ("treatment") improves business performance compared to the current checkout experience ("control").

The project was built as an end-to-end Product Analytics / Data Analytics case study using:

- PostgreSQL
- SQL
- Power BI

The analysis focuses on:
- conversion uplift,
- revenue impact,
- experiment validation,
- segment performance,
- guardrail metrics,
- rollout recommendation.

---

# Business Problem

The company introduced a redesigned checkout flow intended to:

- reduce checkout friction,
- improve conversion rate,
- increase revenue,
- improve user experience.

An A/B experiment was conducted where users were randomly assigned to:

- `control` → existing checkout,
- `treatment` → new checkout experience.

The objective was to determine whether the treatment version should be rolled out to all users.

---

# Project Structure

```text
ab-test-analysis/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── img/
│   ├── dashboard_overview.png
│   └── dashboard_kpis.png
│
├── power_bi/
│   └── checkout_experiment_dashboard.pbix
│
├── sql/
│   ├── 01_data_validation.sql
│   ├── 02_conversion_analysis.sql
│   ├── 03_guardrail_metrics.sql
│   ├── 04_business_impact.sql
│   └── 05_final_recommendation.sql
│
└── README.md
```

---

# SQL Analysis Workflow

## 1. Experiment Validation

Validation checks included:

- traffic split analysis,
- duplicate user validation,
- device distribution checks,
- new vs returning user balance,
- revenue consistency validation.

---

## 2. Conversion Analysis

Core KPIs analyzed:

- conversion rate,
- total revenue,
- average revenue per user,
- average order value,
- conversion uplift.

Segment analysis included:

- uplift by device,
- uplift by user type.

---

## 3. Guardrail Metrics

The following guardrail metrics were evaluated:

- cart abandonment rate,
- average page load time,
- error rate,
- bounce rate.

The purpose was to ensure that conversion improvements did not negatively impact user experience or technical stability.

---

## 4. Business Impact Analysis

The project estimated:

- revenue uplift,
- additional revenue per 100k users,
- overall business impact of the treatment rollout.

---

# Key Findings

## Conversion Performance

- Treatment achieved a higher conversion rate than control.
- Positive conversion uplift was observed across major user segments.

## Revenue Impact

- Treatment generated higher revenue per user.
- Estimated additional revenue per 100k users was positive.

## Guardrail Metrics

Treatment also improved:
- cart abandonment,
- page load time,
- error rate,
- bounce rate.

No negative side effects were detected.

---

# Final Recommendation

Based on the experiment results:

- Treatment improves conversion performance  
- Revenue impact is positive 
- Guardrail metrics remain healthy  
- Segment performance is stable  

**Recommendation: Ship Treatment**

---

# Dashboard Preview

## Full Dashboard

![Dashboard Overview](img/dashboard_overview.png)

## KPI Section

![Dashboard KPIs](img/dashboard_kpis.png)

---

# Tools Used

- PostgreSQL
- SQL
- Power BI
- GitHub

---

# Author

Łukasz Strzegomiak