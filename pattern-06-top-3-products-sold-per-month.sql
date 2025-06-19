/*
Pattern 06 — Top 3 Products Sold Each Month (Last 12 Months)

Objective:
Identify the top 3 best-selling products by quantity for each month in the last 12 months.

Tables:
- sales.OrderLines
- warehouse.StockItems
- sales.Orders

Logic:
1. Aggregate total quantity sold per product per month/year.
2. Use RANK() window function to rank products within each month.
3. Filter to top 3 products per month based on quantity sold.
*/

WITH MonthlyProductSales AS
(
    SELECT 
        DATEPART(MONTH, O.OrderDate) AS MonthOfOrder,
        DATEPART(YEAR, O.OrderDate) AS YearOfOrder,
        SI.StockItemName AS ProductName,
        SUM(OL.Quantity) AS TotalQuantityOrdered
    FROM sales.OrderLines OL
    INNER JOIN warehouse.StockItems SI ON OL.StockItemID = SI.StockItemID
    INNER JOIN sales.Orders O ON OL.OrderID = O.OrderID
    WHERE O.OrderDate >= DATEADD(MONTH, -12, GETDATE())
    GROUP BY 
        DATEPART(MONTH, O.OrderDate), 
        DATEPART(YEAR, O.OrderDate), 
        SI.StockItemName
),
RankedSales AS
(
    SELECT
        MonthOfOrder,
        YearOfOrder,
        ProductName,
        TotalQuantityOrdered,
        RANK() OVER (
            PARTITION BY YearOfOrder, MonthOfOrder
            ORDER BY TotalQuantityOrdered DESC
        ) AS SalesRank
    FROM MonthlyProductSales
)
SELECT 
    MonthOfOrder,
    YearOfOrder,
    ProductName,
    TotalQuantityOrdered,
    SalesRank
FROM RankedSales
WHERE SalesRank <= 3
ORDER BY YearOfOrder, MonthOfOrder, SalesRank;
