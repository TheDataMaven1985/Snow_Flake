DROP TABLE IF EXISTS dim_customers_scd_type_2;

CREATE TABLE dim_customers_scd_type_2(
    row_id INT AUTOINCREMENT PRIMARY KEY,
    customer_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(50),
    start_date DATE DEFAULT CURRENT_DATE,
    end_date DATE DEFAULT NULL,
    is_current CHAR(1) DEFAULT 'Y'
);

INSERT INTO dim_customers_scd_type_2 (customer_id, first_name, last_name, phone, email)
VALUES 
    (1001, 'John', 'Doe', '555-1234', 'john.doe@example.com'),
    (1002, 'Jane', 'Smith', '555-5678', 'jane.smith@example.com'),
    (1003, 'James', 'Brown', '555-8765', 'james.brown@example.com');

DROP TABLE IF EXISTS staging_customers_scd_type_2;

CREATE TABLE staging_customers_scd_type_2(
    row_id INT AUTOINCREMENT PRIMARY KEY,
    customer_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(50)
);

INSERT INTO staging_customers_scd_type_2 (customer_id, first_name, last_name, phone, email)
VALUES 
    (1001, 'John', 'Doe', '555-0254', 'john.doe@example.com'),
    (1002, 'Esther', 'Smith', '555-5008', 'esther.smith@example.com'),
    (1004, 'Bella', 'Grey', '555-1019', 'bella.grey@example.com');

-- close old records
UPDATE dim_customers_scd_type_2
SET
    end_date = CURRENT_DATE,
    is_current = 'N'
WHERE customer_id IN(
    SELECT s.customer_id
    FROM staging_customers_scd_type_2 s
    JOIN dim_customers_scd_type_2 d
        ON s.customer_id = d.customer_id
        AND d.is_current = 'Y'
    WHERE
        COALESCE(s.first_name, '') <> COALESCE(d.first_name, '') OR
        COALESCE(s.last_name, '') <> COALESCE(d.last_name, '') OR
        COALESCE(s.phone, '') <> COALESCE(d.phone, '') OR
        COALESCE(s.email, '') <> COALESCE(d.email, '')
);

-- insert new records
INSERT INTO dim_customers_scd_type_2(
    customer_id,
    first_name,
    last_name,
    phone,
    email,
    start_date,
    end_date,
    is_current
)
SELECT
    s.customer_id,
    s.first_name,
    s.last_name,
    s.phone,
    s.email,
    CURRENT_DATE,
    NULL,
    'Y'
FROM staging_customers_scd_type_2 s
LEFT JOIN dim_customers_scd_type_2 d
    ON s.customer_id = d.customer_id
    AND d.is_current = 'Y'
WHERE
    d.customer_id is NULL
    OR(
        COALESCE(s.first_name, '') <> COALESCE(d.first_name, '') OR
        COALESCE(s.last_name, '') <> COALESCE(d.last_name, '') OR
        COALESCE(s.phone, '') <> COALESCE(d.phone, '') OR
        COALESCE(s.email, '') <> COALESCE(d.email, '')
       );

-- To verify the results
SELECT * FROM dim_customers_scd_type_2;