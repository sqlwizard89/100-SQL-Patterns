/*
Pattern 08 — Customers with Declining Spending (Last 60 Days)

Objective:
Identify customers whose spending has declined in the most recent 30-day period compared to the previous 30-day period.

Tables:
- sales.Invoices
- sales.InvoiceLines
- sales.Customers

Logic:
1. Calculate total spending per customer in the most recent 30 days.
2. Calculate total spending per customer in the previous 30 days.
3. Join the two periods on CustomerName.
4. Filter customers whose recent spending is less than previous spending.
5. Calculate absolute and percentage decline in spending.
*/

WITH recentspending AS (
    SELECT 
        c.CustomerName, 
        SUM(IL.ExtendedPrice) AS RECENT_EXPENSE
    FROM sales.Invoices I
    INNER JOIN sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
    INNER JOIN sales.Customers C ON I.CustomerID = C.CustomerID
    WHERE I.InvoiceDate BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()
    GROUP BY c.CustomerName
),
previousspending AS (
    SELECT 
        c.CustomerName, 
        SUM(IL.ExtendedPrice) AS PREVIOUS_EXPENSE
    FROM sales.Invoices I
    INNER JOIN sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
    INNER JOIN sales.Customers C ON I.CustomerID = C.CustomerID
    WHERE I.InvoiceDate BETWEEN DATEADD(DAY, -60, GETDATE()) AND DATEADD(DAY, -31, GETDATE())
    GROUP BY c.CustomerName
)
SELECT 
    r.CustomerName, 
    p.PREVIOUS_EXPENSE, 
    r.RECENT_EXPENSE,
    (p.PREVIOUS_EXPENSE - r.RECENT_EXPENSE) AS DIP_IN_SALES, 
    ROUND((p.PREVIOUS_EXPENSE - r.RECENT_EXPENSE) * 100.0 / NULLIF(p.PREVIOUS_EXPENSE, 0), 2) AS PERCENTAGE_DIP_OF_SALES
FROM recentspending r
INNER JOIN previousspending p ON r.CustomerName = p.CustomerName
WHERE p.PREVIOUS_EXPENSE > r.RECENT_EXPENSE
ORDER BY DIP_IN_SALES DESC;
