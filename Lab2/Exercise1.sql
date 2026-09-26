-- Exercise 1(a)
-- Display a list of all instructors, showing their ID, name,
-- and the number of sections that they have taught.
-- Show 0 for instructors who have not taught any section.
-- Use an outer join and do not use scalar subqueries.

SELECT instructor.ID,
       instructor.name,
       COUNT(teaches.course_id) AS section_count
FROM instructor
LEFT OUTER JOIN teaches
    ON instructor.ID = teaches.ID
GROUP BY instructor.ID, instructor.name;


-- Exercise 1(b)
-- Display the same list of all instructors, their ID, name,
-- and the number of sections that they have taught.
-- Use a scalar subquery and do not use an outer join.

SELECT instructor.ID,
       instructor.name,
       (
           SELECT COUNT(*)
           FROM teaches
           WHERE teaches.ID = instructor.ID
       ) AS section_count
FROM instructor;


-- Exercise 1(c)
-- Display the list of all departments,
-- with the total number of instructors in each department.
-- Do not use scalar subqueries.
-- Correctly handle departments with no instructors.

SELECT department.dept_name,
       COUNT(instructor.ID) AS instructor_count
FROM department
LEFT OUTER JOIN instructor
    ON department.dept_name = instructor.dept_name
GROUP BY department.dept_name;
