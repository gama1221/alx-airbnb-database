# ⚙️ Continuous Database Performance Monitoring and Refinement Report

| Section | Detail |
| :--- | :--- |
| **Repository/File** | `alx-airbnb-database/database-adv-script/performance_monitoring.md` |
| **Objective** | Continuously monitor and refine database performance by addressing bottlenecks in frequently executed queries. |
| **Tools Used** | `EXPLAIN` / `EXPLAIN ANALYZE` (simulated analysis based on prior findings) |

---

## 1. 🔍 Monitoring and Bottleneck Identification

Based on analysis of frequently executed queries (like the comprehensive booking details query), two primary bottlenecks were consistently identified, even for small datasets, suggesting poor scaling potential.

### A. Bottleneck 1: Slow Ordering Operation
* **Query Component:** The final `ORDER BY b.id ASC` in the comprehensive booking query.
* **Performance Command Output (Simulated):** `-> Sort: b.id (actual time=0.198..0.199 rows=4 loops=1)`
* **Problem:** The database was performing an explicit, blocking **Sort** operation, which is time-consuming as the result set grows. This indicates a missing or incomplete index to satisfy the ordering requirement.

### B. Bottleneck 2: Inefficient Access to Payments Table
* **Query Component:** The `INNER JOIN payments pm ON b.id = pm.booking_id`
* **Performance Command Output (Simulated):** `-> Table scan on pm (cost=0.65 rows=4)`
* **Problem:** The query started with a **Table Scan** on the `payments` (`pm`) table. While fast for a small table, this method becomes cripplingly slow and resource-intensive once the table contains millions of records, as the Foreign Key (`booking_id`) was not being efficiently used as an access path.

---

## 2. 🛠️ Suggested Schema Adjustments (Implementation)

To address the identified bottlenecks, the following **indexing schema adjustments** were implemented:

### A. Fix for Bottleneck 1: Eliminate Explicit Sort

**Implementation:** Create a covering index on the `bookings` table to satisfy both the join condition and the final ordering.

```sql
-- SQL: Create index on bookings
CREATE INDEX idx_booking_sort ON bookings (id, user_id, property_id);
-- The index starts with 'id' to satisfy the ORDER BY b.id ASC without a separate Sort step.