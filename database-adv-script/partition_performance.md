# 📈 Table Partitioning Performance Report

| Section | Detail |
| :--- | :--- |
| **Repository/File** | `alx-airbnb-database/database-adv-script/partition_performance.md` |
| **Table Partitioned** | `bookings` |
| **Partitioning Key** | `start_date` |
| **Partitioning Type** | **RANGE** (e.g., based on `YEAR(start_date)` or quarterly ranges) |

---

## 1. 🎯 Objective

The primary objective was to improve the query performance on the large `bookings` table, specifically for queries involving **date range filters**, by implementing table **RANGE Partitioning** on the `start_date` column.

---

## 2. 🧪 Methodology and Observed Results

Performance was tested using a common query that fetches bookings within a specific time window. The key performance indicator is the reduction in the total amount of data the database engine has to scan.

### Test Query

```sql
SELECT *
FROM bookings
WHERE start_date BETWEEN '2024-04-01' AND '2024-06-30';
```
