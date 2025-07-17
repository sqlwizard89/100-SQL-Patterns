/*
Pattern 12 — Customers with Largest Single Order in Last 60 Days Compared to Previous Orders

Objective:
Identify customers whose most recent single order (within the last 60 days) is larger than any of their previous orders in that timeframe.

Tables:
- Sales.Customers
- Sales.Orders
- Sales.OrderLines

Logic:
1. Calculate total value (including tax) for each order in the last 60 days per customer.
2. Assign row numbers to find the most recent order per customer.
3. Find the max order total excluding the most recent order.
4. Compare the most recent order total to the historical max.
5. Flag customers whose recent order is the highest.
*/

WITH Mostrecentorders AS (
    SELECT 
        C.CustomerName, 
        C.CustomerID,
        O.OrderID, 
        O.OrderDate, 
        SUM(OL.Quantity * OL.UnitPrice * (1 + (OL.TaxRate / 100.0))) AS Order_Sales_Total,
        ROW_NUMBER() OVER (PARTITION BY C.CustomerID ORDER BY O.OrderDate DESC) AS RN
    FROM Sales.Customers C
    INNER JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
    INNER JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
    WHERE O.OrderDate >= DATEADD(DAY, -60, GETDATE())
    GROUP BY C.CustomerName, C.CustomerID, O.OrderID, O.OrderDate
),
HistoricalMax AS (
    SELECT 
        CustomerName, 
        CustomerID, 
        MAX(Order_Sales_Total) AS Max_Previous_Total
    FROM Mostrecentorders
    WHERE RN > 1
    GROUP BY CustomerName, CustomerID
)
SELECT 
    M.CustomerName,
    M.CustomerID,
    M.OrderID AS Latest_order_ID,
    M.OrderDate AS Latest_order_Date,
    M.Order_Sales_Total AS Current_Order_Total,
    H.Max_Previous_Total AS Previous_max_Order_Total,
    CASE
        WHEN M.Order_Sales_Total > H.Max_Previous_Total THEN 'Yes'
        ELSE 'No'
    END AS Is_Highest_Ever
FROM Mostrecentorders M
INNER JOIN HistoricalMax H ON M.CustomerID = H.CustomerID
WHERE M.RN = 1;
