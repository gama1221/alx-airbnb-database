# Database-script-0x02 — Seed data

This directory contains sample data for the Airbnb clone schema.

Files:
- seed.sql — INSERT statements for roles, users, locations, properties, bookings, payments, reviews, and messages.
- [Seed Script](./seed.sql)

Usage:
1. Ensure the schema is applied (database-script-0x01/schema.sql).
2. psql -d your_db -f database-script-0x02/seed.sql
3. Adjust UUIDs/dates/amounts if you need