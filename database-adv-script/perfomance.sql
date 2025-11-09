-- ----------------------------------------------------------------------
-- Initial Multi-Table Query: Comprehensive Booking Details
-- Repository: alx-airbnb-database
-- Objective: Retrieve all bookings along with user, property, and payment details.
--
-- Logic:
-- Uses INNER JOIN to link all four entities (Bookings, Users, Properties, Payments)
-- ensuring that only bookings that have a corresponding record in ALL four tables are returned.
-- ----------------------------------------------------------------------

SELECT
    -- Booking Details
    b.id AS booking_id,
    b.start_date,
    b.end_date,
    b.num_guests,

    -- User Details
    u.id AS user_id,
    u.first_name,
    u.last_name,
    u.email,

    -- Property Details
    p.id AS property_id,
    p.name AS property_name,
    p.price_per_night,

    -- Payment Details
    pm.id AS payment_id,
    pm.amount,
    pm.payment_date,
    pm.status AS payment_status
FROM
    bookings b
INNER JOIN
    users u ON b.user_id = u.id
INNER JOIN
    properties p ON b.property_id = p.id
INNER JOIN
    payments pm ON b.id = pm.booking_id
ORDER BY
    b.id ASC;