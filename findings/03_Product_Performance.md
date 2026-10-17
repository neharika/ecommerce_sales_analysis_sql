### Business Question

Which products generate the highest gross realized revenue from delivered orders, and how does revenue compare with units sold and order reach?

## SQL Approach
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

## Key Findings
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

## Business Interpretation

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

## Limitations & Next Steps
-Assess refunds on delivered orders and determine the extent to which refunds reduce realized revenue.
-Calculate net realized revenue after refunds at the order/customer/country level where the refund data can be reliably linked.
-Avoid assigning order-level refunds directly to individual products unless a reliable product-level refund relationship is available.
-Analyze the open-order pipeline separately, including non-cancelled, non-delivered orders, to identify products with strong current demand that have not yet contributed to realized revenue.
--Compare product performance with inventory levels to identify potential stock-out or overstock risks.
-Analyze product performance by category and brand to identify broader product-market patterns.
-Verify whether line_total incorporates discounts, promotions, taxes, or other adjustments before interpreting it as revenue.
-Assess profitability separately using product cost data, since revenue does not indicate margin or profit.


## High-Revenue vs. High-Volume Product Analysis

### Business Question
Which products generate the highest revenue, and which products sell the most units? Do the same products lead in both categories?

### SQL Approach
- Calculated gross revenue and total units sold for each product using delivered orders.
- Ranked products separately by gross revenue and sales volume using `DENSE_RANK()`.
- Classified products into three profiles based on whether they ranked in the top 10 for revenue, volume, or both:
  - High Revenue & High Volume
  - High Revenue & Low Volume
  - Low Revenue & High Volume

### Key Findings

**1. High Revenue & Low Volume**

- **Marigold Home Craft Lite Wireless Earbuds** ranked **1st in revenue** with gross revenue of **566,678** from **22 units**, but ranked 31st by sales volume.
- **Mirae Essentials Luxe Smartwatch** ranked 9th in revenue, generating **423,489** from just **11 units**, while ranking 42nd by volume.

These products generate substantial revenue despite relatively low unit sales, suggesting higher revenue per unit may contribute to their revenue rankings.

**2. High Revenue & High Volume**

- **Zyra Bass+ Over-Ear Headphones** ranked 6th in revenue and 8th in volume, generating **446,955** from **45 units sold**.

This product performs strongly on both measures, demonstrating that a product can combine high revenue with high sales volume.

**3. Low Revenue & High Volume**

- **Loom & Ladle Air Over-Ear Headphones** ranked 3rd in volume, selling **52 units**, but ranked 108th in revenue, generating **167,948**.
- **Anvi House Everyday Sunglasses** ranked 1st in volume, selling **57 units**, but ranked 506th in revenue, generating **64,393**.

These products sell many units but contribute comparatively less revenue, making their revenue contribution worth examining alongside sales volume.

### Business Interpretation

Revenue and volume rankings highlight different aspects of product performance. Products with high revenue but lower volume may benefit from their higher revenue per unit, while products with high volume but lower revenue may have lower revenue per unit.

The high-revenue, high-volume profile identifies products that perform well across both measures. These distinctions can help prioritize further investigation into product pricing, sales strategies, and product-level performance.

### Limitations and Next Steps

- **Profitability:** Revenue and sales volume do not establish profitability. Product costs and operating expenses would be needed to assess profit contribution.
- **Pricing analysis:** Compare revenue per unit across product profiles to understand differences in revenue contribution.
- **Inventory analysis:** Compare sales volume with inventory availability to identify potential stock shortages or slow-moving products.
- **Scope:** The classifications use a top-10 rank threshold for revenue and volume and include only delivered orders. They do not represent a complete segmentation of all products into high- and low-performing groups.

