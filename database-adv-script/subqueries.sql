-- ----------------------------------------------------------------------
-- SQL Subqueries Practice
-- Repository: alx-airbnb-database
-- Objective: Write both correlated and non-correlated subqueries.
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- QUERY 1: Non-Correlated Subquery
-- Find all properties where the average rating is greater than 4.0.
--
-- Logic:
-- 1. The inner subquery calculates the average rating for every property
--    and filters for only those properties where the average is > 4.0.
-- 2. The outer query then selects the property details (ID and Name)
--    from the main 'properties' table, matching the IDs returned by the subquery.
-- ----------------------------------------------------------------------

SELECT
    p.id,
    p.name
FROM
    properties p
WHERE
    p.id IN (
        SELECT
            r.property_id
        FROM
            reviews r
        GROUP BY
            r.property_id
        HAVING
            AVG(r.rating) > 4.0
    );


-- ----------------------------------------------------------------------
-- QUERY 2: Correlated Subquery
-- Find users who have made more than 3 bookings.
--
-- Logic:
-- 1. The outer query selects rows from the 'users' table (aliased as 'u').
-- 2. The inner subquery executes ONCE FOR EACH ROW in the outer query.
--    It counts the total number of bookings in the 'bookings' table (aliased as 'b')
--    WHERE the user_id in the 'bookings' table MATCHES the user's ID
--    from the current row of the outer 'users' table (b.user_id = u.id).
-- 3. The outer WHERE clause then filters the users where the COUNT returned
--    by the subquery is greater than 3.
-- ----------------------------------------------------------------------

SELECT
    u.id,
    u.email
FROM
    users u
WHERE
    (
        SELECT
            COUNT(b.id)
        FROM
            bookings b
        WHERE
            b.user_id = u.id -- This is the correlation condition
    ) > 3;