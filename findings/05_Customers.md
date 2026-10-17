### Total No of customers
=10,000


### Customer Demographics
Country	                Total customers	Percentage
India	                7,641	        76.41%
United States	        1,359	        13.59%
Unknown / Not Provided	1,000	        10.00%
Total	                10,000	        100.00%



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


