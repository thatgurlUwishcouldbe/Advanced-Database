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


-- Exercise 3
-- Write a Java function using JDBC metadata features
-- that prints a list of all relations in the database.
-- For each relation, display the names and types of its attributes.

public static void printDatabaseMetadata(Connection conn) throws SQLException {

    DatabaseMetaData metadata = conn.getMetaData();

    ResultSet tables = metadata.getTables(
        null,
        null,
        "%",
        new String[]{"TABLE"}
    );

    while (tables.next()) {

        String tableName = tables.getString("TABLE_NAME");

        System.out.println("Relation: " + tableName);

        ResultSet columns = metadata.getColumns(
            null,
            null,
            tableName,
            "%"
        );

        while (columns.next()) {

            String columnName = columns.getString("COLUMN_NAME");
            String columnType = columns.getString("TYPE_NAME");

            System.out.println(
                "  Attribute: " + columnName +
                " | Type: " + columnType
            );
        }

        columns.close();

        System.out.println();
    }

    tables.close();
}
