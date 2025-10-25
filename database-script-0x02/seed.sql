-- Sample data for Airbnb (3NF)
-- Assumes schema from database-script-0x01/schema.sql is applied.
-- Use: psql -d your_db -f seed.sql

BEGIN;

-- Ensure lookup values (use same ids as schema seed expectations)
INSERT INTO roles (role_id, role_name) VALUES
  (1, 'guest'),
  (2, 'host'),
  (3, 'admin')
ON CONFLICT (role_name) DO NOTHING;

INSERT INTO booking_status (status_id, status_name) VALUES
  (1, 'pending'),
  (2, 'confirmed'),
  (3, 'canceled')
ON CONFLICT (status_name) DO NOTHING;

INSERT INTO payment_methods (method_id, method_name) VALUES
  (1, 'credit_card'),
  (2, 'paypal'),
  (3, 'stripe')
ON CONFLICT (method_name) DO NOTHING;

-- Users (explicit UUIDs for predictable FK references)
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role_id, created_at) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Alice', 'Guest', 'alice@example.com', '$2b$10$examplehash1', '+10000000001', 1, now()),
  ('22222222-2222-2222-2222-222222222222', 'Bob', 'Host', 'bob@hosts.com', '$2b$10$examplehash2', '+10000000002', 2, now()),
  ('33333333-3333-3333-3333-333333333333', 'Carol', 'Guest', 'carol@example.com', '$2b$10$examplehash3', '+10000000003', 1, now()),
  ('44444444-4444-4444-4444-444444444444', 'Dave', 'Host', 'dave@hosts.com', '$2b$10$examplehash4', '+10000000004', 2, now()),
  ('99999999-9999-9999-9999-999999999999', 'Eve', 'Admin', 'admin@example.com', '$2b$10$examplehash5', '+10000000009', 3, now())
ON CONFLICT (email) DO NOTHING;

-- Locations
INSERT INTO locations (location_id, city, state, country) VALUES
  (1, 'San Francisco', 'CA', 'USA'),
  (2, 'New York', 'NY', 'USA'),
  (3, 'Lisbon', NULL, 'Portugal')
ON CONFLICT (city, country) DO NOTHING;

-- Properties
INSERT INTO properties (property_id, host_id, name, description, location_id, pricepernight, created_at, updated_at) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', 'Cozy SF Apartment', '1BR near downtown', 1, 100.00, now(), now()),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '44444444-4444-4444-4444-444444444444', 'Luxury Manhattan Loft', '2BR with skyline view', 2, 150.00, now(), now())
ON CONFLICT (property_id) DO NOTHING;

-- Bookings
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status_id, created_at) VALUES
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', '2025-11-01', '2025-11-05', 400.00, 2, now()), -- 4 nights * 100
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '33333333-3333-3333-3333-333333333333', '2025-12-10', '2025-12-12', 300.00, 1, now()), -- 2 nights * 150
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', '2026-01-20', '2026-01-23', 450.00, 1, now()) -- 3 nights * 150
ON CONFLICT (booking_id) DO NOTHING;

-- Payments (one-to-one per booking)
INSERT INTO payments (payment_id, booking_id, amount, payment_date, payment_method_id) VALUES
  ('ffffffff-ffff-ffff-ffff-ffffffffffff', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 400.00, now(), 1),
  ('11112222-3333-4444-5555-666677778888', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 300.00, now(), 2),
  ('99998888-7777-6666-5555-444433332222', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 450.00, now(), 1)
ON CONFLICT (payment_id) DO NOTHING;

-- Reviews (one review per user per property enforced by UNIQUE in schema)
INSERT INTO reviews (review_id, property_id, user_id, rating, comment, created_at) VALUES
  ('22224444-2222-2222-2222-222222220000', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 5, 'Great stay, very clean and central.', now()),
  ('33335555-3333-3333-3333-333333330000', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '33333333-3333-3333-3333-333333333333', 4, 'Fantastic location; a bit noisy at night.', now())
ON CONFLICT (review_id) DO NOTHING;

-- Messages between users
INSERT INTO messages (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
  ('12121212-1212-1212-1212-121212121212', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'Hi Bob — what time is check-in?', now()),
  ('34343434-3434-3434-3434-343434343434', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Hi Alice — self check-in after 3 PM.', now())
ON CONFLICT (message_id) DO NOTHING;

COMMIT;