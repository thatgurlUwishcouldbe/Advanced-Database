USE salesdb;

CREATE OR REPLACE VIEW olap_sales_view AS
SELECT
    s.sale_id,
    s.sale_date,
    s.sale_city,
    s.total_sales,
    p.product_category,
    p.product_country,
    c.customer_age,
    c.customer_gender,
    c.customer_nationality
FROM sales AS s
JOIN products AS p
    ON s.product_id = p.product_id
JOIN customers AS c
    ON s.customer_id = c.customer_id;

-- Query 2.1: Total sales by product category and year
SELECT
    product_category,
    YEAR(sale_date) AS sale_year,
    SUM(total_sales) AS total_sales
FROM olap_sales_view
GROUP BY product_category, YEAR(sale_date)
ORDER BY product_category, sale_year;

-- Query 2.2: Total sales by product category, city, and customer age
SELECT
    product_category,
    sale_city,
    customer_age,
    SUM(total_sales) AS total_sales
FROM olap_sales_view
GROUP BY product_category, sale_city, customer_age
ORDER BY product_category, sale_city, customer_age;

-- Query 2.3: Total sales by category, age, gender, and nationality
SELECT
    product_category,
    customer_age,
    customer_gender,
    customer_nationality,
    SUM(total_sales) AS total_sales
FROM olap_sales_view
GROUP BY
    product_category,
    customer_age,
    customer_gender,
    customer_nationality
ORDER BY
    product_category,
    customer_age,
    customer_gender,
    customer_nationality;
