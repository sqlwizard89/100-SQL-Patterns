/*
Pattern 11 — Top 5 Customers by Total Sales Amount

Objective:
Identify the top 5 customers who have generated the highest total sales value (including tax) across all their orders.

Tables:
- sales.Customers
- sales.Orders
- sales.OrderLines

Logic:
1. Join Customers, Orders, and OrderLines tables.
2. Calculate total sales per customer by summing Quantity * UnitPrice * (1 + TaxRate/100).
3. Group results by CustomerID and CustomerName.
4. Order results by total sales descending.
5. Limit output to top 5 customers.
*/

SELECT TOP 5 
    C.CustomerID,
    C.CustomerName,
    SUM(OL.Quantity * OL.UnitPrice * (1 + OL.TaxRate / 100.0)) AS TotalSalesAmount
FROM sales.Customers C
INNER JOIN sales.Orders O ON C.CustomerID = O.CustomerID
INNER JOIN sales.OrderLines OL ON O.OrderID = OL.OrderID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY TotalSalesAmount DESC;
