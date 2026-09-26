-- Exercise 3(a)
-- Increase the salary of each instructor in the Comp. Sci.
-- department by 10%.

UPDATE instructor
SET salary = salary * 1.10
WHERE dept_name = 'Comp. Sci.';


-- Exercise 3(b)
-- Delete all courses that have never been offered
-- (that is, do not occur in the section relation).

DELETE FROM course
WHERE course_id NOT IN (
    SELECT course_id
    FROM section
);


-- Exercise 3(c)
-- Insert every student whose tot cred attribute is greater than 100
-- as an instructor in the same department, with a salary of $10,000.

INSERT INTO instructor (ID, name, dept_name, salary)
SELECT ID, name, dept_name, 10000
FROM student
WHERE tot_cred > 100;
