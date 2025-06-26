/*
Pattern 10 — Average Order Value Growth (Recent 30 Days vs. Previous 30 Days)

Objective:
Measure per-customer growth in average order value (AOV) by comparing recent and previous 30-day windows.

Tables:
- sales.Orders
- sales.OrderLines
- sales.Customers

Logic:
1. Calculate total order value with tax and number of unique orders per customer.
2. Compute AOV = Total Value / Order Count for both recent and previous windows.
3. Identify customers whose AOV increased.
4. Calculate absolute and percentage growth in AOV.
*/

WITH recentorderaverage AS (
    SELECT 
        c.CustomerName, 
        COUNT(DISTINCT o.OrderID) AS RECENT_ORDER_COUNT, 
        SUM(OL.Quantity * OL.UnitPrice * (1 + OL.TaxRate / 100.0)) AS RECENT_ORDER_TOTAL, 
        SUM(OL.Quantity * OL.UnitPrice * (1 + OL.TaxRate / 100.0)) / COUNT(DISTINCT o.OrderID) AS RECENT_AVERAGE_ORDER_VALUE
    FROM sales.Orders o
    INNER JOIN sales.Customers c ON o.CustomerID = c.CustomerID
    INNER JOIN sales.OrderLines OL ON o.OrderID = OL.OrderID
    WHERE o.OrderDate BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()
    GROUP BY c.CustomerName
),
previousorderaverage AS (
    SELECT 
        c.CustomerName, 
        COUNT(DISTINCT o.OrderID) AS PREVIOUS_ORDER_COUNT, 
        SUM(OL.Quantity * OL.UnitPrice * (1 + OL.TaxRate / 100.0)) AS PREVIOUS_ORDER_TOTAL, 
        SUM(OL.Quantity * OL.UnitPrice * (1 + OL.TaxRate / 100.0)) / COUNT(DISTINCT o.OrderID) AS PREVIOUS_AVERAGE_ORDER_VALUE
    FROM sales.Orders o
    INNER JOIN sales.Customers c ON o.CustomerID = c.CustomerID
    INNER JOIN sales.OrderLines OL ON o.OrderID = OL.OrderID
    WHERE o.OrderDate BETWEEN DATEADD(DAY, -60, GETDATE()) AND DATEADD(DAY, -31, GETDATE())
    GROUP BY c.CustomerName
)
SELECT 
    r.CustomerName, 
    r.RECENT_AVERAGE_ORDER_VALUE, 
    p.PREVIOUS_AVERAGE_ORDER_VALUE, 
    (r.RECENT_AVERAGE_ORDER_VALUE - p.PREVIOUS_AVERAGE_ORDER_VALUE) AS GROWTH_IN_AOV,
    ROUND(
        (r.RECENT_AVERAGE_ORDER_VALUE - p.PREVIOUS_AVERAGE_ORDER_VALUE) * 100.0 / NULLIF(p.PREVIOUS_AVERAGE_ORDER_VALUE, 0), 
        2
    ) AS PCT_GROWTH_IN_AOV
FROM recentorderaverage r
INNER JOIN previousorderaverage p ON r.CustomerName = p.CustomerName
WHERE r.RECENT_AVERAGE_ORDER_VALUE > p.PREVIOUS_AVERAGE_ORDER_VALUE
ORDER BY GROWTH_IN_AOV DESC;
