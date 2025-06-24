/*
Pattern 07 — Customers Who Increased Their Spending (Last 60 Days)

Objective:
Identify customers who have increased their total spending in the last 30 days
compared to the previous 30-day period (31-60 days ago).

Tables:
- sales.Invoices
- sales.InvoiceLines
- sales.Customers

Logic:
1. Calculate total spending per customer in the last 30 days.
2. Calculate total spending per customer in the previous 30-day period.
3. Join the two datasets on CustomerName.
4. Select customers where recent spending > previous spending.
5. Calculate absolute spending growth and percent growth.
*/

WITH RecentSpending AS (
    SELECT 
        c.CustomerName AS CustomerName,
        SUM(il.ExtendedPrice) AS RecentExpense
    FROM sales.Invoices i
    INNER JOIN sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
    INNER JOIN sales.Customers c ON i.CustomerID = c.CustomerID
    WHERE i.InvoiceDate BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()
    GROUP BY c.CustomerName
),
PreviousSpending AS (
    SELECT 
        c.CustomerName AS CustomerName,
        SUM(il.ExtendedPrice) AS PreviousExpense
    FROM sales.Invoices i
    INNER JOIN sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
    INNER JOIN sales.Customers c ON i.CustomerID = c.CustomerID
    WHERE i.InvoiceDate BETWEEN DATEADD(DAY, -60, GETDATE()) AND DATEADD(DAY, -31, GETDATE())
    GROUP BY c.CustomerName
)
SELECT
    r.CustomerName,
    r.RecentExpense,
    p.PreviousExpense,
    (r.RecentExpense - p.PreviousExpense) AS GrowthInSpending,
    ROUND(
        (r.RecentExpense - p.PreviousExpense) * 100.0 / NULLIF(p.PreviousExpense, 0),
        2
    ) AS PercentGrowth
FROM RecentSpending r
INNER JOIN PreviousSpending p ON r.CustomerName = p.CustomerName
WHERE r.RecentExpense > p.PreviousExpense
ORDER BY GrowthInSpending DESC;
