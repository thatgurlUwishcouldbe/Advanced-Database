-- Exercise 2(a)
-- Rewrite the following query without using the SQL outer join operation:
-- SELECT * FROM student NATURAL LEFT OUTER JOIN takes;

SELECT *
FROM student
NATURAL JOIN takes

UNION

SELECT *
FROM student
WHERE ID NOT IN (
    SELECT ID
    FROM takes
);


-- Exercise 2(b)
-- Rewrite the following query without using the SQL outer join operation:
-- SELECT * FROM student NATURAL FULL OUTER JOIN takes;

SELECT *
FROM student
NATURAL JOIN takes

UNION

SELECT *
FROM student
WHERE ID NOT IN (
    SELECT ID
    FROM takes
)

UNION

SELECT *
FROM takes
WHERE ID NOT IN (
    SELECT ID
    FROM student
);
