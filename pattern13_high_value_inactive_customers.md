📘 Pattern 13 — High-Value Inactive Customers

🔍 Objective  
Identify customers who have **not placed any orders in the last 90 days**, but whose **lifetime total order value** ranks in the **top 25%** of all customers.

This helps target valuable customers who may have recently become inactive.

🧠 Skills Covered  
- Aggregations (SUM)  
- Window functions (NTILE)  
- Date filtering and inactivity detection  
- Joins and conditional filtering

🧾 Problem Statement  
Calculate each customer's total lifetime sales from all orders.  
Rank customers into quartiles by lifetime sales.  
Find the last order date for each customer.  
Return only customers in the top 25% (highest spenders) who have not ordered in the last 90 days or never ordered.

🧱 Tables Used  
- Sales.Customers  
- Sales.Orders  
- Sales.OrderLines

🧮 SQL Query

```sql
WITH CUSTOMER_SALES_DATA AS 
(
    SELECT 
        C.CustomerID, 
        C.CustomerName, 
        SUM(OL.Quantity * OL.UnitPrice * (1 + (OL.TaxRate / 100.0))) AS TOTAL_LIFETIME_SALES  
    FROM Sales.Orders O
    INNER JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
    INNER JOIN Sales.Customers C ON C.CustomerID = O.CustomerID
    GROUP BY C.CustomerID, C.CustomerName
),
RANKED_CUSTOMERS AS 
(
    SELECT *, 
           NTILE(4) OVER (ORDER BY TOTAL_LIFETIME_SALES DESC) AS CSTMR_RNKNG 
    FROM CUSTOMER_SALES_DATA
),
LAST_ORDER_DATES AS
(
    SELECT 
        C.CustomerID, 
        MAX(O.OrderDate) AS LATEST_ORDER_DATE
    FROM Sales.Customers C
    LEFT JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
    GROUP BY C.CustomerID
)
SELECT 
    RC.CustomerID,
    RC.CustomerName, 
    RC.TOTAL_LIFETIME_SALES,
    RC.CSTMR_RNKNG, 
    LOD.LATEST_ORDER_DATE AS LAST_ORDER_DATE
FROM RANKED_CUSTOMERS RC
INNER JOIN LAST_ORDER_DATES LOD ON RC.CustomerID = LOD.CustomerID
WHERE 
    RC.CSTMR_RNKNG = 1
    AND (LOD.LATEST_ORDER_DATE < DATEADD(DAY, -90, GETDATE()) OR LOD.LATEST_ORDER_DATE IS NULL)
ORDER BY RC.TOTAL_LIFETIME_SALES DESC;
