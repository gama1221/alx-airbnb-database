-- PostgreSQL schema for Airbnb (3NF). Assumes pgcrypto extension available for UUIDs.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Roles
CREATE TABLE roles (
  role_id SERIAL PRIMARY KEY,
  role_name TEXT NOT NULL UNIQUE
);

-- Users
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name TEXT,
  last_name TEXT,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  phone_number TEXT,
  role_id INTEGER NOT NULL REFERENCES roles(role_id) ON DELETE RESTRICT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Locations
CREATE TABLE locations (
  location_id SERIAL PRIMARY KEY,
  city TEXT NOT NULL,
  state TEXT,
  country TEXT NOT NULL
);

-- Properties
CREATE TABLE properties (
  property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  host_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  location_id INTEGER REFERENCES locations(location_id) ON DELETE SET NULL,
  pricepernight NUMERIC(10,2) NOT NULL CHECK (pricepernight >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ
);

-- Booking status lookup
CREATE TABLE booking_status (
  status_id SERIAL PRIMARY KEY,
  status_name TEXT NOT NULL UNIQUE
);

-- Bookings
CREATE TABLE bookings (
  booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price NUMERIC(10,2) NOT NULL CHECK (total_price >= 0),
  status_id INTEGER NOT NULL REFERENCES booking_status(status_id) ON DELETE RESTRICT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (end_date > start_date)
);

-- Payment methods lookup
CREATE TABLE payment_methods (
  method_id SERIAL PRIMARY KEY,
  method_name TEXT NOT NULL UNIQUE
);

-- Payments (one-to-one to bookings)
CREATE TABLE payments (
  payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id UUID NOT NULL REFERENCES bookings(booking_id) ON DELETE CASCADE UNIQUE,
  amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
  payment_date TIMESTAMPTZ NOT NULL DEFAULT now(),
  payment_method_id INTEGER REFERENCES payment_methods(method_id) ON DELETE RESTRICT
);

-- Reviews
CREATE TABLE reviews (
  review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  rating SMALLINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (property_id, user_id) -- one review per user per property
);

-- Messages
CREATE TABLE messages (
  message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  recipient_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  message_body TEXT NOT NULL,
  sent_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for performance
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_properties_location_id ON properties(location_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_reviews_property_id ON reviews(property_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_recipient_id ON messages(recipient_id);

-- Seed common lookup values (optional)
INSERT INTO roles (role_name) VALUES ('guest'), ('host'), ('admin') ON CONFLICT DO NOTHING;
INSERT INTO booking_status (status_name) VALUES ('pending'), ('confirmed'), ('canceled') ON CONFLICT DO NOTHING;
INSERT INTO payment_methods (method_name) VALUES ('credit_card'), ('paypal'), ('stripe') ON CONFLICT DO NOTHING;