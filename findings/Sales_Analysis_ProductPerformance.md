# Product Performance Analysis

![ER Diagram reference](mermaid-diagram.png)

##Business Question

Which products generate the highest gross realized revenue from delivered orders, and how does revenue compare with units sold and order reach?

##SQL Approach
Joined orders, order_items, product_variants, and products.
Used order_items.line_total to calculate product-level sales value instead of orders.total, which could duplicate order-level revenue across multiple items.
Standardized order status using LOWER(TRIM(status)).
Restricted the analysis to delivered orders so that revenue represents completed sales.
Calculated:
Gross realized revenue
Units sold
Number of distinct orders
Average revenue per unit

Gross realized revenue represents sales from delivered orders before refunds. It is not equivalent to net revenue or profit.

##Key Findings
1. Marigold Home Craft Lite Wireless Earbuds generated the highest realized revenue

Marigold Home Craft Lite Wireless Earbuds ranked #1 with:

566,678 gross realized revenue
22 units sold
18 orders
25,758.09 average revenue per unit

It generated the highest revenue despite relatively low unit volume, indicating that its revenue contribution is driven more by higher value per unit than by high sales volume.

2. Zyra Bass+ Over-Ear Headphones is the strongest volume-driven product

Zyra Bass+ Over-Ear Headphones sold the most units among the top 10:

45 units
33 orders
446,955 gross realized revenue
9,932.33 average revenue per unit

This contrasts with Marigold: Zyra achieves substantial revenue through higher unit and order volume, rather than a high revenue per unit.

This is an important distinction:

Revenue leadership and volume leadership are not the same thing.

3. Mirae Essentials Luxe Smartwatch has the highest revenue per unit

Mirae Essentials Luxe Smartwatch generated:

423,489 revenue
from only 11 units
across 8 orders
at 38,499 revenue per unit

It has the highest average revenue per unit among the top 10 products, yet ranks only #9 by total revenue.

This suggests a high-value, low-volume product profile.

##Business Interpretation

The top products show that product performance is driven by different combinations of price/value, unit volume, and order reach.

High-value products can generate substantial revenue without selling large quantities.
High-volume products can generate strong revenue through greater unit and order volume.
Therefore, ranking products by revenue alone does not fully explain their commercial performance.

This distinction can support different business decisions around pricing, promotions, merchandising, and inventory planning.

However, this analysis does not establish profitability, because product costs, discounts, and refunds have not been incorporated.

4. Product reach also differs substantially

The number of distinct orders provides another perspective.

For example:

Product	Revenue	Units	Orders	Revenue / Unit
Marigold Earbuds	566,678	22	18	25,758
Zyra Headphones	  446,955	45	33	9,932
Mirae Smartwatch	423,489	11	8	38,499

So these products represent three different performance models:

Marigold: high revenue + high value per unit
Zyra: high volume + broad order reach
Mirae: very high value per unit + low volume

##Limitations and Next Steps
Assess refunds on delivered orders and determine the extent to which refunds reduce realized revenue.
Calculate net realized revenue after refunds at the order/customer/country level where the refund data can be reliably linked.
Avoid assigning order-level refunds directly to individual products unless a reliable product-level refund relationship is available.
Analyze the open-order pipeline separately, including non-cancelled, non-delivered orders, to identify products with strong current demand that have not yet contributed to realized revenue.
Compare product performance with inventory levels to identify potential stock-out or overstock risks.
Analyze product performance by category and brand to identify broader product-market patterns.
Verify whether line_total incorporates discounts, promotions, taxes, or other adjustments before interpreting it as revenue.
Assess profitability separately using product cost data, since revenue does not indicate margin or profit.


Top 10 Customers by Net Realized Revenue
Business question:  
Which customers generate the highest net realized revenue after accounting for refunds?

Key finding:  
Shreya Menon is the highest-value customer, generating $665,147.72 in net realized revenue from $673,757.00 gross realized revenue, with $8,609.28 in refunds. The remaining top customers generated between approximately $506K and $590K in net realized revenue.

One particularly useful observation is that 6 of the top 10 customers had no refunds, while the highest-ranked customer had the largest absolute refund amount. That doesn't necessarily mean Shreya is a problematic customer—the refund rate is only about 1.28%—but it is worth monitoring.