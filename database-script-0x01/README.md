<!-- ...existing code... -->
# Database-script-0x01

This directory contains the SQL schema for the Airbnb clone (**3NF**).

Files:
- schema.sql — CREATE TABLE statements, constraints, indexes, and optional seed values.
- Files [Schema File](./schema.sql)

Usage:
1. psql -d your_db -f schema.sql
2. Ensure extension pgcrypto is enabled (the script creates it if missing).
3. Adjust ON DELETE behavior or data types if your deployment requires different semantics.
