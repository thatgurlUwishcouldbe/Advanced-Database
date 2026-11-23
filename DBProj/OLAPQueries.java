import javax.swing.table.DefaultTableModel;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.SwingUtilities;
import javax.swing.table.DefaultTableModel;

public class OLAPQueries {

    // Database connection settings
    private static final String URL = "jdbc:mysql://127.0.0.1:3307/salesdb";

    private static final String USER = "root";

    // Change this value if your MySQL password is different.
    private static final String PASSWORD = "446016988";

    // Query 2.1: Total sales by product category and year
    private static final String Q21 = "SELECT product_category, YEAR(sale_date) AS sale_year, " +
            "SUM(total_sales) AS total_sales " +
            "FROM olap_sales_view " +
            "GROUP BY product_category, YEAR(sale_date) " +
            "ORDER BY product_category, sale_year";

    // Query 2.2: Total sales by category, city, and customer age
    private static final String Q22 = "SELECT product_category, sale_city, customer_age, " +
            "SUM(total_sales) AS total_sales " +
            "FROM olap_sales_view " +
            "GROUP BY product_category, sale_city, customer_age " +
            "ORDER BY product_category, sale_city, customer_age";

    // Query 2.3: Total sales by category, age, gender, and nationality
    private static final String Q23 = "SELECT product_category, customer_age, customer_gender, " +
            "customer_nationality, SUM(total_sales) AS total_sales " +
            "FROM olap_sales_view " +
            "GROUP BY product_category, customer_age, customer_gender, " +
            "customer_nationality " +
            "ORDER BY product_category, customer_age, customer_gender, " +
            "customer_nationality";

    // Query 2.4: Total sales by product country, city, and nationality
    private static final String Q24 = "SELECT product_country, sale_city, customer_nationality, " +
            "SUM(total_sales) AS total_sales " +
            "FROM olap_sales_view " +
            "GROUP BY product_country, sale_city, customer_nationality " +
            "ORDER BY product_country, sale_city, customer_nationality";

    // Recursive hierarchical analysis filtered by customer age
    private static final String HIERARCHY_BY_AGE = "WITH RECURSIVE " +
            "filtered_sales AS ( " +
            "    SELECT product_country, sale_city, customer_nationality, total_sales " +
            "    FROM olap_sales_view " +
            "    WHERE customer_age = ? " +
            "), " +
            "edges AS ( " +
            "    SELECT 1 AS parent_level, " +
            "           product_country, " +
            "           CAST(NULL AS CHAR(50)) AS parent_city, " +
            "           sale_city AS child_node, " +
            "           2 AS child_level, " +
            "           SUM(total_sales) AS total_sales " +
            "    FROM filtered_sales " +
            "    GROUP BY product_country, sale_city " +
            "    UNION ALL " +
            "    SELECT 2 AS parent_level, " +
            "           product_country, " +
            "           sale_city AS parent_city, " +
            "           customer_nationality AS child_node, " +
            "           3 AS child_level, " +
            "           SUM(total_sales) AS total_sales " +
            "    FROM filtered_sales " +
            "    GROUP BY product_country, sale_city, customer_nationality " +
            "), " +
            "roots AS ( " +
            "    SELECT product_country, " +
            "           CAST(NULL AS CHAR(100)) AS parent_node, " +
            "           product_country AS node, " +
            "           1 AS level_no, " +
            "           SUM(total_sales) AS total_sales " +
            "    FROM filtered_sales " +
            "    GROUP BY product_country " +
            "), " +
            "hierarchy (product_country, parent_node, node, level_no, total_sales) AS ( " +
            "    SELECT product_country, parent_node, node, level_no, total_sales " +
            "    FROM roots " +
            "    UNION ALL " +
            "    SELECT e.product_country, h.node, e.child_node, " +
            "           e.child_level, e.total_sales " +
            "    FROM hierarchy AS h " +
            "    JOIN edges AS e " +
            "      ON e.product_country = h.product_country " +
            "     AND e.parent_level = h.level_no " +
            "     AND ((e.parent_level = 1 AND e.parent_city IS NULL) " +
            "       OR (e.parent_level = 2 AND e.parent_city = h.node)) " +
            ") " +
            "SELECT product_country, parent_node, node, level_no, total_sales " +
            "FROM hierarchy " +
            "ORDER BY product_country, level_no, parent_node, node";

