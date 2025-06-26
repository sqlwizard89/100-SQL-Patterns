# 📈 Pattern 09 — Customers with Increasing Order Frequency

---

### 🔍 Objective

Identify customers who placed **more orders in the last 30 days** than they did in the **previous 30 days**. This highlights growing customer engagement and is useful in loyalty tracking, reactivation campaigns, and CRM analytics.

---

### 🧠 Skills Covered

- CTEs (Common Table Expressions)
- Aggregations with `COUNT()`
- Time window segmentation
- INNER JOINs
- Conditional filtering
- Growth calculation with `ROUND()` and `NULLIF()`

---

### 🧾 Problem Statement

Your manager asks you to find customers whose order frequency has increased in the most recent month compared to the month before that. You are to return:

- Customer Name  
- Number of Orders in Recent 30 Days  
- Number of Orders in Previous 30 Days  
- Growth in Order Count  
- % Growth (rounded to 2 decimals)

Only show customers who **increased** their ordering activity.

---

### 🧱 Tables Used

- `sales.Orders`  
- `sales.Customers`

---

### 🧮 SQL Concepts Demonstrated

- Time-based comparison across rolling windows  
- Counting grouped records (per customer)  
- Calculating percentage change  
- Ensuring no divide-by-zero errors with `NULLIF()`  
- Applying a `WHERE` clause post-join to restrict results to growth cases only

---

### 🎯 Why This Pattern Matters

This is a highly practical pattern used in:

- Customer loyalty reporting  
- Marketing segmentation  
- CRM dashboards  
- Interview cases testing retention/growth detection logic

---

> ✅ Bonus Tip: You can reverse the condition to find customers **losing** engagement too.
