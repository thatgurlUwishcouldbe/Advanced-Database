# Lab Worksheet 2 — Introduction to Database

## Purpose

The purpose of this lab is to apply database concepts using the university database schema:

- Creating tables and defining attributes
- Defining primary keys and foreign keys
- Inserting, updating, and deleting records
- Writing SQL queries
- Working with relations and joins
- Connecting Java to PostgreSQL using JDBC

## Database Schema

The database contains the following relations:

- `department`
- `course`
- `instructor`
- `section`
- `teaches`
- `student`
- `takes`

## Exercise 1 — SQL Queries

Write SQL queries using the university database schema.

The exercise covers:

- Using outer joins
- Using scalar subqueries
- Counting instructors and sections
- Handling departments with no instructors
- Grouping and aggregate functions

### Main Concepts

- `LEFT OUTER JOIN` keeps all records from the left table.
- `COUNT(column)` ignores `NULL` values.
- A scalar subquery returns one value for each row.
- `GROUP BY` groups records before applying aggregate functions.

## Exercise 2 — Outer Join

Rewrite outer join queries without using the outer join operation.

The exercise covers:

- Rewriting a left outer join using `INNER JOIN`, `UNION ALL`, and `NOT EXISTS`
- Rewriting a full outer join using matching and non-matching records
- Handling students without course registrations
- Handling records that do not have a matching record in the other relation

## Exercise 3 — JDBC Database Metadata

A Java program was created to display all relations in the university database and print the name and data type of every attribute.

The program uses:

- `Connection`
- `DatabaseMetaData`
- `ResultSet`
- PostgreSQL JDBC Driver

Example output:

```text
Connected successfully!

Relation: department
  Attribute: dept_name | Type: varchar
  Attribute: building | Type: varchar
  Attribute: budget | Type: numeric