    // Connect to the MySQL database
    public static Connection connect() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Execute one of the OLAP queries and return its results as a table model
    public static DefaultTableModel getTableModel(int queryNumber)
            throws SQLException {

        String sql;

        switch (queryNumber) {
            case 1:
                sql = Q21;
                break;
            case 2:
                sql = Q22;
                break;
            case 3:
                sql = Q23;
                break;
            case 4:
                sql = Q24;
                break;
            default:
                throw new IllegalArgumentException(
                        "Select a query number from 1 to 4.");
        }

        try (Connection conn = connect();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            return makeTableModel(rs);
        }
    }

    // Execute the recursive analysis for a selected customer age
    public static DefaultTableModel getHierarchyTableModel(int age)
            throws SQLException {

        try (Connection conn = connect();
                PreparedStatement stmt = conn.prepareStatement(HIERARCHY_BY_AGE)) {

            stmt.setInt(1, age);

            try (ResultSet rs = stmt.executeQuery()) {
                return makeTableModel(rs);
            }
        }
    }

    // Convert a ResultSet into a Swing table model
    private static DefaultTableModel makeTableModel(ResultSet rs)
            throws SQLException {

        ResultSetMetaData meta = rs.getMetaData();
        int columnCount = meta.getColumnCount();

        String[] columnNames = new String[columnCount];

        for (int i = 1; i <= columnCount; i++) {
            columnNames[i - 1] = meta.getColumnLabel(i);
        }

        DefaultTableModel model = new DefaultTableModel(columnNames, 0);

        while (rs.next()) {
            Object[] row = new Object[columnCount];

            for (int i = 1; i <= columnCount; i++) {
                row[i - 1] = rs.getObject(i);
            }

            model.addRow(row);
        }

        return model;
    }

    // Create the Swing user interface
    private static void createWindow() {

        JFrame frame = new JFrame("Sales OLAP Analysis");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(900, 550);
        frame.setLocationRelativeTo(null);

        String[] queryOptions = {
                "Query 2.1: Category and Year",
                "Query 2.2: Category, City, and Age",
                "Query 2.3: Category, Age, Gender, and Nationality",
                "Query 2.4: Product Country, City, and Nationality",
                "Hierarchical Analysis by Age"
        };

        JComboBox<String> queryBox = new JComboBox<>(queryOptions);

        JComboBox<Integer> ageBox = new JComboBox<>(new Integer[] { 25, 35, 45 });

        JButton runButton = new JButton("Run Query");

        JTable resultTable = new JTable();
        JScrollPane scrollPane = new JScrollPane(resultTable);

        JPanel controls = new JPanel(new FlowLayout(FlowLayout.LEFT));
        controls.add(new JLabel("Choose analysis:"));
        controls.add(queryBox);
        controls.add(new JLabel("Customer age:"));
        controls.add(ageBox);
        controls.add(runButton);

        // Enable age selection only for the hierarchical analysis
        ageBox.setEnabled(false);

        queryBox.addActionListener(event -> {
            boolean ageRequired = queryBox.getSelectedIndex() == 4;
            ageBox.setEnabled(ageRequired);
        });

        runButton.addActionListener(event -> {
            try {
                int selected = queryBox.getSelectedIndex();
                DefaultTableModel model;

                if (selected == 4) {
                    int age = (Integer) ageBox.getSelectedItem();
                    model = getHierarchyTableModel(age);
                } else {
                    model = getTableModel(selected + 1);
                }

                resultTable.setModel(model);

                if (model.getRowCount() == 0) {
                    JOptionPane.showMessageDialog(
                            frame,
                            "No results were found for this selection.");
                }

            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(
                        frame,
                        "Unable to connect or execute the query:\n" +
                                ex.getMessage(),
                        "Database Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        });

        frame.add(controls, BorderLayout.NORTH);
        frame.add(scrollPane, BorderLayout.CENTER);
        frame.setVisible(true);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(OLAPQueries::createWindow);
    }
}
