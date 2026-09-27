-- Exercise 3
-- Write a Java function using JDBC metadata features
-- that prints a list of all relations in the database.
-- For each relation, display the names and types of its attributes.

    package database;

import java.sql.*;

public class University {

    public static void main(String[] args) throws Exception {

        String url =
            "jdbc:postgresql://ep-lively-bonus-b40shv7a-pooler.c-6.us-east-2.aws.neon.tech:5432/university?sslmode=require";

        String username = "neondb_owner";
        String password = "PASSWORD";

        Connection conn =
            DriverManager.getConnection(url, username, password);

        System.out.println("Connected successfully!");

        DatabaseMetaData metadata = conn.getMetaData();

        ResultSet tables = metadata.getTables(
            null,
            "public",
            "%",
            new String[]{"TABLE"}
        );

        while (tables.next()) {

            String tableName =
                tables.getString("TABLE_NAME");

            System.out.println("\nRelation: " + tableName);

            ResultSet columns = metadata.getColumns(
                null,
                "public",
                tableName,
                "%"
            );

            while (columns.next()) {

                String columnName =
                    columns.getString("COLUMN_NAME");

                String columnType =
                    columns.getString("TYPE_NAME");

                System.out.println(
                    "  Attribute: " + columnName +
                    " | Type: " + columnType
                );
            }

            columns.close();

            System.out.println("  Data:");

            Statement statement = conn.createStatement();

            ResultSet data = statement.executeQuery(
                "SELECT * FROM public.\"" +
                tableName.replace("\"", "\"\"") +
                "\""
            );

            ResultSetMetaData dataMetadata =
                data.getMetaData();

            int columnCount =
                dataMetadata.getColumnCount();

            while (data.next()) {

                for (int i = 1; i <= columnCount; i++) {

                    System.out.print(
                        dataMetadata.getColumnName(i) +
                        "=" +
                        data.getObject(i)
                    );

                    if (i < columnCount) {
                        System.out.print(" | ");
                    }
                }

                System.out.println();
            }

            data.close();
            statement.close();
        }

        tables.close();
        conn.close();
    }
}
