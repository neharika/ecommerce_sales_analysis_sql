# E-commerce Sales Analysis | SQL

**Author:** Neharika Mandhan  
**Project Type:** Data Analytics | Business Intelligence  
**Tools:** PostgreSQL | SQL | Git | GitHub

## Project Overview

This project analyzes e-commerce sales data using PostgreSQL to uncover insights into revenue performance, customer behavior, product performance, and order fulfillment.

The objective is to transform raw transactional data into actionable business insights by writing SQL queries, evaluating business performance metrics, and investigating data quality issues that may affect reporting accuracy.

## Business Objectives

- Analyze revenue and sales performance across products and customers.
- Identify top-performing products based on revenue and units sold.
- Understand customer distribution across countries.
- Evaluate order statuses and distinguish completed sales from orders still in progress.
- Examine refunds and their impact on realized revenue.
- Investigate inconsistencies in transactional data and document analytical limitations.

## Tools & Skills

- **SQL:** Joins, Common Table Expressions (CTEs), aggregate functions, conditional logic, window functions, and date-based analysis.
- **PostgreSQL:** Data querying, aggregation, and analytical calculations.
- **Data Analysis:** KPI calculation, customer segmentation, product ranking, revenue analysis, and data quality assessment.
- **Git & GitHub:** Version control and project documentation.

## Repository Structure

```text
ecommerce_sales_analysis_sql/
├── sql/
│   ├── 05_customer.sql
│   └── ...
├── findings/
│   ├── customers.md
│   └── ...
├── .gitignore
└── README.md
```

The `sql/` directory contains analytical queries, while `findings/` documents the business questions, results, interpretations, and limitations associated with the analysis.

## Key Findings

The analysis examines several areas of e-commerce performance:

- **Customer Demographics:** India accounts for 76.41% of customers, the United States accounts for 13.59%, and 10% have missing or uninformative country information.
- **Product Performance:** Products are evaluated by revenue, units sold, and order count to distinguish high-revenue products from high-volume products.
- **Order Fulfillment:** Order statuses are examined to understand the distribution of delivered orders and orders still in progress.
- **Refund Analysis:** Refund records are investigated to assess their effect on realized revenue.
- **Data Quality:** Differences between order-level totals and item-level amounts are examined to identify potential reporting inconsistencies.

*Detailed results and supporting SQL queries are documented in the `findings/` and `sql/` directories.*

## Analytical Approach

1. Define business questions and relevant performance metrics.
2. Query and combine data from related tables.
3. Calculate revenue, customer, product, and order metrics.
4. Investigate data quality issues and validate assumptions.
5. Document findings, limitations, and recommended next steps.

## Project Status

This project is being developed iteratively. Findings are documented alongside the SQL queries used to generate them, with a focus on transparent calculations, data validation, and business relevance.

## Author

**Neharika Mandhan**

Aspiring Data Analyst | SQL | PostgreSQL | Business Analytics
