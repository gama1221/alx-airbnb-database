EXPLAIN ANALYZE
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

CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_reviews_property_id ON reviews(property_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);
CREATE INDEX idx_users_email ON users(email);

EXPLAIN ANALYZE
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



