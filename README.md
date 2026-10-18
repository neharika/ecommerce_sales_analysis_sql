# E-commerce Sales Analysis | SQL

**Author:** Neharika Mandhan  
**Project Type:** Data Analytics  
**Tools:** PostgreSQL · SQL · Git · GitHub

## Project Overview

How much of the recorded order activity translates into delivered sales, which customers return to purchase again, and how do revenue trends change over time?

This project uses PostgreSQL to explore these questions in an e-commerce dataset containing 40,000 orders and 10,000 customers. I analyzed order statuses, monthly revenue, customer purchasing frequency, product performance, refunds, and data quality to understand what the data reveals—and where its limitations matter.

## Key Findings

- **Order fulfillment:** 19,979 orders (49.95%) are currently marked as delivered, while 2,178 (5.45%) are cancelled. The remaining orders have other recorded statuses and should not automatically be classified as lost sales.
- **Revenue trends:** Monthly revenue from currently delivered orders peaked at ₹66.62 million in April 2026, then declined to ₹38.05 million in May. The June figure of ₹10.05 million covers only June 1–14.
- **Customer retention:** Of 8,800 customers with at least one recorded order, 4,999 placed exactly one order—56.81% of customers who had ordered.
- **Data quality:** Comparing current order statuses with the latest available status-history records identified 134 discrepancies requiring further investigation.

## Business Questions

The analysis explores five areas:

1. **Revenue performance:** How did monthly revenue change, and what happened to revenue across consecutive 14-day periods?
2. **Product performance:** Which products generate the most revenue, and do the highest-revenue products also sell the most units?
3. **Customer behavior:** How concentrated is purchasing activity, and what proportion of customers place repeat orders?
4. **Geographic performance:** How is revenue distributed across customer countries, including records with missing or uninformative country values?
5. **Refunds and data quality:** How do recorded refunds affect realized revenue, and which data inconsistencies could affect reporting?

## Tools and SQL Techniques

- **PostgreSQL:** Querying, aggregation, and data validation.
- **SQL:** Joins, CTEs, `CASE`, `DATE_TRUNC()`, `LAG()`, `DENSE_RANK()`, and window functions.
- **Business analysis:** Revenue and AOV calculations, customer purchase-frequency analysis, product ranking, refund analysis, and order-status evaluation.
- **Git and GitHub:** Version control, repository organization, and documentation.

## Repository Structure

```text
ecommerce_sales_analysis_sql/
├── sql/
│   ├── 01_exploration.sql
│   ├── 02_revenue.sql
│   ├── 03_customers.sql
│   └── ...
├── findings/
│   ├── 00_executive_summary.md
│   ├── 01_business_overview.md
│   ├── 02_business_health.md
│   ├── 03_customer_segments.md
│   └── ...
├── .gitignore
└── README.md
```

The `sql/` directory contains the queries used for the analysis. The `findings/` directory documents the business questions, key results, interpretations, and limitations.

## What I'd Analyze Next

The current analysis identifies several areas worth investigating further:

- **Understand the revenue decline:** Break down changes in order volume and average order value, and investigate whether the observed pattern is related to customer activity, fulfillment timing, or incomplete data coverage.
- **Investigate repeat purchasing:** Examine the time between a customer's first and second orders, compare spending across purchase-frequency groups, and identify potential opportunities to improve retention.
- **Evaluate product performance after refunds:** Validate item-level return relationships before estimating product-level net revenue or returned-unit rates.
- **Investigate order-status discrepancies:** Determine why 134 orders have different statuses in the orders table and the latest available status-history record.
- **Improve geographic reporting:** Assess the impact of missing or inconsistent country values while preserving the revenue associated with those records.

These are proposed follow-up analyses, not conclusions established by the current work.

## Analytical Limitations

- Revenue is calculated using `order_items.line_total` for orders currently marked as delivered.
- Monthly and 14-day trends are grouped by order creation date, not actual delivery date.
- March and June are partial months in the monthly analysis; the final 14-day window is also incomplete.
- The status-history comparison identifies discrepancies but does not establish which status is correct.
- Refund calculations depend on the available refund records. Product-level net revenue remains limited until item-level return relationships are validated.
- Country-level findings depend on the quality and completeness of customer-country information.

## Author

**Neharika Mandhan**  
Aspiring Data Analyst | SQL · PostgreSQL · Business Analytics
