
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


