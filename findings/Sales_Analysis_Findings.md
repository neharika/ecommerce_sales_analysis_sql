# Product Performance Analysis

![alt text](mermaid-diagram_refund.png)




## Revenue Trends: Fixed 14-Day Periods

### Business Question

How did revenue and delivered-order volume change across consecutive 14-day periods?

### Methodology

Used PostgreSQL's DATE_BIN() to group orders into fixed 14-day intervals, anchored at March 16, 2026.

Filtered orders by their current status of delivered.

Aggregated order count and revenue for each interval.

Used LAG() to compare each period's revenue with the preceding period and calculate percentage growth.
### Key Findings

|14-Day Period|Delivered Orders|Revenue|Revenue Growth|
| Mar 16–30, 2026 | 4,263 | 31,695,163.60 | — |
| Mar 30–Apr 13, 2026 | 5,256 | 40,170,749.36 | +26.74% |
| Apr 13–27, 2026 | 3,271 | 25,007,725.06 | -37.75% |
| Apr 27–May 11, 2026 | 2,502 | 19,125,123.80 | -23.52% |
| May 11–25, 2026 | 2,176 | 16,226,430.64 | -15.16% |
| May 25–Jun 8, 2026 | 1,916 | 13,649,299.90 | -15.88% |
| Jun 8–22, 2026 | 595 | 4,543,745.30 | -66.71% |

*Period end timestamps are exclusive boundaries. For example, the period beginning March 16 ends at March 30 at 00:00 UTC.*





### Top 10 Customers by Net Realized Revenue

### Business Question  
Q: Which customers generate the highest net realized revenue after accounting for refunds?

### Key Findings  
Shreya Menon is the highest-value customer, generating $665,147.72 in net realized revenue from $673,757.00 gross realized revenue, with $8,609.28 in refunds. The remaining top customers generated between approximately $506K and $590K in net realized revenue.

One particularly useful observation is that 6 of the top 10 customers had no refunds, while the highest-ranked customer had the largest absolute refund amount. That doesn't necessarily mean Shreya is a problematic customer—the refund rate is only about 1.28%—but it is worth monitoring.


## Country-Wise Revenue and Refund Analysis

### Business Question
How is net realized revenue distributed across countries, and how do refunds compare with gross revenue in each geographic market?

### Methodology
- Joined customer, order, order-item, and refund data to calculate country-level revenue and refunds.
- Included orders currently marked as `delivered`.
- Standardized missing or unavailable country values, including `NULL`, blank strings, `N/A`, and `Not Available`, into a single `Not Available` category.
- Calculated gross revenue, total refunds, net realized revenue, and the revenue refund rate.

### Key Findings

| Country | Gross Revenue | Total Refunds | Net Realized Revenue | Revenue Refund Rate |
|---|---:|---:|---:|---:|
| India | 95,486,619.00 | 891,287.70 | 94,595,331.30 | 0.93% |
| United States | 17,654,096.00 | 132,023.64 | 17,522,072.36 | 0.75% |
| Not Available | 14,268,964.00 | 127,943.43 | 14,141,020.57 | 0.90% |

### Key Insights

- **India is the dominant revenue market:** India generated 94.60 million in net realized revenue, substantially exceeding the United States at 17.52 million.
- **Unavailable country data represents material revenue:** The `Not Available` group contributed 14.14 million in net realized revenue. Excluding these records would understate reported revenue and obscure a meaningful portion of the business.
- **Refund rates are relatively low across the reported groups:** Refunds represented 0.93% of gross revenue in India, 0.75% in the United States, and 0.90% for the unavailable-country group.
- **India has the highest observed refund rate:** Its rate is 0.18 percentage points above the United States. This difference is descriptive and does not establish why refund rates differ.

### Business Interpretation
India is the largest revenue market in the observed dataset. The unavailable-country group is also commercially significant, highlighting a data-quality issue worth addressing. Improving country-data completeness would enable more reliable geographic segmentation and more informed market-level decisions.

The observed refund rates can help prioritize further investigation, but they should not be interpreted as evidence of differences in customer satisfaction or product quality without additional analysis.

