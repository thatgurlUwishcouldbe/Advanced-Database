-- Exercise 2(a)
-- Rewrite the following query without using the SQL outer join operation:
-- SELECT * FROM student NATURAL LEFT OUTER JOIN takes;

SELECT
    student.ID,
    student.name,
    student.dept_name,
    student.tot_cred,
    takes.course_id,
    takes.sec_id,
    takes.semester,
    takes.year,
    takes.grade
FROM student
NATURAL JOIN takes

UNION

SELECT
    student.ID,
    student.name,
    student.dept_name,
    student.tot_cred,
    NULL AS course_id,
    NULL AS sec_id,
    NULL AS semester,
    NULL AS year,
    NULL AS grade
FROM student
WHERE student.ID NOT IN (
    SELECT takes.ID
    FROM takes
);


-- Exercise 2(b)
-- Rewrite the following query without using the SQL outer join operation:
-- SELECT * FROM student NATURAL FULL OUTER JOIN takes;

SELECT
    student.ID,
    student.name,
    student.dept_name,
    student.tot_cred,
    takes.course_id,
    takes.sec_id,
    takes.semester,
    takes.year,
    takes.grade
FROM student
NATURAL JOIN takes

UNION

SELECT
    student.ID,
    student.name,
    student.dept_name,
    student.tot_cred,
    NULL AS course_id,
    NULL AS sec_id,
    NULL AS semester,
    NULL AS year,
    NULL AS grade
FROM student
WHERE student.ID NOT IN (
    SELECT takes.ID
    FROM takes
)

UNION

SELECT
    takes.ID,
    NULL AS name,
    NULL AS dept_name,
    NULL AS tot_cred,
    takes.course_id,
    takes.sec_id,
    takes.semester,
    takes.year,
    takes.grade
FROM takes
WHERE takes.ID NOT IN (
    SELECT student.ID
    FROM student
);
