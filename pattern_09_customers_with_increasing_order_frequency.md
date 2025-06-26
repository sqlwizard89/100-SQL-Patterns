📘 Pattern 09 – Customers with Increasing Order Frequency (Last 60 Days) 🔍

---

### Objective

Identify customers who have placed **more orders** in the most recent 30-day period compared to the 30 days before that. Useful for spotting re-engaged or loyal customers.

---

### 🧠 Skills Covered

- Common Table Expressions (CTEs)  
- Aggregations with COUNT()  
- Date filtering and window segmentation  
- INNER JOINs between CTEs  
- Handling divide-by-zero with NULLIF()  
- Calculating percentage growth in order frequency  

---

### 🧾 Problem Statement

You’ve been asked to find customers who are increasing their engagement. For each customer, count the number of orders they placed in the **last 30 days** and compare it to the **30-day period before that**. Show only those customers whose recent order count is higher than before. Return:

- Customer name  
- Orders in the recent 30 days  
- Orders in the previous 30 days  
- Absolute growth in order count  
- Percentage increase (relative to previous count)

---

### 🧱 Tables Used

- `sales.Orders`  
- `sales.Customers`

---

### 🧮 SQL Query

```sql
WITH recentorders AS (
    SELECT 
        c.CustomerName, 
        COUNT(o.OrderID) AS RECENT_ORDERS
    FROM sales.Orders o
    INNER JOIN sales.Customers c ON o.CustomerID = c.CustomerID
    WHERE o.OrderDate BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()
    GROUP BY c.CustomerName
),
previousorders AS (
    SELECT 
        c.CustomerName, 
        COUNT(o.OrderID) AS PREVIOUS_ORDERS
    FROM sales.Orders o
    INNER JOIN sales.Customers c ON o.CustomerID = c.CustomerID
    WHERE o.OrderDate BETWEEN DATEADD(DAY, -60, GETDATE()) AND DATEADD(DAY, -31, GETDATE())
    GROUP BY c.CustomerName
)
SELECT 
    r.CustomerName, 
    r.RECENT_ORDERS, 
    p.PREVIOUS_ORDERS,
    (r.RECENT_ORDERS - p.PREVIOUS_ORDERS) AS GROWTH_IN_ORDERS, 
    ROUND((r.RECENT_ORDERS - p.PREVIOUS_ORDERS) * 100.0 / NULLIF(p.PREVIOUS_ORDERS, 0), 2) AS ORDER_GROWTH_PCT
FROM recentorders r
INNER JOIN previousorders p ON r.CustomerName = p.CustomerName
WHERE r.RECENT_ORDERS > p.PREVIOUS_ORDERS
ORDER BY GROWTH_IN_ORDERS DESC;
