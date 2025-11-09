-- 1. INNER JOIN: Retrieve all bookings and the respective users who made those bookings.
-- Only returns rows where a user ID matches a booking's user ID.
SELECT
    b.id AS booking_id,
    b.start_date,
    b.end_date,
    u.id AS user_id,
    u.first_name,
    u.last_name,
    u.email
FROM
    bookings AS b
INNER JOIN
    users AS u ON b.user_id = u.id;

-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews.
-- Returns all properties (left side) and matching reviews (right side), with NULL for unmatched reviews.
SELECT
    p.id AS property_id,
    p.name AS property_name,
    r.id AS review_id,
    r.rating,
    r.comment
FROM
    properties AS p
LEFT JOIN
    reviews AS r ON p.id = r.property_id;

-- 3. FULL OUTER JOIN: Retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.
-- This implementation uses UNION to emulate FULL OUTER JOIN, which is necessary for MySQL/MariaDB.

-- Part A: Get all users and their associated bookings (LEFT JOIN)
SELECT
    u.id AS user_id,
    u.email,
    b.id AS booking_id,
    b.start_date
FROM
    users AS u
LEFT JOIN
    bookings AS b ON u.id = b.user_id
UNION
-- Part B: Get all bookings that are NOT associated with a user (RIGHT JOIN where user is NULL)
SELECT
    u.id AS user_id,
    u.email,
    b.id AS booking_id,
    b.start_date
FROM
    users AS u
RIGHT JOIN
    bookings AS b ON u.id = b.user_id
WHERE
    u.id IS NULL;

-- If your database (e.g., PostgreSQL, SQLite 3.39+) supports the FULL OUTER JOIN keyword,
-- you can replace the entire UNION block above with this single query:
/*
SELECT
    u.id AS user_id,
    u.email,
    b.id AS booking_id,
    b.start_date
FROM
    users AS u
FULL OUTER JOIN
    bookings AS b ON u.id = b.user_id;
*/