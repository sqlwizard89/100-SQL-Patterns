/*
Pattern 03 — Top 5 Products by Quantity Sold

Objective:
Identify the top 5 products by total quantity sold across all orders.

Tables:
- Sales.OrderLines
- Warehouse.StockItems

Logic:
Join order lines to stock items.
Use CASE to count picked quantity.
Aggregate and limit to top 5.

*/

SELECT TOP 5 
    SI.StockItemID, 
    SI.StockItemName,
    SUM(CASE
            WHEN OL.Quantity = OL.PickedQuantity THEN OL.Quantity
            ELSE OL.PickedQuantity
        END) AS TotalQuantitySold
FROM sales.OrderLines OL
INNER JOIN warehouse.StockItems SI
    ON OL.StockItemID = SI.StockItemID
GROUP BY SI.StockItemID, SI.StockItemName
ORDER BY TotalQuantitySold DESC;
