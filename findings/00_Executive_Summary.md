
# ER Diagram for the Project
![alt text](mermaid-diagram_refund.png)

# Executive Summary

## Project Overview

This project analyzes e-commerce sales data using PostgreSQL to evaluate business performance, revenue trends, customer purchasing behavior, product performance, and data quality. The analysis focuses on revenue from currently delivered orders, customer contribution, refund impact, and the distinction between realized revenue and orders still in the pipeline.

## Key Findings

### 1. Order Fulfillment and Business Scale

The dataset contains **40,000 orders and 10,000 customers**. Of the total orders, 19,979 (49.95%) are currently marked as delivered, while 2,178 (5.45%) are cancelled. The remaining 17,843 orders (44.61%) have other recorded statuses, including paid, placed, packed, and shipped.

**Business implication:** Restricting analysis to delivered orders excludes approximately half of all orders from the revenue analysis. However, non-delivered orders should not automatically be classified as lost sales because some may still be progressing through the order lifecycle.

### 2. Revenue Trends and Performance

Monthly revenue from currently delivered orders peaked in **April 2026 at ₹66.62 million**, compared with ₹35.70 million in March. Revenue subsequently declined to ₹38.05 million in May. June revenue was ₹10.05 million through June 14, making it an incomplete-month observation.

The supplementary 14-day analysis also showed a substantial decline after its peak window: revenue fell from ₹40.17 million in March 30–April 12 to ₹25.01 million in April 13–26, a decrease of 37.75%.

**Business implication:** Revenue and delivered-order volume declined after the observed peak. Further analysis of customer activity, order volume, average order value, and fulfillment timing is needed to investigate the drivers. The observed trend does not establish its cause.

### 3. Customer Contribution and Refund Impact

Customer purchase-frequency analysis found that **56.8% of customers were one-time purchasers**. Separately, the refund analysis identified 260 refunded orders and total recorded refunds of ₹1,197,635.33.

The top customer by net realized revenue was Shreya Menon, with ₹665,147.72 after recorded refunds.

**Business implication:** The high share of one-time purchasers indicates an opportunity to investigate repeat-purchase behavior and customer retention. Refunds should also be incorporated into revenue reporting to distinguish gross realized revenue from net realized revenue.

## Recommendations

1. **Investigate revenue declines:** Examine changes in order volume and average order value, while accounting for partial months and current order-status limitations.
2. **Improve customer retention:** Investigate why customers do not make repeat purchases and identify opportunities to encourage subsequent orders.
3. **Strengthen revenue and data-quality reporting:** Track refunds alongside gross realized revenue, validate status-history discrepancies, and document limitations in return-item relationships and customer-country data.

## Analytical Scope and Limitations

- Revenue analysis uses `order_items.line_total` for orders currently marked as delivered.
- Monthly and 14-day revenue trends are grouped by order creation date (`created_at`), not actual delivery date.
- March and June contain partial-month data in the monthly analysis; the final 14-day window is also incomplete.
- The comparison of `orders.status` with the latest available status-history record identified 134 discrepancies. The comparison does not establish which status value is correct.
- Product-level net revenue and returned-unit analysis remain limited by unresolved item-level return relationships.

## Tools and Techniques

**PostgreSQL:** Common table expressions (CTEs), aggregations, conditional logic, date functions, window functions (`LAG`, `DENSE_RANK`), joins, and data-quality checks.