CREATE DATABASE IF NOT EXISTS salesdb;
USE salesdb;

SET FOREIGN_KEY_CHECKS = 0;

DROP VIEW IF EXISTS olap_sales_view;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE customers (
    customer_id INT NOT NULL,
    customer_age INT DEFAULT NULL,
    customer_gender VARCHAR(10) DEFAULT NULL,
    customer_nationality VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (customer_id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE products (
    product_id INT NOT NULL,
    product_category VARCHAR(50) DEFAULT NULL,
    product_country VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (product_id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE sales (
    sale_id INT NOT NULL,
    product_id INT DEFAULT NULL,
    customer_id INT DEFAULT NULL,
    sale_date DATE DEFAULT NULL,
    sale_city VARCHAR(50) DEFAULT NULL,
    total_sales DECIMAL(10,2) DEFAULT NULL,
    PRIMARY KEY (sale_id),
    KEY product_id (product_id),
    KEY customer_id (customer_id),
    CONSTRAINT sales_fk_product
        FOREIGN KEY (product_id) REFERENCES products (product_id),
    CONSTRAINT sales_fk_customer
        FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO customers
    (customer_id, customer_age, customer_gender, customer_nationality)
VALUES
    (1, 25, 'Female', 'Saudi'),
    (2, 35, 'Male', 'Egyptian'),
    (3, 45, 'Female', 'Saudi'),
    (4, 30, 'Male', 'Indian'),
    (5, 25, 'Male', 'Kuwaiti'),
    (6, 35, 'Female', 'Jordanian'),
    (7, 45, 'Male', 'Saudi'),
    (8, 40, 'Female', 'Egyptian');

INSERT INTO products
    (product_id, product_category, product_country)
VALUES
    (1, 'Electronics', 'China'),
    (2, 'Clothing', 'Turkey'),
    (3, 'Furniture', 'Italy'),
    (4, 'Electronics', 'USA'),
    (5, 'Food', 'Saudi Arabia'),
    (6, 'Clothing', 'China'),
    (7, 'Furniture', 'USA'),
    (8, 'Food', 'Italy');

INSERT INTO sales
    (sale_id, product_id, customer_id, sale_date, sale_city, total_sales)
VALUES
    (1, 1, 1, '2025-01-10', 'Riyadh', 3000.00),
    (2, 2, 2, '2025-02-15', 'Jeddah', 500.00),
    (3, 3, 3, '2025-03-20', 'Dammam', 2000.00),
    (4, 4, 4, '2025-04-12', 'Riyadh', 1500.00),
    (5, 5, 5, '2025-05-18', 'Jeddah', 800.00),
    (6, 6, 6, '2025-06-22', 'Makkah', 600.00),
    (7, 7, 7, '2025-07-14', 'Riyadh', 2500.00),
    (8, 8, 8, '2025-08-09', 'Dammam', 900.00),
    (9, 1, 3, '2026-01-11', 'Jeddah', 3500.00),
    (10, 2, 1, '2026-02-16', 'Riyadh', 700.00),
    (11, 3, 5, '2026-03-21', 'Makkah', 2200.00),
    (12, 4, 7, '2026-04-13', 'Dammam', 1800.00),
    (13, 5, 2, '2026-05-19', 'Riyadh', 950.00),
    (14, 6, 4, '2026-06-23', 'Jeddah', 650.00),
    (15, 7, 6, '2026-07-15', 'Makkah', 2700.00),
    (16, 8, 8, '2026-08-10', 'Riyadh', 1100.00),
    (17, 1, 7, '2025-09-12', 'Dammam', 3200.00),
    (18, 3, 2, '2025-10-17', 'Jeddah', 1900.00),
    (19, 5, 3, '2026-09-20', 'Riyadh', 850.00),
    (20, 7, 1, '2026-10-25', 'Makkah', 2600.00);

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
