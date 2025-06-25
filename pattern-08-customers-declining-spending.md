📘 Pattern 08 – Customers with Declining Spending (Last 60 Days) 🔍

Objective  
Identify customers whose spending has **declined** in the most recent 30-day period compared to the previous 30-day period.

🧠 Skills Covered  
- Common Table Expressions (CTEs)  
- Aggregations with SUM()  
- Date filtering and comparison  
- INNER JOINs between CTEs  
- Handling divide-by-zero with NULLIF()  
- Calculating percentage decline  

🧾 Problem Statement  
For customers who have spending records in both the recent and previous 30-day periods, find those whose recent spending is less than their previous spending. Include customer name, recent expense, previous expense, absolute dip in spending, and percent decline relative to previous spending.

🧱 Tables Used  
- sales.Invoices  
- sales.InvoiceLines  
- sales.Customers  

🧮 SQL Query  
```sql
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
