/*
Pattern 05 — Top Customers by Number of Orders in Last 3 Months

Objective:
Find customers who placed the most orders in the past 3 months.

Tables:
- sales.Customers
- sales.Orders

Logic:
Join customers with orders in the last 3 months.
Group by customer and count orders.
Sort descending by order count to find top customers.
*/

SELECT 
    c.CustomerID, 
    c.CustomerName, 
    COUNT(o.OrderID) AS NumberOfOrders
FROM sales.Customers c
INNER JOIN sales.Orders o 
    ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > DATEADD(MONTH, -3, GETDATE())
GROUP BY c.CustomerID, c.CustomerName
ORDER BY NumberOfOrders DESC;
