📘 Pattern 07 – Customers Who Increased Their Spending

🔍 Objective  
Identify customers who spent more in the last 30 days compared to the previous 30-day period by comparing their total invoice amounts.

🧠 Skills Covered  
- Common Table Expressions (CTEs)  
- Date filtering with DATEADD() and GETDATE()  
- Aggregations with SUM() and GROUP BY  
- Joining aggregated datasets  
- Handling division by zero with NULLIF()  
- Calculating percentage growth

🧾 Problem Statement  
Find customers whose total spending increased in the most recent 30 days versus the previous 30 days. Include customer name, recent spending, previous spending, absolute and percent growth.

🧱 Tables Used  
- Sales.Invoices  
- Sales.InvoiceLines  
- Sales.Customers

🧮 SQL Query  

WITH recentspending AS (
    SELECT c.customername AS CUSTOMER_NAME, SUM(il.ExtendedPrice) AS RECENT_EXPENSE
    FROM sales.Invoices i
    INNER JOIN sales.InvoiceLines il ON i.invoiceid = il.invoiceid
    INNER JOIN sales.Customers c ON i.customerid = c.customerid
    WHERE i.invoicedate BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()
    GROUP BY c.customername
), 
previousspending AS (
    SELECT c.customername AS CUSTOMER_NAME, SUM(il.ExtendedPrice) AS PREVIOUS_EXPENSE
    FROM sales.Invoices i
    INNER JOIN sales.InvoiceLines il ON i.invoiceid = il.invoiceid
    INNER JOIN sales.Customers c ON i.customerid = c.customerid
    WHERE i.invoicedate BETWEEN DATEADD(DAY, -60, GETDATE()) AND DATEADD(DAY, -31, GETDATE())
    GROUP BY c.customername
)
SELECT 
    r.CUSTOMER_NAME, 
    r.RECENT_EXPENSE, 
    p.PREVIOUS_EXPENSE, 
    (r.RECENT_EXPENSE - p.PREVIOUS_EXPENSE) AS GROWTH_IN_SPENDING, 
    ROUND((r.RECENT_EXPENSE - p.PREVIOUS_EXPENSE) * 100.0 / NULLIF(p.PREVIOUS_EXPENSE, 0), 2) AS PERCENT_GROWTH
FROM recentspending r
INNER JOIN previousspending p ON r.CUSTOMER_NAME = p.CUSTOMER_NAME
WHERE r.RECENT_EXPENSE > p.PREVIOUS_EXPENSE
ORDER BY GROWTH_IN_SPENDING DESC;

🎯 Why This Pattern Matters
This pattern helps identify customers with increasing purchase behavior, which is valuable for targeting loyalty rewards, marketing campaigns, and retention efforts. 
It demonstrates your ability to work with CTEs, time-based filtering, aggregations, and percentage calculations in SQL.
