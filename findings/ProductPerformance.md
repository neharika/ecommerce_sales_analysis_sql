# Product Performance Analysis

## Business Question

Which products generate the highest revenue from delivered orders, and how does revenue compare with units sold?

## SQL Approach

* Joined `orders`, `order_items`, `product_variants`, and `products`.
* Used `order_items.line_total` to calculate product-level revenue instead of `orders.total`, which could duplicate order revenue across multiple items.
* Standardized order status using `LOWER(TRIM(status))`.
* Filtered the analysis to orders with the status `delivered`.
* Calculated:

  * Total revenue
  * Total quantity sold
  * Average revenue per unit

## Key Findings

### 1. Highest-Revenue Products

The highest-revenue delivered products included wireless earbuds, headphones, and smartwatches.

The top product was **Marigold Home Craft Lite Wireless Earbuds**, with:

* Delivered revenue: 566,678
* Units sold: 22
* Average revenue per unit: 25,758.09

Other high-revenue products included Everbloom Collective Air Over-Ear Headphones, Kosha Co. Active Kids Smartwatch, and Vastra Craft Pulse Kids Smartwatch.

### 2. Revenue and Quantity Show Different Patterns

Products with high revenue do not necessarily have the highest unit sales.

For example:

* Mirae Essentials Luxe Smartwatch generated 423,489 from 11 units.
* Zyra Bass+ Over-Ear Headphones generated 446,955 from 45 units.

This shows that both product revenue and quantity sold should be analyzed together to understand product performance.

### 3. Average Revenue per Unit

Average revenue per unit varies considerably across products.

Mirae Essentials Luxe Smartwatch had an average revenue per unit of 38,499, while several other products generated lower revenue per unit but sold more units.

This metric can help identify products with relatively high or low realized revenue per unit. It should not automatically be interpreted as profit or margin because product costs, discounts, and refunds have not yet been analyzed.

## Business Interpretation

The results suggest that audio products and smartwatches are represented among the higher-revenue delivered products in this dataset.

Products with higher average revenue per unit may contribute substantial revenue even with lower unit volumes. Products with higher unit sales may be important for volume-driven sales strategies.

These are descriptive findings. Additional analysis is required to determine profitability, customer demand drivers, and inventory priorities.

## Limitations and Next Steps

* Check whether delivered orders have refunds.
* Calculate net revenue after refunds, if the required data is available.
* Analyze product-level refund rates.
* Compare product revenue with inventory levels.
* Analyze product performance by category and brand.
* Confirm whether `line_total` includes discounts and other adjustments.
