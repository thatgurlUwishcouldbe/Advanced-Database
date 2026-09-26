-- Exercise 2(a)
-- Find the total grade-points earned by the student with ID 12345,
-- across all courses taken by the student.

SELECT SUM(course.credits * grade_points.points) AS total_grade_points
FROM takes
JOIN course
    ON takes.course_id = course.course_id
JOIN grade_points
    ON takes.grade = grade_points.grade
WHERE takes.ID = '12345';


-- Exercise 2(b)
-- Find the grade-point average (GPA) for the student with ID 12345,
-- that is, the total grade-points divided by the total credits
-- for the associated courses.

SELECT
    SUM(course.credits * grade_points.points)
    / SUM(course.credits) AS GPA
FROM takes
JOIN course
    ON takes.course_id = course.course_id
JOIN grade_points
    ON takes.grade = grade_points.grade
WHERE takes.ID = '12345';


-- Exercise 2(c)
-- Find the ID and the grade-point average of every student.

SELECT
    takes.ID,
    SUM(course.credits * grade_points.points)
    / SUM(course.credits) AS GPA
FROM takes
JOIN course
    ON takes.course_id = course.course_id
JOIN grade_points
    ON takes.grade = grade_points.grade
GROUP BY takes.ID;
