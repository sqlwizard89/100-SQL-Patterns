📘 Pattern 05 – Top Customers by Number of Orders in Last 3 Months
🔍 Objective

Find the customers who placed the most orders in the last 3 months, ranked from highest to lowest.

🧠 Skills Covered
Aggregation with COUNT()
INNER JOIN usage
Date filtering with DATEADD()
Grouping and ordering
Basic ranking by sorting

🧾 Problem Statement

Retrieve customer IDs, names, and the number of orders they placed in the past 3 months. Sort the results to show the most frequent customers first.

🧱 Tables Used

Sales.Customers
Sales.Orders

🧮 SQL Query

SELECT 
  c.CustomerID, 
  c.CustomerName, 
  COUNT(o.OrderID) AS NumberOfOrders
FROM sales.Customers c
INNER JOIN sales.Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > DATEADD(MONTH, -3, GETDATE())
GROUP BY c.CustomerID, c.CustomerName
ORDER BY NumberOfOrders DESC;


📊 Sample Output

CustomerID	CustomerName	NumberOfOrders
105	Contoso Traders	15
112	Tailspin Toys	12
119	Alpine Outfitters	9

🎯 Why This Pattern Matters
This query helps identify active customers and their purchasing behavior. It’s a common use case for sales reporting, customer analytics, and interview questions related to joins and aggregation.

