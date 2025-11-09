Index Implementation and Performance MeasurementThe goal of creating indexes is to drastically reduce the amount of data the database system has to scan to fulfill a query, thereby speeding up execution time.1. Measurement Tool: EXPLAIN (or ANALYZE)You can measure query performance by prefixing the query with the EXPLAIN keyword.EXPLAIN: Shows the Query Plan—how the database intends to execute the query. It tells you if an index is being used (e.g., Index Scan or Index Only Scan) or if it's falling back to a slow full table scan (Full Scan or Table Scan).EXPLAIN ANALYZE (Recommended): Runs the query and then shows the Query Plan, including the actual execution time, rows returned, and other real-world statistics.2. Step-by-Step Performance TestFollow these steps to demonstrate the impact of the indexes created in database_index.sql:Step 1: Pre-Index Performance CheckBefore running the CREATE INDEX commands (or if you can drop them), execute one of the complex queries you wrote earlier, prefixing it with EXPLAIN ANALYZE.Example Query (Total Bookings Per User from aggregations_and_window_functions.sql):EXPLAIN ANALYZE
SELECT
    u.id AS user_id,
    u.email,
    COUNT(b.id) AS total_bookings
FROM
    users u
JOIN
    bookings b ON u.id = b.user_id
GROUP BY
    u.id, u.email
ORDER BY
    total_bookings DESC;
Observation: Look for Full Scan or Table Scan on the bookings table. Note the final Execution Time.Step 2: Apply IndexesRun the commands in the database_index.sql file to create all the necessary indexes.-- Run all commands from database_index.sql
-- For example: CREATE INDEX idx_bookings_user_id ON bookings (user_id);
Step 3: Post-Index Performance CheckRun the exact same query again, using EXPLAIN ANALYZE.Example Query (Total Bookings Per User):EXPLAIN ANALYZE
SELECT
    u.id AS user_id,
    u.email,
    COUNT(b.id) AS total_bookings
FROM
    users u
JOIN
    bookings b ON u.id = b.user_id
GROUP BY
    u.id, u.email
ORDER BY
    total_bookings DESC;
Observation: The plan should now show Index Scan or Index Only Scan being used on the bookings table for the join operation. Compare the new Execution Time with the pre-index time; it should be significantly lower, especially on large datasets.3. High-Usage Columns Identified for IndexingThe following columns were identified based on their frequent use in JOIN, WHERE, and GROUP BY operations across the previous queries:TableColumnIndex NamePrimary Query Use Casebookingsuser_ididx_bookings_user_idForeign Key for User/Booking JOIN (Correlated Subquery, Aggregation Query 1).bookingsproperty_ididx_bookings_property_idForeign Key for Property/Booking JOIN (Aggregation Query 2).reviewsproperty_ididx_reviews_property_idForeign Key for Property/Review JOIN (Non-Correlated Subquery 1).reviewsratingidx_reviews_ratingUsed in the HAVING clause for average rating filtering.usersemailidx_users_emailUsed for fast user lookups/searches.