📘 Pattern 04 – Customers with No Orders in the Last 12 Months
🔍 Objective
List all customers who have not placed any orders in the past 12 months — useful for identifying long-term inactivity.

🧠 Skills Covered
LEFT JOIN with conditional filtering

Anti-join logic (IS NULL)

Date filtering with DATEADD()

Time-based segmentation

🧾 Problem Statement
Identify customers who haven’t placed any orders in the last 12 months. Return the customer ID and name. Assume you are running this as of today’s date.

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
  AND o.OrderDate > DATEADD(MONTH, -12, GETDATE())
WHERE o.OrderID IS NULL;


📊 Sample Output
CustomerID	CustomerName
114	Ride More Bikes
120	Liberty Cycles
125	Speedy Wheels Inc.

🎯 Why This Pattern Matters
This pattern is often used for customer churn detection, re-engagement marketing, and building dashboards that flag dormant accounts. It's a repeatable technique in CRM analytics and a common interview task.
