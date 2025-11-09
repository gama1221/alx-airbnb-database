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


SELECT
    u.id AS user_id,
    u.email,
    b.id AS booking_id,
    b.start_date
FROM
    users AS u
LEFT JOIN
    bookings AS b ON u.id = b.user_id -- Part 1: All users and their bookings
UNION
SELECT
    u.id AS user_id,
    u.email,
    b.id AS booking_id,
    b.start_date
FROM
    users AS u
RIGHT JOIN
    bookings AS b ON u.id = b.user_id -- Part 2: All bookings, including those without a user
WHERE
    u.id IS NULL; -- Ensures we only pick up "unmatched" bookings from the RIGHT JOIN
