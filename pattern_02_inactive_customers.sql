/*
Pattern 02 — Customers With No Orders in Last 6 Months

Objective:
Find customers who have not placed any orders in the past 6 months.

Tables:
- Sales.Customers
- Sales.Orders

Logic:
Use LEFT JOIN and filter for NULL orders within the 6-month window.

*/

SELECT 
    c.CustomerID, 
    c.CustomerName
FROM sales.Customers c
LEFT JOIN sales.Orders o
    ON c.CustomerID = o.CustomerID
    AND o.OrderDate >= DATEADD(MONTH, -6, GETDATE())
WHERE o.OrderID IS NULL
ORDER BY c.CustomerName;
