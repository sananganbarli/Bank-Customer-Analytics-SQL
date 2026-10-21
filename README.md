# Bank-Customer-Analytics-SQL
A comprehensive SQL project analyzing banking transaction history, customer account balances, active loans, and deposit trends using advanced JOINs, aggregation, and CTEs.
# 🏦 Bank Customer Analytics & SQL Query Portfolio

## 📌 Project Overview
This repository contains a structured set of **advanced SQL queries** designed to perform analytical tasks on a relational banking database. The queries extract key business insights regarding customer behavior, account balance fluctuations, loan risks, deposit trends, and transaction patterns over specific time periods (3 months, 6 months, and 1 year).

---

## Key SQL Concepts & Analytical Skills
* **Complex Data Joining:** Performing multi-table `JOIN` and `LEFT JOIN` operations across `customers`, `accounts`, `transactions`, `loans`, and `deposits` tables.
* **Aggregations & Grouping:** Utilizing aggregate functions (`SUM`, `MAX`, `COUNT`) combined with `GROUP BY` to generate financial summaries.
* **Common Table Expressions (CTEs):** Leveraging `WITH` clauses to structure complex, multi-level queries for month-over-month performance tracking.
* **Null Handling:** Applying `COALESCE` to ensure accurate mathematical calculations for zero-balance or inactive accounts.
* **Time Intelligence & Date Functions:** Dynamic date filtering using `ADD_MONTHS`, `SYSDATE`, and `TO_CHAR` for temporal categorization.

---

## Queries Covered in the Project
1. **Customer Transaction Analysis:** Calculating 6-month aggregate transactions for specific customers.
2. **Account & Loan Balance Overview:** Summarizing active balances and loan liabilities per customer.
3. **Active Deposits & Loan Matching:** Retrieving structured deposit and loan details for active depositors.
4. **Account Activity & Opening History:** Tracking newly opened accounts and their corresponding transaction volumes.
5. **Categorical Transaction Breakdowns:** Grouping annual transactions by type (e.g., transfers, withdrawals).
6. **Peak Monthly Performance:** Identifying most active account days and highest balance growth months using CTEs.
7. **Credit & Loan Duration Tracking:** Analyzing maximum active loan durations and high-value credit applicants.

---

## Repository Structure
* `bank_customer_analytics.sql` – Complete SQL script containing all annotated database queries.
