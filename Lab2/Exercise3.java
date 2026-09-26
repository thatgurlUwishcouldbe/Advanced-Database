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
