📘 Pattern 03 – Most Frequently Sold Products
🔍 Objective
Identify which products were sold most frequently by computing the total quantity sold per product.

🧠 Skills Covered
Aggregation with SUM()

Handling picked vs. ordered quantity

INNER JOIN across sales and warehouse schemas

GROUP BY and sorting

🧾 Problem Statement
Find the total quantity sold for each product. Use the picked quantity when it's available, otherwise use the ordered quantity. Display the product ID, name, and total quantity sold. Sort the result by quantity in descending order.

🧱 Tables Used
Sales.OrderLines

Warehouse.StockItems

🧮 SQL Query

SELECT 
  SI.StockItemID, 
  SI.StockItemName,
  SUM(
    CASE 
      WHEN OL.Quantity = OL.PickedQuantity THEN OL.Quantity
      ELSE OL.PickedQuantity
    END
  ) AS Total_Quantity_Sold
FROM sales.OrderLines OL
INNER JOIN warehouse.StockItems SI
  ON OL.StockItemID = SI.StockItemID
GROUP BY SI.StockItemID, SI.StockItemName
ORDER BY Total_Quantity_Sold DESC;


📊 Sample Output
StockItemID	StockItemName	Total_Quantity_Sold
101	Road-750 Black, 52	4,580
103	Mountain-200 Blue, 46	3,950
108	HL Mountain Frame	3,420

🎯 Why This Pattern Matters
This pattern teaches how to work with real-world edge cases, like partial fulfillment or backorders. It also shows how to use CASE inside SUM() for conditional aggregation — a common technique in business analytics and interviews.
