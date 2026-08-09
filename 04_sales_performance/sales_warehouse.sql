-- =========================================================
-- 1. CREATE SCHEMA
-- =========================================================

CREATE SCHEMA sales_analytics;


-- =========================================================
-- 2. CREATE TABLES
-- =========================================================

-- Customers
CREATE TABLE sales_analytics.dim_customers
(
    customer_id      TEXT NOT NULL,
    customer_name    TEXT,
    industry         TEXT,
    customer_size    TEXT,
    territory_id     TEXT,
    active_since     DATE
);

-- Date dimension
CREATE TABLE sales_analytics.dim_date
(
    date_key         INTEGER NOT NULL,
    full_date        DATE NOT NULL,
    year             INTEGER NOT NULL,
    quarter          VARCHAR(2) NOT NULL,
    month_number     INTEGER NOT NULL,
    month_name       VARCHAR(20) NOT NULL,
    day_number       INTEGER NOT NULL,
    day_name         VARCHAR(20) NOT NULL,
    week_number      INTEGER NOT NULL,
    is_weekend       BOOLEAN NOT NULL,
    month_year       VARCHAR(8),
    month_year_sort  INTEGER
);

-- Products
CREATE TABLE sales_analytics.dim_products
(
    product_id        TEXT NOT NULL,
    product_name      TEXT,
    category          TEXT,
    subcategory       TEXT,
    product_line      TEXT,
    complexity_level  TEXT
);

-- Sales representatives
CREATE TABLE sales_analytics.dim_sales_reps
(
    sales_rep_id  TEXT NOT NULL,
    first_name    TEXT,
    last_name     TEXT,
    territory_id  TEXT,
    hire_date     DATE
);

-- Territories
CREATE TABLE sales_analytics.dim_territories
(
    territory_id  TEXT NOT NULL,
    territory_name TEXT,
    region         TEXT
);

-- Sales orders
-- Grain: one row per customer order
CREATE TABLE sales_analytics.sales_orders
(
    order_id     TEXT NOT NULL,
    order_date   DATE,
    customer_id  TEXT,
    sales_rep_id TEXT,
    territory_id TEXT
);

-- Sales order lines
-- Grain: one row per product line within an order
CREATE TABLE sales_analytics.sales_order_lines
(
    sales_line_id  INTEGER NOT NULL,
    order_id       TEXT,
    line_number    INTEGER,
    product_id     TEXT,
    quantity       INTEGER,
    unit_price     NUMERIC(10,2),
    unit_cost      NUMERIC(10,2),
    discount_pct   NUMERIC(5,4),
    extended_sales NUMERIC(12,2),
    extended_cost  NUMERIC(12,2),
    gross_profit   NUMERIC(12,2)
);

-- Fact sales
-- Grain: one row per sales transaction line
CREATE TABLE sales_analytics.fact_sales
(
    sale_id        INTEGER NOT NULL,
    order_id       TEXT,
    order_date     DATE,
    customer_id    TEXT,
    sales_rep_id   TEXT,
    territory_id   TEXT,
    product_id     TEXT,
    quantity       INTEGER,
    unit_price     NUMERIC(10,2),
    discount_pct   NUMERIC(5,4),
    unit_cost      NUMERIC(10,2),
    extended_sales NUMERIC(12,2),
    extended_cost  NUMERIC(12,2),
    gross_profit   NUMERIC(12,2),
    date_key       INTEGER
);

-- Product cost history
-- Tracks changes in product cost over time
CREATE TABLE sales_analytics.product_cost_history
(
    product_id     TEXT NOT NULL,
    effective_date DATE NOT NULL,
    unit_cost      NUMERIC(10,2)
);

-- Product price history
-- Tracks changes in selling price over time
CREATE TABLE sales_analytics.product_price_history
(
    product_id     TEXT NOT NULL,
    effective_date DATE NOT NULL,
    list_price     NUMERIC(10,2)
);

-- Industry product bundle
-- Defines recommended product combinations by industry
CREATE TABLE sales_analytics.industry_product_bundle
(
    industry             TEXT NOT NULL,
    primary_product_id   TEXT,
    secondary_product_id TEXT,
    accessory_product_id TEXT
);

-- Sales order activity
-- Monthly customer order activity summary
CREATE TABLE sales_analytics.sales_order_activity
(
    activity_id INTEGER NOT NULL,
    order_month DATE,
    customer_id TEXT,
    order_count INTEGER
);

-- Order line counts
-- Helper table used to count lines per order
CREATE TABLE sales_analytics.order_line_counts
(
    order_id  TEXT,
    line_count INTEGER
);


-- =========================================================
-- 3. ADD CONSTRAINTS
-- =========================================================

-- Primary keys

ALTER TABLE sales_analytics.dim_customers
ADD PRIMARY KEY (customer_id);

ALTER TABLE sales_analytics.dim_date
ADD PRIMARY KEY (date_key);

ALTER TABLE sales_analytics.dim_products
ADD PRIMARY KEY (product_id);

ALTER TABLE sales_analytics.dim_sales_reps
ADD PRIMARY KEY (sales_rep_id);

ALTER TABLE sales_analytics.dim_territories
ADD PRIMARY KEY (territory_id);

ALTER TABLE sales_analytics.fact_sales
ADD PRIMARY KEY (sale_id);

ALTER TABLE sales_analytics.industry_product_bundle
ADD PRIMARY KEY (industry);

ALTER TABLE sales_analytics.product_cost_history
ADD PRIMARY KEY (product_id, effective_date);

ALTER TABLE sales_analytics.product_price_history
ADD PRIMARY KEY (product_id, effective_date);

ALTER TABLE sales_analytics.sales_order_activity
ADD PRIMARY KEY (activity_id);

