# 📘 Pattern 11 – Top 5 Customers by Total Sales Amount

---

### 🔍 Objective

Identify the top 5 customers who have generated the highest total sales value (including tax) across all their orders.

This helps prioritize key customers for marketing, rewards, or personalized engagement.

---

### 🧠 Skills Covered

- Joins between multiple tables  
- Aggregations with `SUM()`  
- Calculating tax-inclusive sales totals  
- Grouping and ordering results  
- Limiting results using `TOP`  
- Alias usage for clean output  

---

### 🧾 Problem Statement

Using the WideWorldImporters dataset:

- Join Customers, Orders, and OrderLines tables  
- Calculate each customer's total sales value as the sum of `Quantity * UnitPrice * (1 + TaxRate / 100)`  
- Sort customers by their total sales in descending order  
- Return the top 5 customers with columns:  
  - `CustomerID`  
  - `CustomerName`  
  - `TotalSalesAmount` (including tax)  

---

### 🧱 Tables Used

- `Sales.Customers`  
- `Sales.Orders`  
- `Sales.OrderLines`  

---

### 🧮 SQL Query

```sql
SELECT TOP 5 
    C.CustomerID,
    C.CustomerName,
    SUM(OL.Quantity * OL.UnitPrice * (1 + OL.TaxRate / 100.0)) AS TotalSalesAmount
FROM Sales.Customers C
INNER JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
INNER JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY TotalSalesAmount DESC;
