1. Order-status distribution
Total orders
40,000

Delivered orders
19,979
49.95% of all orders

Cancelled orders
2,178
5.45% of all orders

Not delivered
20,021
50.05% of all orders

2. What these numbers tell us ?
Three important interpretations :
- Approximately half of all orders are delivered. The delivered share is 49.95%, so analyzing delivered orders alone excludes 20,021 orders, or 50.05% of the total.
- Cancellation is relatively limited in the overall order mix. There are 2,178 cancelled orders, representing 5.45% of all orders. This is a descriptive finding, not proof that the cancellation rate is good or bad.
- The remaining statuses are not necessarily failed orders. Paid, packed, shipped, and placed orders may still be progressing through the order lifecycle. They should not be combined with cancellations and described as lost sales.

3. Data Quality Findings

Order Status Discrepancies

A comparison of orders.status with the latest available status in order_status_history identified 134 status discrepancies.

A separate timestamp check found no cases where the latest status-history event occurred before the corresponding order's creation timestamp.

Interpretation: The discrepancies concern status consistency, not the chronological ordering of the latest history event. These checks do not establish which status value is correct.

Returns Data Limitation

The return_items data cannot currently be reliably joined at the item level for return analysis. Therefore, net revenue calculations should remain at the order level until the return-item relationships are validated.

Product-level net revenue and returned-unit rates should not be reported until the item-level return relationships have been verified.