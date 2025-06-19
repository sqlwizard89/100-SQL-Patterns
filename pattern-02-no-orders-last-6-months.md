📘 Pattern 02 – Customers with No Orders in the Last 6 Months
🔍 Objective
Identify all customers who have not placed any orders in the last 6 months.

🧠 Skills Covered
LEFT JOIN and null filtering

Date filtering with DATEADD()

Understanding of anti-joins (finding what’s missing)

Group exclusion logic

🧾 Problem Statement
Return the list of customers who did not place any orders in the past 6 months. Include the customer ID and customer name.

🧱 Tables Used
Sales.Customers

Sales.Orders


🧮 SQL Query

SELECT 
  c.CustomerID, 
  c.CustomerName 
FROM sales.Customers c
LEFT JOIN sales.Orders o 
  ON c.CustomerID = o.CustomerID 
  AND o.OrderDate >= DATEADD(MONTH, -6, GETDATE())
WHERE o.OrderID IS NULL;
📊 Sample Output
CustomerID	CustomerName
110	Alpine Outfitters
119	Fabrikam Bikes
123	Swift Cycles

🎯 Why This Pattern Matters
Finding inactive customers is crucial in customer retention analysis and churn prediction. This pattern is often used in CRMs, marketing re-engagement campaigns, and B2B reporting.

