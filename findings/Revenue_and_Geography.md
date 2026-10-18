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

