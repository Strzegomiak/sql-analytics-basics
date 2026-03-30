README — Case Study 1
Project overview

This project presents an end-to-end sales analysis workflow using:

SQL (PostgreSQL)
Excel
Power BI

The goal of the project was to simulate a typical business task performed by a junior data analyst:
analyze sales performance and identify key trends and insights.

The dataset contains transactional sales data for 2025, including information about customers, products, cities, and categories.

Business questions

The analysis answers the following questions:

How does revenue change over time?
Which product categories generate the most revenue?
Which products contribute the most to total sales?
Which cities generate the highest revenue?
Is revenue concentrated among a small number of products?
Dataset

Table: transactions

Columns:

transaction_id
customer_id
customer_name
city
product
category
amount
transaction_date

Data includes:

multiple cities
returning customers
two product categories
six months of sales
realistic revenue values
SQL analysis

SQL was used to prepare analytical datasets.

Key calculations included:

monthly revenue aggregation
month-over-month revenue change
customer revenue ranking
product performance metrics
revenue share by product

Example metrics:

total revenue
number of transactions
average order value
unique customers
revenue share percentage
ranking using window functions

SQL techniques used:

GROUP BY aggregation
window functions (LAG, DENSE_RANK)
DATE_TRUNC
Common Table Expressions (CTE)
NULLIF for safe division
Excel analysis

Excel was used for quick data validation and pivot table analysis.

Steps included:

checking for missing or incorrect values
creating pivot tables for revenue analysis
grouping revenue by category and product
creating a month column from transaction_date

Pivot tables helped confirm SQL results and prepare data structure for visualization.

Power BI dashboard

A dashboard was created to visualize key sales metrics.

Visualizations:

Revenue over time (line chart)
Revenue by category (column chart)
Revenue by city (column chart)
Top products by revenue (bar chart)
Category slicer for filtering

The dashboard allows quick identification of trends and top-performing segments.

Key insights
Revenue decreases in June, mainly due to a drop in Electronics sales.
Electronics generate approximately three times more revenue than Furniture.
Furniture shows relatively stable revenue over time.
Krakow and Warsaw generate the highest revenue, while Poznan contributes the least.
Laptop is the top-performing product and generates significantly higher revenue than other products.
Tools used
PostgreSQL
Excel
Power BI

Skills demonstrated
analytical thinking
SQL data transformation
working with transactional data
data validation in Excel
building dashboards in Power BI
translating data into business insights
