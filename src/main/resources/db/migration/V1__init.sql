-- V1: ERP schema goes here.
-- Flyway runs every V<n>__*.sql file once, in order, and records it in flyway_schema_history.
-- Never edit a migration after it has run; add a new V2__..., V3__... file instead.

CREATE TABLE categories(

    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE

);


CREATE TABLE suppliers(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE

);

CREATE TABLE customers(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    customer_type VARCHAR(20) NOT NULL CHECK (customer_type IN ('individual', 'corporate')),
    created_at DATE NOT NULL
);

CREATE TABLE warehouses(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(100) NOT NULL
);


CREATE TABLE products(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category_id BIGINT NOT NULL REFERENCES categories(id),
    supplier_id BIGINT NOT NULL REFERENCES suppliers(id),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    is_active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE stock(
    warehouse_id BIGINT NOT NULL REFERENCES warehouses(id),
    product_id BIGINT NOT NULL REFERENCES products(id),
    quantity INT NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (warehouse_id, product_id)
);


CREATE TABLE orders(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending','shipped','delivered','cancelled'))

);


CREATE TABLE order_items(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL

);

CREATE TABLE invoices(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE REFERENCES orders(id),
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL,
    paid_at DATE

);