/*
Pattern 13 — High-Value Inactive Customers

Objective:
Identify customers who have NOT placed any orders in the last 90 days,
but whose lifetime total order value ranks in the top 25% of all customers.

Tables:
- Sales.Customers
- Sales.Orders
- Sales.OrderLines

Logic:
1. Calculate total lifetime sales (including tax) for each customer.
2. Rank customers into quartiles by total lifetime sales using NTILE(4).
3. Find the most recent order date per customer.
4. Select customers in the top quartile (top 25% spenders) who have not ordered in the last 90 days or have never ordered.
*/

WITH CUSTOMER_SALES_DATA AS 
(
SELECT C.CustomerID, C.CustomerName, SUM(OL.Quantity*OL.UnitPrice*(1+(OL.TaxRate/100))) TOTAL_LIFETIME_SALES  FROM SALES.ORDERS O
INNER JOIN SALES.ORDERLINES OL 
ON O.OrderID=OL.OrderID
INNER JOIN SALES.CUSTOMERS C
ON C.CustomerID=O.CustomerID
GROUP BY C.CustomerID, C.CustomerName
),
RANKED_CUSTOMERS AS 
(
SELECT *, NTILE(4) OVER(ORDER BY TOTAL_LIFETIME_SALES DESC) CSTMR_RNKNG FROM 
CUSTOMER_SALES_DATA
),
LAST_ORDER_DATES AS
(
SELECT C.CustomerID, MAX(O.OrderDate) LATEST_ORDER_DATE FROM SALES.CUSTOMERS C
LEFT JOIN SALES.ORDERS O
ON C.CustomerID=O.CustomerID
GROUP BY C.CustomerID
)
SELECT RC.CustomerID,RC.CustomerName, RC.CSTMR_RNKNG, LOD.LATEST_ORDER_DATE LAST_ORDER_DATE FROM RANKED_CUSTOMERS RC
INNER JOIN LAST_ORDER_DATES LOD
ON RC.CustomerID=LOD.CustomerID
WHERE 
RC.CSTMR_RNKNG=1 AND
(LOD.LATEST_ORDER_DATE<DATEADD(DAY,-90,GETDATE())
OR LOD.LATEST_ORDER_DATE IS NULL)
