### Total No of customers
=10,000


### Customer Demographics
Country	                Total customers	Percentage
India	                7,641	        76.41%
United States	        1,359	        13.59%
Unknown / Not Provided	1,000	        10.00%
Total	                10,000	        100.00%


### Customers with the Highest Order Frequency

### Business Question  
Which customers place orders most frequently?

### Methodology
 Counted orders by customer ID and ranked customers by order count in descending order.

### Key Findings 
The highest-frequency customer in the observed results placed 178 orders, followed by customers with 176 and 170 orders.

### Business interpretation
A small group of customers may contribute substantially to order activity. Comparing these customers' order frequency with their net revenue and refund rates can help distinguish frequent purchasing from high-value purchasing.

### Limitations
 Order frequency alone does not measure profitability, net revenue, or customer loyalty over time.


# Customer Segmentation Analysis
### 1-Time vs. Repeat Customer Analysis

The analysis identified 8,800 customers with orders: 4,999 one-time customers (56.81%) and 3,801 repeat customers (43.19%). Repeat customers contributed 111.56 million in delivered revenue, representing 87.56% of total delivered revenue, while one-time customers contributed 15.85 million (12.44%).

**Key insight:** Repeat customers account for a smaller share of customers but contribute the majority of delivered revenue. This highlights customer retention as an area for further investigation.

**Business implication:** Further analysis could examine repeat-purchase frequency, time between purchases, and customer retention patterns to identify opportunities to encourage subsequent purchases.

**Methodology note:** Customers are classified using their total recorded orders across all statuses. Revenue includes only orders currently marked as delivered and is calculated using `order_items.line_total`. The analysis does not deduct refunds from customer-level revenue.


##  Customer Purchase Frequency

### Business Question
What proportion of customers make only one purchase, and how many return to place additional orders?

### Methodology
- Counted distinct orders for each customer using the `orders` table.
- Classified customers with exactly one order as one-time purchasers.
- Calculated the one-time-purchaser share among customers who placed at least one order.

### Key Findings

| Metric | Result |
|---|---:|
| Total customers                  | 10,000 |
| Customers with at least one order | 8,800 |
| Customers with exactly one order | 4,999 |
| Customers with multiple orders | 3,801 |
| One-time purchasers among customers with orders | 56.81% |
| One-time purchasers among all customers | 49.99% |
| Customers with no recorded orders | 1,200 |

### Business Interpretation
One-time purchasers account for 56.81% of customers who placed at least one order. The remaining 43.19% of customers with orders made multiple purchases.

This indicates an opportunity to investigate repeat-purchase behavior and customer retention. However, the analysis alone does not establish why customers did not return.

### Business Recommendation
Investigate purchase frequency, time between orders, and customer spending patterns to identify opportunities to encourage repeat purchases.

### Limitation
This analysis counts all recorded orders regardless of current order status. The results therefore describe recorded purchase frequency, not necessarily completed or delivered purchases.



## VIP Customer Profiling: Spend, Purchase Frequency, and Average Order Value

### Business Question
Do the highest-revenue customers generate more revenue through frequent purchases or higher average order values?

### Methodology
- Identified the top 10 customers by gross realized revenue from orders currently marked as `delivered`.
- Calculated customer-level revenue using `order_items.line_total`.
- Counted distinct delivered orders to measure purchase frequency within the dataset.
- Calculated average order value (AOV) as gross realized revenue divided by the number of distinct delivered orders.
- Ranked customers using `DENSE_RANK()` in descending order of revenue.

### Key Findings

- **Highest-spending customer:** Shreya Menon ranked first, generating 673,757.00 across 90 delivered orders, with an AOV of 7,486.19.
- **Highest purchase frequency:** Reyansh Deshpande recorded 102 delivered orders, generating 521,186.00. Despite the highest order count among these customers, his AOV was the lowest in the top 10 at 5,109.67.
- **Highest AOV:** Vivaan Naidu recorded an AOV of 10,436.72 across 53 delivered orders, the highest among the top 10. His total revenue was 553,146.00.
- **Revenue through different purchasing patterns:** Harsha Banerjee generated 591,957.00 from 95 orders at an AOV of 6,231.13, whereas Emma Wilson generated 563,657.00 from 70 orders at a higher AOV of 8,052.24.
- **Customer-data completeness:** Three of the top 10 customers have unavailable country information, limiting geographic segmentation of this high-value customer group.

### Business Interpretation
The results show different purchasing patterns among the highest-revenue customers. Some customers generate substantial revenue through frequent orders, while others generate comparable revenue through fewer, higher-value orders.

This distinction can help guide further customer analysis. High-frequency customers may be suitable candidates for retention initiatives, while customers with higher AOV may warrant investigation into their product mix and basket composition. These are potential strategies to evaluate, not proven outcomes from this analysis alone.

### Limitations
- The VIP segment is defined as the top 10 customers by revenue in this dataset; it is not a validated customer-lifecycle or loyalty classification.
- Purchase frequency represents the number of distinct delivered orders observed in the available data, not an annual or monthly purchase rate.
- AOV is calculated from `order_items.line_total` and may differ from average order value based on `orders.total`.
- The analysis measures gross realized revenue and does not deduct customer-level refunds.
- Revenue rankings do not measure customer profitability because customer-specific costs are not included.