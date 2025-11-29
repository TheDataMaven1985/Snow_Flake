DROP TABLE IF EXISTS dim_customers_scd_type_3;

CREATE TABLE IF NOT EXISTS dim_customers_scd_type_3(
    row_id INT AUTOINCREMENT PRIMARY KEY,
    customer_id INT UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(100),
    previous_phone VARCHAR(100),
    email VARCHAR(100),
    previous_email VARCHAR(100)
);

INSERT INTO dim_customers_scd_type_3(customer_id, first_name, last_name, phone, email)
VALUES
    (101, 'Thomas', 'Shawn', '556-990-789', 'tommyshawn@gmail.com'),
    (102, 'Sarah', 'Williams', '556-302-111', 'sarahwilliam@gmail.com'),
    (103, 'Jacob', 'Johnson', '556-458-990', 'jacobjohnson@gmail.com');

DROP TABLE IF EXISTS staging_customers_scd_type_3;

CREATE TABLE IF NOT EXISTS staging_customers_scd_type_3(
    row_id INT AUTOINCREMENT PRIMARY KEY,
    customer_id INT UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO staging_customers_scd_type_3(customer_id, first_name, last_name, phone, email)
VALUES
    (101, 'Thomas', 'Shawn', '556-000-789', 'tommyshawn@gmail.com'),
    (102, 'jackson', 'Williams', '556-302-111', 'sarahwilliam@gmail.com'),
    (104, 'Ruben', 'Dolphin', '556-781-808', 'rubendolphin@gmail.com');

MERGE INTO dim_customers_scd_type_3 AS target
USING staging_customers_scd_type_3 AS source
ON target.customer_id = source.customer_id
WHEN MATCHED THEN
    UPDATE SET
        target.first_name = source.first_name,
        target.last_name = source.last_name,
        target.previous_phone = target.phone,
        target.phone = source.phone,
        target.previous_email = target.email,
        target.email = source.email

WHEN NOT MATCHED THEN
    INSERT (customer_id, first_name, last_name, phone, previous_phone, email, previous_email)
    VALUES (source.customer_id, source.first_name, source.last_name, source.phone, NULL, source.email, NULL);

-- To verify the results
SELECT * FROM dim_customers_scd_type_3;