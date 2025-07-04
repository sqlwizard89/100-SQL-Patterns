/*
Pattern 01 — Customer Revenue (Last 12 Months)

Objective:
Calculate the total revenue generated by each customer over the past 12 months.

Tables:
- Sales.Invoices
- Sales.InvoiceLines
- Sales.Customers

Logic:
Join invoices with invoice lines and customers.
Filter invoices within the past 12 months.
Group by customer and sum extended price.

*/

SELECT 
    c.CustomerID, 
    c.CustomerName, 
    SUM(ExtendedPrice) AS Total_Revenue  
FROM sales.Invoices i
INNER JOIN sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
INNER JOIN sales.Customers c ON i.CustomerID = c.CustomerID
WHERE i.InvoiceDate >= DATEADD(YEAR, -1, GETDATE())
GROUP BY c.CustomerID, c.CustomerName
ORDER BY Total_Revenue DESC;
