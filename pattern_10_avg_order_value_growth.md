📘 Pattern 10 – Customers with Increasing Average Order Value (Last 60 Days) 🔍

### Objective  
Identify customers whose **average order value (AOV)** has increased in the most recent 30-day period compared to the previous 30-day period.

---

### 🧠 Skills Covered  
- Common Table Expressions (CTEs)  
- Aggregations with `SUM()` and `COUNT(DISTINCT)`  
- Tax-inclusive revenue calculation  
- Date filtering and comparison  
- AOV computation per window  
- Handling divide-by-zero with `NULLIF()`  
- Calculating percentage increase

---

### 🧾 Problem Statement  
For customers who have placed orders in both the recent and previous 30-day periods:  
- Calculate **AOV** = total order value / number of unique orders  
- Compare AOV between periods  
- Return only customers whose **recent AOV > previous AOV**  
- Show customer name, recent AOV, previous AOV, absolute growth, and percentage growth in AOV

---

### 🧱 Tables Used  
- `sales.Orders`  
- `sales.OrderLines`  
- `sales.Customers`  

---

### 🧮 SQL Query  

```sql
WITH recentorderaverage AS (
 SELECT c.CustomerName, COUNT(DISTINCT o.OrderID) RECENT_ORDER_COUNT, 
        SUM(OL.Quantity * OL.UnitPrice * (1 + OL.TaxRate / 100.0)) RECENT_ORDER_TOTAL, 
        SUM(OL.Quantity * OL.UnitPrice * (1 + OL.TaxRate / 100.0)) / COUNT(DISTINCT o.OrderID) RECENT_AVERAGE_ORDER_VALUE   
 FROM sales.Orders o
 INNER JOIN sales.Customers c ON o.CustomerID = c.CustomerID
 INNER JOIN sales.OrderLines OL ON o.OrderID = OL.OrderID
 WHERE o.OrderDate BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()
 GROUP BY c.CustomerName
),
previousorderaverage AS (
 SELECT c.CustomerName, COUNT(DISTINCT o.OrderID) PREVIOUS_ORDER_COUNT, 
        SUM(OL.Quantity * OL.UnitPrice * (1 + OL.TaxRate / 100.0)) PREVIOUS_ORDER_TOTAL, 
        SUM(OL.Quantity * OL.UnitPrice * (1 + OL.TaxRate / 100.0)) / COUNT(DISTINCT o.OrderID) PREVIOUS_AVERAGE_ORDER_VALUE   
 FROM sales.Orders o
 INNER JOIN sales.Customers c ON o.CustomerID = c.CustomerID
 INNER JOIN sales.OrderLines OL ON o.OrderID = OL.OrderID
 WHERE o.OrderDate BETWEEN DATEADD(DAY, -60, GETDATE()) AND DATEADD(DAY, -31, GETDATE())
 GROUP BY c.CustomerName
)
SELECT r.CustomerName, 
       r.RECENT_AVERAGE_ORDER_VALUE, 
       p.PREVIOUS_AVERAGE_ORDER_VALUE,
       (r.RECENT_AVERAGE_ORDER_VALUE - p.PREVIOUS_AVERAGE_ORDER_VALUE) AS GROWTH_IN_AOV,
       ROUND((r.RECENT_AVERAGE_ORDER_VALUE - p.PREVIOUS_AVERAGE_ORDER_VALUE) * 100.0 / NULLIF(p.PREVIOUS_AVERAGE_ORDER_VALUE, 0), 2) AS PCT_GROWTH_IN_AOV
FROM recentorderaverage r
INNER JOIN previousorderaverage p ON r.CustomerName = p.CustomerName
WHERE r.RECENT_AVERAGE_ORDER_VALUE > p.PREVIOUS_AVERAGE_ORDER_VALUE
ORDER BY GROWTH_IN_AOV DESC;
