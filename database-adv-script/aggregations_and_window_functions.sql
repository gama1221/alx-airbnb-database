-- ----------------------------------------------------------------------
-- SQL Aggregation and Window Functions Practice
-- Repository: alx-airbnb-database
-- Objective: Use COUNT, GROUP BY, and Window Functions (ROW_NUMBER/RANK).
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- QUERY 1: Aggregation (COUNT and GROUP BY)
-- Find the total number of bookings made by each user.
--
-- Logic:
-- 1. Select the user's identification (ID and Email).
-- 2. Use COUNT(b.id) to count the number of booking records.
-- 3. Use GROUP BY to ensure the count is performed separately for each unique user.
-- 4. ORDER BY the count in descending order to see the most frequent bookers first.
-- ----------------------------------------------------------------------
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


-- ----------------------------------------------------------------------
-- QUERY 2: Window Function (RANK)
-- Rank properties based on the total number of bookings they have received.
--
-- Logic:
-- 1. Use a Common Table Expression (CTE) to first calculate the total bookings per property.
-- 2. In the main query, use the RANK() window function over the CTE result set.
-- 3. The ranking is based on the total_bookings column in descending order.
-- 4. RANK() assigns the same rank to properties with an identical number of bookings (ties).
--    (Note: ROW_NUMBER() could also be used but it handles ties by assigning unique, sequential numbers).
-- ----------------------------------------------------------------------
WITH PropertyBookingCounts AS (
    -- 1. Calculate total bookings for each property
    SELECT
        p.id AS property_id,
        p.name AS property_name,
        COUNT(b.id) AS total_bookings
    FROM
        properties p
    JOIN
        bookings b ON p.id = b.property_id
    GROUP BY
        p.id, p.name
)
SELECT
    property_id,
    property_name,
    total_bookings,
    -- Apply the window function to rank properties by booking count
    RANK() OVER (ORDER BY total_bookings DESC) AS booking_rank
FROM
    PropertyBookingCounts
ORDER BY
    booking_rank ASC, total_bookings DESC;