📘 Pattern 06 – Top 3 Products Sold Each Month
🔍 Objective
Identify the top 3 best-selling products (by quantity) for each month in the last 12 months using RANK() with PARTITION BY.

🧠 Skills Covered
Window Functions (RANK())

Aggregations with SUM()

CTEs (Common Table Expressions)

PARTITION BY in analytical queries

Monthly analysis

🧾 Problem Statement
For each month in the past year, find the top 3 products based on the total quantity sold. Include the product name, total quantity sold, and the month/year of the order.

🧱 Tables Used
Sales.OrderLines

Warehouse.StockItems

Sales.Orders

🧮 SQL Query
sql
Copy
Edit
WITH MONTHLY_PRODUCT_SALES AS
(
  SELECT 
    DATEPART(MONTH, O.OrderDate) AS MONTH_OF_ORDER,
    DATEPART(YEAR, O.OrderDate) AS YEAR_OF_ORDER,
    SI.StockItemName AS NAME_OF_ITEM,
    SUM(OL.Quantity) AS TOTAL_QUANTITY_ORDERED
  FROM sales.OrderLines OL
  INNER JOIN warehouse.StockItems SI ON OL.StockItemID = SI.StockItemID
  INNER JOIN sales.Orders O ON OL.OrderID = O.OrderID
  WHERE O.OrderDate >= DATEADD(MONTH, -12, GETDATE())
  GROUP BY 
    DATEPART(MONTH, O.OrderDate), 
    DATEPART(YEAR, O.OrderDate), 
    SI.StockItemName
),
RANKED_SALES AS
(
  SELECT 
    MONTH_OF_ORDER, 
    YEAR_OF_ORDER, 
    NAME_OF_ITEM, 
    TOTAL_QUANTITY_ORDERED,
    RANK() OVER (
      PARTITION BY YEAR_OF_ORDER, MONTH_OF_ORDER 
      ORDER BY TOTAL_QUANTITY_ORDERED DESC
    ) AS SALES_RANK
  FROM MONTHLY_PRODUCT_SALES
)
SELECT 
  MONTH_OF_ORDER, 
  YEAR_OF_ORDER, 
  NAME_OF_ITEM, 
  TOTAL_QUANTITY_ORDERED, 
  SALES_RANK
FROM RANKED_SALES
WHERE SALES_RANK <= 3
ORDER BY YEAR_OF_ORDER, MONTH_OF_ORDER, SALES_RANK;

🎯 Why This Pattern Matters
This is a classic analytical query often asked in interviews or required in reporting dashboards. It shows your ability to:

Segment data by time
Apply ranking logic
Use clean and efficient SQL structure
