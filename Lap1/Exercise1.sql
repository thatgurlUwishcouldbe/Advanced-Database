-- Exercise 1(a)
-- Find the titles of courses in the Comp. Sci. department
-- that have 3 credits.

SELECT title
FROM course
WHERE dept_name = 'Comp. Sci.'
  AND credits = 3;


-- Exercise 1(b)
-- Find the IDs of all students who were taught by an instructor
-- named Einstein; make sure there are no duplicates in the result.

SELECT DISTINCT takes.ID
FROM takes
JOIN teaches
    ON takes.course_id = teaches.course_id
    AND takes.sec_id = teaches.sec_id
    AND takes.semester = teaches.semester
    AND takes.year = teaches.year
JOIN instructor
    ON teaches.ID = instructor.ID
WHERE instructor.name = 'Einstein';


-- Exercise 1(c)
-- Find the highest salary of any instructor.

SELECT MAX(salary) AS highest_salary
FROM instructor;


-- Exercise 1(d)
-- Find all instructors earning the highest salary
-- (there may be more than one with the same salary).

SELECT *
FROM instructor
WHERE salary = (
    SELECT MAX(salary)
    FROM instructor
);


-- Exercise 1(e)
-- Find the enrollment of each section that was offered in Autumn 2009.

SELECT
    section.course_id,
    section.sec_id,
    section.semester,
    section.year,
    COUNT(takes.ID) AS enrollment
FROM section
LEFT JOIN takes
    ON section.course_id = takes.course_id
    AND section.sec_id = takes.sec_id
    AND section.semester = takes.semester
    AND section.year = takes.year
WHERE section.semester = 'Fall'
  AND section.year = 2009
GROUP BY
    section.course_id,
    section.sec_id,
    section.semester,
    section.year;


-- Exercise 1(f)
-- Find the maximum enrollment, across all sections, in Autumn 2009.

SELECT MAX(enrollment) AS maximum_enrollment
FROM (
    SELECT
        section.course_id,
        section.sec_id,
        section.semester,
        section.year,
        COUNT(takes.ID) AS enrollment
    FROM section
    LEFT JOIN takes
        ON section.course_id = takes.course_id
        AND section.sec_id = takes.sec_id
        AND section.semester = takes.semester
        AND section.year = takes.year
    WHERE section.semester = 'Fall'
      AND section.year = 2009
    GROUP BY
        section.course_id,
        section.sec_id,
        section.semester,
        section.year
) AS enrollments;


-- Exercise 1(g)
-- Find the sections that had the maximum enrollment in Autumn 2009.

SELECT
    section.course_id,
    section.sec_id,
    section.semester,
    section.year,
    COUNT(takes.ID) AS enrollment
FROM section
LEFT JOIN takes
    ON section.course_id = takes.course_id
    AND section.sec_id = takes.sec_id
    AND section.semester = takes.semester
    AND section.year = takes.year
WHERE section.semester = 'Fall'
  AND section.year = 2009
GROUP BY
    section.course_id,
    section.sec_id,
    section.semester,
    section.year
HAVING COUNT(takes.ID) = (
    SELECT MAX(enrollment)
    FROM (
        SELECT COUNT(takes2.ID) AS enrollment
        FROM section AS section2
        LEFT JOIN takes AS takes2
            ON section2.course_id = takes2.course_id
            AND section2.sec_id = takes2.sec_id
            AND section2.semester = takes2.semester
            AND section2.year = takes2.year
        WHERE section2.semester = 'Fall'
          AND section2.year = 2009
        GROUP BY
            section2.course_id,
            section2.sec_id,
            section2.semester,
            section2.year
    ) AS enrollments
);
