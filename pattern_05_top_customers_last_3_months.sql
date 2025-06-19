/*
Pattern 05 — Top 3 Customers by Order Count (Last 3 Months)

🎯 Objective:
Identify the top 3 customers who placed the highest number of orders in the past 3 months.

💼 Business Context:
Sales and marketing teams use this insight to reward high-value, active customers. 
This pattern supports loyalty campaigns, personalized outreach, and product launch targeting.

🧱 Tables Involved:
- Sales.Customers        → Customer details
- Sales.Orders           → Orders placed by each customer

🛠️ Query Logic:
1. Filter orders in the last 3 months using DATEADD and GETDATE().
2. Join Customers and Orders on CustomerID.
3. Group by CustomerID and CustomerName.
4. Count total orders per customer.
5. Sort in descending order and limit to Top 3.

*/

SELECT TOP 3 
    c.CustomerID, 
    c.CustomerName, 
    COUNT(o.OrderID) AS TotalOrders
FROM sales.Customers c
INNER JOIN sales.Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > DATEADD(MONTH, -3, GETDATE())
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalOrders DESC;
