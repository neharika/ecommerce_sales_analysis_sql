## Monthly Revenue Trends and Month-over-Month Growth

### Business Question
How did monthly revenue from currently delivered orders change over time, and was the change associated with order volume or average order value?

### Methodology
- Grouped orders by creation month using `DATE_TRUNC()`.
- Filtered for orders whose current status is `delivered`.
- Calculated monthly revenue, order count, and average order value (AOV).
- Used `LAG()` to retrieve the previous month's revenue and calculate month-over-month (MoM) revenue growth.
- Revenue definition: Revenue is calculated as the sum of order_items.line_total for orders currently marked as delivered. Discounts are zero across the dataset, and shipping fees are negligible; therefore, these fields are not added separately to the reported revenue. AOV is calculated as revenue divided by the number of distinct delivered orders.

### Key Findings

| Month | Delivered Orders | Revenue | MoM Revenue Growth | Average Order Value |
|---|---:|---:|---:|---:|
| March 2026* | 4,762 | 35,704,481.44 | — | 7,497.79 |
| April 2026  | 8,718 | 66,617,965.02 | +86.58% | 7,641.43 |
| May 2026    | 5,104 | 38,047,632.66 | -42.89% | 7,454.47 |
| June 2026*  | 1,395 | 10,048,158.54 | -73.59% | 7,202.98 |

*March covers March 16–31; June covers June 1–14.*

- **April recorded the highest revenue:** Revenue increased by 86.58% from March to April, reaching 66.62 million. Delivered-order volume rose from 4,762 to 8,718, while AOV increased modestly from 7,497.79 to 7,641.43.
- **Revenue declined sharply in May:** Revenue fell by 42.89% to 38.05 million, while delivered-order volume decreased by approximately 41.5%. AOV declined by only about 2.4%, indicating that lower order volume was more closely associated with the revenue decline than a substantial change in average order value.
- **June shows a further decline, but the month is incomplete:** Revenue was 10.05 million across 1,395 orders through June 14. The reported 73.59% decline is not a like-for-like monthly comparison because June contains only 14 days of data.The dataset ends on June 14, while the final 14-day interval ends on June 22. Therefore, the last period is incomplete and its revenue and order count should not be directly compared with those of full 14-day periods.


### Business Interpretation

- **Initial increase:** Revenue increased by 26.74% in the 14-day period beginning March 30, reaching ₹40.17 million across 5,256 delivered orders.
- **Sustained decline:** Revenue subsequently declined in each reported period, falling by 37.75% in the period beginning April 13 and continuing to decrease through the period beginning June 8.
- **Order volume followed a similar pattern:** Delivered-order counts peaked at 5,256 in the second period and declined in each subsequent period, reaching 595 in the final reported period.
- **Incomplete final period:** The final 14-day interval runs from June 8 to June 22, but the dataset contains orders only through June 14. Therefore, the last period is incomplete, and its revenue and order count should not be directly compared with those of full 14-day periods.

### Limitations

- The analysis groups orders by `created_at` and filters on their current status of `delivered`. It therefore measures revenue from orders currently marked delivered, grouped by order creation date—not revenue by actual delivery date.
- The final period is incomplete, which contributes to its lower reported revenue and order count.
- These results identify a downward trend in the observed data but do not establish its cause. Further investigation would be needed to distinguish changes in demand from fulfillment timing, data coverage, or other factors.
