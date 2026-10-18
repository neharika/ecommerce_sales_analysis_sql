
# ER Diagram for the Project
![alt text](mermaid-diagram_refund.png)

# Executive Summary

# Executive Summary

This project analyzes an e-commerce dataset using PostgreSQL to evaluate 
order distribution, 
revenue trends, 
customer purchasing behavior,
product performance, and 
data quality. 
The analysis uses recorded order statuses to distinguish revenue from orders currently marked as delivered from orders that may still be progressing through the order lifecycle. It also examines refund impact and customer purchase frequency to identify opportunities for better business reporting and customer retention.

## Key Findings

- **Order fulfillment:** The dataset contains 40,000 orders, of which 19,979 (49.95%) are currently marked as delivered and 2,178 (5.45%) are cancelled. The remaining 17,843 orders have other recorded statuses and should not automatically be treated as lost sales.

- **Revenue trends:** Revenue from currently delivered orders peaked at ₹66.62 million in April 2026, compared with ₹35.70 million in March and ₹38.05 million in May. The supplementary 14-day analysis recorded a 37.75% revenue decline between the periods beginning March 30 and April 13. June's monthly revenue of ₹10.05 million covers only June 1–14 and is not directly comparable with full months.

- **Customer purchasing behavior:** Of 8,800 customers with at least one recorded order, 4,999 placed exactly one order, representing 56.81% of customers with orders. This indicates an opportunity to investigate repeat-purchase behavior and customer retention.

## Recommendations

Investigate the decline in revenue and order volume after the observed peak, while accounting for incomplete periods and the distinction between order creation dates and actual delivery dates. Analyze repeat-purchase patterns to identify opportunities to encourage customers to return. Strengthen reporting by validating the 134 recorded order-status discrepancies, incorporating valid refunds into revenue analysis, and documenting limitations in return-item relationships and missing customer-country information.