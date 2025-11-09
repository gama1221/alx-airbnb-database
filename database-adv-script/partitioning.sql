-- partitioning.sql

-- 1. Create a new partitioned table (assuming 'bookings_partitioned' is the new name).
-- NOTE: If using an existing table, you would use ALTER TABLE ... PARTITION BY...
-- For demonstration, we use a hypothetical structure similar to the original bookings table.

-- Drop the table if it already exists (for testing/recreation)
DROP TABLE IF EXISTS bookings_partitioned;

-- Create the Bookings table with RANGE partitioning on the year of 'start_date'
CREATE TABLE bookings_partitioned (
    id INT NOT NULL,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    num_guests INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id, start_date) -- Primary Key must include the partitioning column
)
PARTITION BY RANGE ( YEAR(start_date) ) (
    -- Partition for all historical data up to the end of 2023
    PARTITION p_2023_backlog VALUES LESS THAN (2024),
    -- Partitions for 2024 (e.g., quarterly)
    PARTITION p_2024_q1 VALUES LESS THAN (2024 * 100 + 4), -- Placeholder for quarterly if using months
    PARTITION p_2024_q2 VALUES LESS THAN (2024 * 100 + 7),
    PARTITION p_2024_q3 VALUES LESS THAN (2024 * 100 + 10),
    PARTITION p_2024_q4 VALUES LESS THAN (2025),
    -- Partition for future bookings (catch-all)
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 2. Migrate existing data (optional step, but necessary for a large table)
-- INSERT INTO bookings_partitioned SELECT * FROM bookings;

-- 3. Example query to test performance (should only scan the relevant partition/s)
EXPLAIN
SELECT *
FROM bookings_partitioned
WHERE start_date BETWEEN '2024-04-01' AND '2024-06-30' -- Should only scan p_2024_q2
ORDER BY id;