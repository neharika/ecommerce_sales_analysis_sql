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

## 1. Customer Purchase Frequency

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

### Top 10 Customers by Net Realized Revenue

### Business Question  
Q: Which customers generate the highest net realized revenue after accounting for refunds?


### Methodology
- Summed order_items.line_total for orders currently marked as delivered.

- Aggregated refunds by customer, excluding refund records with a failed status.

- Subtracted recorded refunds from gross realized revenue.

- Ranked customers by net realized revenue using DENSE_RANK().

### Key Findings  

Shreya Menon ranked first, with net realized revenue of ₹ 665,147.72. from ₹ 673,757.00 gross realized revenue with Rs 8,609.28 in refunds. (Country : Not Provided)

Harsha Banerjee ranked second, with ₹ 590,489.65. (Country : Not Provided)

Mahima Jain ranked third, with ₹ 567,248.78 from India.

Three of the ten displayed customers had country information classified as Unknown / Not Provided.

One particularly useful observation is that 6 of the top 10 customers had no refunds, while the highest-ranked customer had the largest absolute refund amount. That doesn't necessarily mean Shreya is a problematic customer—the refund rate is only about 1.28%—but it is worth monitoring.

### Limitations

Revenue includes orders currently marked as delivered, rather than all historical orders regardless of current status.

Refund calculations include non-failed refund records linked to currently delivered orders.

The results depend on the completeness and accuracy of the refund records and customer-country data.


