/*
Pattern 09 — Customers with Increasing Order Frequency

Objective:
Identify customers who placed more orders in the most recent 30 days than in the previous 30 days.
Useful for identifying loyal or reactivated customers with increased engagement.

Tables:
- sales.Orders
- sales.Customers

Logic:
1. Count number of orders per customer in the recent 30 days.
2. Count number of orders per customer in the previous 30 days.
3. Join both timeframes using CustomerName.
4. Filter only those customers whose recent order count is higher.
5. Calculate growth in number of orders and percentage increase.
*/

WITH recentorders AS (
    SELECT 
        c.CustomerName, 
        COUNT(o.OrderID) AS RECENT_ORDERS
    FROM sales.Orders o
    INNER JOIN sales.Customers c 
        ON o.CustomerID = c.CustomerID
    WHERE o.OrderDate BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()
    GROUP BY c.CustomerName
),
previousorders AS (
    SELECT 
        c.CustomerName, 
        COUNT(o.OrderID) AS PREVIOUS_ORDERS
    FROM sales.Orders o
    INNER JOIN sales.Customers c 
        ON o.CustomerID = c.CustomerID
    WHERE o.OrderDate BETWEEN DATEADD(DAY, -60, GETDATE()) AND DATEADD(DAY, -31, GETDATE())
    GROUP BY c.CustomerName
)

SELECT 
    r.CustomerName,
    r.RECENT_ORDERS,
    p.PREVIOUS_ORDERS,
    (r.RECENT_ORDERS - p.PREVIOUS_ORDERS) AS GROWTH_IN_ORDERS,
    ROUND((r.RECENT_ORDERS - p.PREVIOUS_ORDERS) * 100.0 / NULLIF(p.PREVIOUS_ORDERS, 0), 2) AS ORDER_GROWTH_PCT
FROM recentorders r
INNER JOIN previousorders p 
    ON r.CustomerName = p.CustomerName
WHERE r.RECENT_ORDERS > p.PREVIOUS_ORDERS
ORDER BY GROWTH_IN_ORDERS DESC;
