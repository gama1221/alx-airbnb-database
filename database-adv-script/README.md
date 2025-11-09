Complex Queries with SQL Joins

🎯 Objective

The primary goal of this project is to demonstrate mastery of essential SQL join operations by writing complex queries using INNER JOIN, LEFT JOIN, and FULL OUTER JOIN. These queries simulate common data retrieval scenarios in a relational database, specifically in a platform context similar to Airbnb.

📁 File Structure

This directory contains the following file:

joins_queries.sql: Contains the SQL statements addressing the requirements below.

🔗 Implementation Details

1. INNER JOIN (Bookings and Users)

Requirement: Write a query using an INNER JOIN to retrieve all bookings and the respective users who made those bookings.

Explanation:
The INNER JOIN is used when you only want to return records that have matching values in both tables. This query ensures that every returned booking is correctly associated with an existing user, filtering out any orphaned bookings or users without bookings.

2. LEFT JOIN (Properties and Reviews)

Requirement: Write a query using a LEFT JOIN to retrieve all properties and their reviews, including properties that have no reviews.

Explanation:
The LEFT JOIN (or LEFT OUTER JOIN) is crucial for retaining all records from the left table (properties), even if there are no matching records in the right table (reviews). This is necessary to show a complete list of properties, with review data (or NULL if no review exists) appended where available.

3. FULL OUTER JOIN (Users and Bookings)

Requirement: Write a query using a FULL OUTER JOIN to retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.

Explanation:
The FULL OUTER JOIN returns all records when there is a match in either of the tables. It is used to get a complete view of two datasets, showing:

Users with corresponding bookings.

Users with no bookings (booking fields will be NULL).

Bookings not linked to any user (user fields will be NULL).

Note on Compatibility: If the database system does not natively support FULL OUTER JOIN (e.g., MySQL), the query is implemented using a combination of LEFT JOIN, RIGHT JOIN, and the UNION operator to achieve the same comprehensive result set.