ALTER TABLE sales_analytics.sales_order_lines
ADD PRIMARY KEY (sales_line_id);

ALTER TABLE sales_analytics.sales_orders
ADD PRIMARY KEY (order_id);


-- Foreign keys

-- Fact sales

ALTER TABLE sales_analytics.fact_sales
ADD CONSTRAINT fk_fact_sales_customer
FOREIGN KEY (customer_id)
REFERENCES sales_analytics.dim_customers(customer_id);

ALTER TABLE sales_analytics.fact_sales
ADD CONSTRAINT fk_fact_sales_product
FOREIGN KEY (product_id)
REFERENCES sales_analytics.dim_products(product_id);

ALTER TABLE sales_analytics.fact_sales
ADD CONSTRAINT fk_fact_sales_sales_rep
FOREIGN KEY (sales_rep_id)
REFERENCES sales_analytics.dim_sales_reps(sales_rep_id);

ALTER TABLE sales_analytics.fact_sales
ADD CONSTRAINT fk_fact_sales_territory
FOREIGN KEY (territory_id)
REFERENCES sales_analytics.dim_territories(territory_id);

ALTER TABLE sales_analytics.fact_sales
ADD CONSTRAINT fk_fact_sales_date
FOREIGN KEY (date_key)
REFERENCES sales_analytics.dim_date(date_key);


-- Sales orders

ALTER TABLE sales_analytics.sales_orders
ADD CONSTRAINT fk_sales_orders_customer
FOREIGN KEY (customer_id)
REFERENCES sales_analytics.dim_customers(customer_id);

ALTER TABLE sales_analytics.sales_orders
ADD CONSTRAINT fk_sales_orders_sales_rep
FOREIGN KEY (sales_rep_id)
REFERENCES sales_analytics.dim_sales_reps(sales_rep_id);

ALTER TABLE sales_analytics.sales_orders
ADD CONSTRAINT fk_sales_orders_territory
FOREIGN KEY (territory_id)
REFERENCES sales_analytics.dim_territories(territory_id);


-- Sales order lines

ALTER TABLE sales_analytics.sales_order_lines
ADD CONSTRAINT fk_sales_order_lines_order
FOREIGN KEY (order_id)
REFERENCES sales_analytics.sales_orders(order_id);

ALTER TABLE sales_analytics.sales_order_lines
ADD CONSTRAINT fk_sales_order_lines_product
FOREIGN KEY (product_id)
REFERENCES sales_analytics.dim_products(product_id);


-- Product history

ALTER TABLE sales_analytics.product_cost_history
ADD CONSTRAINT fk_product_cost_history_product
FOREIGN KEY (product_id)
REFERENCES sales_analytics.dim_products(product_id);

ALTER TABLE sales_analytics.product_price_history
ADD CONSTRAINT fk_product_price_history_product
FOREIGN KEY (product_id)
REFERENCES sales_analytics.dim_products(product_id);


-- Customer activity

ALTER TABLE sales_analytics.sales_order_activity
ADD CONSTRAINT fk_sales_order_activity_customer
FOREIGN KEY (customer_id)
REFERENCES sales_analytics.dim_customers(customer_id);


-- =========================================================
-- 4. LOAD DIMENSIONS AND REFERENCE DATA
-- =========================================================

-- Date dimension

INSERT INTO sales_analytics.dim_date
(
    date_key,
    full_date,
    year,
    quarter,
    month_number,
    month_name,
    day_number,
    day_name,
    week_number,
    is_weekend,
    month_year,
    month_year_sort
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INTEGER,
    d,
    EXTRACT(YEAR FROM d)::INTEGER,
    'Q' || EXTRACT(QUARTER FROM d)::INTEGER,
    EXTRACT(MONTH FROM d)::INTEGER,
    TRIM(TO_CHAR(d, 'Month')),
    EXTRACT(DAY FROM d)::INTEGER,
    TRIM(TO_CHAR(d, 'Day')),
    EXTRACT(WEEK FROM d)::INTEGER,
    CASE
        WHEN EXTRACT(ISODOW FROM d) IN (6,7)
        THEN TRUE
        ELSE FALSE
    END,
    TO_CHAR(d, 'Mon YYYY'),
    TO_CHAR(d, 'YYYYMM')::INTEGER
FROM generate_series(
    '2024-01-01'::DATE,
    '2025-12-31'::DATE,
    INTERVAL '1 day'
) AS d;


-- Product cost history

COPY sales_analytics.product_cost_history
FROM 'path/product_cost_history.csv'
WITH (
    FORMAT csv,
    HEADER true
);


-- Product price history

COPY sales_analytics.product_price_history
FROM 'path/product_price_history.csv'
WITH (
    FORMAT csv,
    HEADER true
);


-- =========================================================
-- 5. LOAD FACT TABLE
-- =========================================================

TRUNCATE TABLE sales_analytics.fact_sales;

INSERT INTO sales_analytics.fact_sales
(
    sale_id,
    order_id,
    order_date,
    customer_id,
    sales_rep_id,
    territory_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    unit_cost,
    extended_sales,
    extended_cost,
    gross_profit,
    date_key
)
SELECT
    sol.sales_line_id,
    so.order_id,
    so.order_date,
    so.customer_id,
    so.sales_rep_id,
    so.territory_id,
    sol.product_id,
    sol.quantity,
    sol.unit_price,
    sol.discount_pct,
    sol.unit_cost,
    sol.extended_sales,
    sol.extended_cost,
    sol.gross_profit,
    dd.date_key
FROM sales_analytics.sales_orders so
JOIN sales_analytics.sales_order_lines sol
    ON so.order_id = sol.order_id
JOIN sales_analytics.dim_date dd
    ON so.order_date = dd.full_date;