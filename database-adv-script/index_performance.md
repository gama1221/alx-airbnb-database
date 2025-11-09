-- ----------------------------------------------------------------------
-- SQL Index Implementation for Optimization
-- Repository: alx-airbnb-database
-- Objective: Create indexes on high-usage columns to improve query performance.
-- ----------------------------------------------------------------------

-- Indexing Strategy:
-- 1. Foreign Keys: Essential for speeding up JOIN operations (e.g., user_id in bookings).
-- 2. Frequently Searched/Filtered Columns: Columns used in WHERE clauses (e.g., property_id in reviews).
-- 3. Frequently Sorted Columns: Columns used in ORDER BY (e.g., rating, total_bookings calculation).

-- ----------------------------------------------------------------------
-- 1. Bookings Table Indexes (High usage in JOINs, WHERE, and COUNT aggregations)
-- ----------------------------------------------------------------------

-- Index on the user_id column in the bookings table.
-- This is critical for optimizing lookups when joining users to their bookings (e.g., Query 1 from aggregations).
CREATE INDEX idx_bookings_user_id ON bookings (user_id);

-- Index on the property_id column in the bookings table.
-- This is critical for optimizing lookups when joining properties to their bookings (e.g., Query 2 from aggregations).
CREATE INDEX idx_bookings_property_id ON bookings (property_id);

-- ----------------------------------------------------------------------
-- 2. Reviews Table Indexes (Used for filtering and aggregation in subqueries)
-- ----------------------------------------------------------------------

-- Index on the property_id column in the reviews table.
-- Essential for calculating average ratings per property (Subquery 1 from subqueries.sql).
CREATE INDEX idx_reviews_property_id ON reviews (property_id);

-- Index on the rating column in the reviews table.
-- Helpful if filtering by rating is a common operation.
CREATE INDEX idx_reviews_rating ON reviews (rating);

-- ----------------------------------------------------------------------
-- 3. Users Table Indexes (Used in JOINs and searches)
-- ----------------------------------------------------------------------

-- Index on the email column in the users table.
-- Useful for fast lookups if users frequently log in or are searched by email.
CREATE INDEX idx_users_email ON users (email);

-- ----------------------------------------------------------------------
-- Note: Indexes on Primary Keys (like 'id') are typically created automatically by the database.
-- These commands cover the most frequently used Foreign Keys and Search/Sort columns.
-- ----------------------------------------------------------------------