### Limitations
- The analysis includes orders currently marked as `delivered` and groups them by customer country.
- The `Not Available` category combines records with missing or placeholder country values; these records cannot be attributed to a specific geographic market without further data cleaning or enrichment.
- Refunds include records whose status is not `failed`. If this includes initiated but incomplete refunds, the reported refund totals may exceed completed refunds.
- Revenue refund rate is calculated as total refunds divided by gross revenue; it is not the percentage of orders that were refunded.

## Overall Realized Revenue After Refunds

### Business Question

How much revenue was generated from delivered orders, and how much remained after accounting for refunds?

### SQL Approach

- Filtered orders to `delivered` status using `LOWER(TRIM(status))`.
- Calculated gross realized revenue using `SUM(order_items.line_total)`.
- Aggregated refund amounts from the `refunds` table, excluding records with a `failed` status.
- Calculated net realized revenue by subtracting refunds from gross realized revenue.
- Calculated the revenue refund rate as total refunds divided by gross realized revenue, multiplied by 100.

### Key Findings

The analysis returned the following results:

| Metric                 |          Value |
| ---------------------- | -------------: |
| Gross realized revenue | 127,409,679.00 |
| Total refunds          |   1,151,254.77 |
| Net realized revenue   | 126,258,424.23 |
| Revenue refund rate    |          0.90% |

### Business Interpretation

The initial results show gross realized revenue of 127.41 million and net realized revenue of 126.26 million after subtracting the reported refunds. The reported revenue refund rate is 0.90%, indicating that refunds account for a relatively small share of gross realized revenue.

This metric provides a view of revenue retained after refunds and complements product and customer performance analyses. It can also serve as a baseline for investigating refund patterns across countries, customers and products.

### Limitations and Next Steps

- Treat net realized revenue as a revenue measure, not profit, because product costs and other operating expenses have not been deducted.
- Analyze refund patterns by customer and country to identify where refunds have the greatest financial impact.

## Product Analysis: Revenue in the Order Pipeline

### Business Question
Which products account for the highest value of orders that have not yet reached a delivered or cancelled status?

### Methodology
- Joined `orders`, `order_items`, `product_variants`, and `products` to calculate product-level pipeline metrics.
- Excluded orders currently marked `delivered` or `cancelled`, retaining the remaining order statuses.
- Aggregated order-item revenue, units sold, and distinct order counts by product.
- Ranked products by pipeline revenue to identify the ten products with the highest value in the current order pipeline.

### Key Findings

- **Eastlight Clarity ANC Headphones ranked first**, with pipeline revenue of 494,171 across 29 units and 24 orders.
- **Smartwatches and headphones featured prominently** among the top ten products, suggesting that both product types account for substantial value in the orders currently being processed.
- **Marigold Home Craft Lite Wireless Earbuds** contributed 323,586 in pipeline revenue from 14 units across 12 orders. Its relatively high revenue alongside lower unit volume illustrates why revenue rankings and volume rankings can differ.
- **Pipeline value was distributed across multiple products:** the tenth-ranked product, TickTone Essentials Vital Smartwatch, accounted for 296,982 across 18 units and 14 orders.

### Business Interpretation
The products with the highest pipeline revenue represent areas where order fulfillment may have a meaningful impact on future delivered sales. Monitoring these products can help prioritize fulfillment reviews and identify where delays could affect the conversion of pending orders into completed sales.

However, pipeline revenue is not realized revenue. These orders may still be in different stages of processing, and some may eventually be cancelled or otherwise fail to reach delivery. The analysis identifies current pipeline exposure, not guaranteed future revenue.

### Limitations
- Pipeline revenue is based on orders' current statuses at the time of analysis. It is a snapshot and does not show how long orders have remained in the pipeline.
- The analysis excludes currently delivered and cancelled orders, but combines the remaining statuses rather than comparing them separately.
- The query does not establish whether the orders will eventually be delivered. Historical order-status data would be needed to study transitions from pipeline statuses to delivered or cancelled outcomes.
- Pipeline revenue should be reported separately from delivered revenue to avoid presenting pending order value as realized sales.
