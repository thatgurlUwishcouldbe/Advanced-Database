USE salesdb;

-- Query 2.4: Total sales by product country, city, and customer nationality
SELECT
    product_country,
    sale_city AS sales_city,
    customer_nationality,
    SUM(total_sales) AS total_sales
FROM olap_sales_view
GROUP BY
    product_country,
    sale_city,
    customer_nationality
ORDER BY
    product_country,
    sale_city,
    customer_nationality;

DELIMITER //

DROP FUNCTION IF EXISTS sales_hierarchy_by_age//

CREATE FUNCTION sales_hierarchy_by_age(p_age INT)
RETURNS JSON
READS SQL DATA
BEGIN
    DECLARE result_json JSON;

    WITH RECURSIVE
    filtered_sales AS (
        SELECT
            product_country,
            sale_city,
            customer_nationality,
            total_sales
        FROM olap_sales_view
        WHERE customer_age = p_age
    ),
    edges AS (
        SELECT
            1 AS parent_level,
            product_country,
            CAST(NULL AS CHAR(50)) AS parent_city,
            sale_city AS child_node,
            2 AS child_level,
            SUM(total_sales) AS total_sales
        FROM filtered_sales
        GROUP BY product_country, sale_city

        UNION ALL

        SELECT
            2 AS parent_level,
            product_country,
            sale_city AS parent_city,
            customer_nationality AS child_node,
            3 AS child_level,
            SUM(total_sales) AS total_sales
        FROM filtered_sales
        GROUP BY product_country, sale_city, customer_nationality
    ),
    roots AS (
        SELECT
            product_country,
            CAST(NULL AS CHAR(100)) AS parent_node,
            product_country AS node,
            1 AS level_no,
            SUM(total_sales) AS total_sales
        FROM filtered_sales
        GROUP BY product_country
    ),
    hierarchy (
        product_country,
        parent_node,
        node,
        level_no,
        total_sales
    ) AS (
        SELECT
            product_country,
            parent_node,
            node,
            level_no,
            total_sales
        FROM roots

        UNION ALL

        SELECT
            e.product_country,
            h.node AS parent_node,
            e.child_node AS node,
            e.child_level AS level_no,
            e.total_sales
        FROM hierarchy AS h
        JOIN edges AS e
        ON e.product_country = h.product_country
        AND e.parent_level = h.level_no
        AND (
                (e.parent_level = 1 AND e.parent_city IS NULL)
                OR
                (e.parent_level = 2 AND e.parent_city = h.node)
             )
    )
    SELECT COALESCE(
        JSON_ARRAYAGG(
            JSON_OBJECT(
                'product_country', product_country,
                'parent_node', parent_node,
                'node', node,
                'level_no', level_no,
                'total_sales', total_sales
            )
        ),
        JSON_ARRAY()
    )
    INTO result_json
    FROM hierarchy;

    RETURN result_json;
END//

DELIMITER ;

-- Execute the parameterized function for the required ages
SELECT 25 AS customer_age, sales_hierarchy_by_age(25) AS hierarchy;
SELECT 35 AS customer_age, sales_hierarchy_by_age(35) AS hierarchy;
SELECT 45 AS customer_age, sales_hierarchy_by_age(45) AS hierarchy;
