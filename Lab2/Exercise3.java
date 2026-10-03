-- Exercise 3
-- Write a Java function using JDBC metadata features
-- that prints a list of all relations in the database.
-- For each relation, display the names and types of its attributes.

package database;

import java.sql.*;

public class University {

    public static void main(String[] args) {
        // استدعاء الداتابيس

        try (Connection conn = DriverManager.getConnection(
            "jdbc:postgresql://ep-lively-bonus-b40shv7a-pooler.c-6.us-east-2.aws.neon.tech:5432/university?sslmode=require"
            ,"neondb_owner"
            ,"npg_XVgudZTcCE07")) {

            // System.out.println("Connected successfully!");

            // الميثود اللي انا سويت
            printDatabaseMetadata(conn);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void printDatabaseMetadata(Connection conn) throws SQLException {

        DatabaseMetaData metadata = conn.getMetaData();

        try (ResultSet tables = metadata.getTables(null, "public", "%", new String[] { "TABLE" })) {

            while (tables.next()) {

                String tableName = tables.getString("TABLE_NAME");

                System.out.println("Relation: " + tableName);

                try (ResultSet columns = metadata.getColumns(null, "public", tableName, "%")) {

                    while (columns.next()) {

                        String columnName = columns.getString("COLUMN_NAME");

                        String columnType = columns.getString("TYPE_NAME");

                        System.out.println("  Attribute: " + columnName + " | Type: " + columnType);
                    }
                }

                System.out.println();
            }
        }
