/*
Pattern 04 — Customers with No Orders in the Last 12 Months

Objective:
Identify customers who haven’t placed any orders in the past 12 months.

Tables:
- Sales.Customers
- Sales.Orders

Logic:
LEFT JOIN customers to orders in the last year.
Filter NULLs to find customers with no recent activity.

*/

SELECT 
    c.CustomerID, 
    c.CustomerName
FROM sales.Customers c
LEFT JOIN sales.Orders o
    ON c.CustomerID = o.CustomerID
    AND o.OrderDate > DATEADD(MONTH, -12, GETDATE())
WHERE o.OrderID IS NULL
ORDER BY c.CustomerName;
