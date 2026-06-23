-- Q: Are delays increasing over time?
-- Approach: aggregate average delay by month to observe trend direction

SELECT
    DATE_TRUNC('month', planned_start_date)::date AS month,
    ROUND(AVG(actual_end_date - planned_end_date), 2) AS avg_delay_days
FROM production_orders
GROUP BY month
ORDER BY month;

-- Observation:
-- No clear upward trend in average delays over time.
-- Values fluctuate with seasonal peaks rather than steadily increasing.

-- Follow-up: Breakdown by supplier to check if trends are driven by specific suppliers

SELECT
    s.supplier_id,
    s.supplier_name,
    DATE_TRUNC('month', po.planned_start_date)::date AS month,
    ROUND(AVG(po.actual_end_date - po.planned_end_date), 2) AS avg_delay_days
FROM production_orders po
INNER JOIN suppliers s
    ON po.supplier_id = s.supplier_id
GROUP BY s.supplier_id, month
ORDER BY month, s.supplier_id, s.supplier_name;

-- Observation:
-- Frontier Supply shows consistently higher average delays than other suppliers.
-- However, delay levels remain relatively stable over time for each supplier.
-- Seasonal spikes (especially summer months) are visible across all suppliers.


-- Q: Which products experience the highest delay rates?
-- Approach: calculate average production delay for each product
-- and rank products from highest to lowest average delay.

SELECT
    p.product_name,
    ROUND(AVG(po.actual_end_date - po.planned_end_date), 2) AS avg_delay_days
FROM production_orders po
INNER JOIN products p
    ON po.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY avg_delay_days DESC;

-- Observation:
-- Average delay days are relatively similar across all products.
-- Product type alone does not appear to be a major driver of delays.

-- Follow-up: analyze order volume by product alongside
-- average delays to assess whether production workload
-- is associated with delay levels.

SELECT
    p.product_name,
    COUNT(*) AS order_count,
    ROUND(AVG(po.actual_end_date - po.planned_end_date), 2) AS avg_delay_days
FROM production_orders po
JOIN products p
    ON po.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY order_count DESC;

-- Observation:
-- Average delays are relatively similar across products.
-- No clear relationship is visible between production volume
-- and average delay days.
-- Product-level differences appear modest, suggesting other
-- operational factors may have a greater influence on delays.


-- Q: Which supplier is associated with the highest defect rate?
-- Approach: compare defect rate across suppliers
-- to identify quality differences independent of volume.

SELECT
    s.supplier_name,
    COUNT(d.defect_id) AS defect_events,
    COUNT(DISTINCT po.order_id) AS total_orders,
    ROUND(
        COUNT(d.defect_id) * 100.0
        / COUNT(DISTINCT po.order_id),
        2
    ) AS defect_rate_pct
FROM suppliers s
INNER JOIN production_orders po
    ON s.supplier_id = po.supplier_id
LEFT JOIN defects d
    ON po.order_id = d.order_id
GROUP BY s.supplier_name
ORDER BY defect_rate_pct DESC;

-- Observation:
-- Frontier Supply shows the highest defect rate (33.27%),
-- significantly higher than Atlas Industrial Parts (14.00%)
-- and Northern Components (6.66%).
-- This suggests persistent quality differences between suppliers.


-- Q: Which months have the weakest inventory position?
-- Approach: Calculate monthly average stock balance and compare it to a
-- dynamically adjusted reorder point (seasonal threshold) to identify
-- periods of potential inventory pressure.

-- Supporting view: inventory model with seasonal reorder point

CREATE OR REPLACE VIEW inventory_model AS
SELECT
    *,
    CASE
        WHEN EXTRACT(MONTH FROM balance_date) IN (7,8,9) THEN 120
        ELSE 100
    END AS dynamic_reorder_point
FROM inventory_balance;

-- Analyze monthly inventory position relative to the reorder threshold

SELECT
    DATE_TRUNC('month', balance_date)::date AS month,
    ROUND(AVG(stock_balance), 2) AS avg_stock_balance,
    ROUND(AVG(dynamic_reorder_point), 2) AS avg_reorder_point,
    ROUND(AVG(stock_balance - dynamic_reorder_point), 2) AS avg_inventory_gap,
    CASE 
        WHEN AVG(stock_balance - dynamic_reorder_point) < 0 THEN 'Low inventory pressure'
        WHEN AVG(stock_balance - dynamic_reorder_point) < 20 THEN 'Moderate pressure'
        ELSE 'Healthy inventory'
    END AS inventory_status
FROM inventory_model
GROUP BY month
ORDER BY month;

-- Follow-up: review overall inventory distribution
-- to provide context for inventory pressure findings
SELECT
    MIN(stock_balance) AS min_stock,
    MAX(stock_balance) AS max_stock,
    ROUND(AVG(stock_balance), 2) AS avg_stock
FROM inventory_balance;

-- Observation:
-- Inventory levels remain consistently above the dynamic reorder threshold
-- throughout the entire period.
--
-- While the model introduces seasonal adjustments to simulate higher demand
-- in summer months, stock levels remain sufficiently high to avoid sustained
-- periods of inventory pressure.
--
-- This indicates that inventory is not a limiting factor in the production
-- system during the observed period.


-- Q: Does inventory pressure coincide with production delays?
-- Approach: compare monthly inventory gap with average production delay
-- to test whether inventory constraints drive operational delays.

WITH inventory_monthly AS (
    SELECT
        DATE_TRUNC('month', balance_date)::date AS month,
        AVG(stock_balance - dynamic_reorder_point) AS avg_inventory_gap
    FROM inventory_model
    GROUP BY month
),

delays_monthly AS (
    SELECT
        DATE_TRUNC('month', planned_start_date)::date AS month,
        AVG(actual_end_date - planned_end_date) AS avg_delay_days
    FROM production_orders
    GROUP BY month
)

SELECT
    i.month,
    ROUND(i.avg_inventory_gap, 2) AS avg_inventory_gap,
    ROUND(d.avg_delay_days, 2) AS avg_delay_days
FROM inventory_monthly i
LEFT JOIN delays_monthly d
    ON i.month = d.month
ORDER BY i.month;

-- Observation:
-- A partial inverse relationship is observed between inventory gap
-- and production delays during peak summer months.
--
-- Periods with lower inventory levels (July–September) consistently
-- coincide with higher average production delays across both years.
--
-- However, this relationship is not consistent throughout the year.
-- Production delays also occur during periods of healthy inventory levels,
-- suggesting that inventory pressure is a contributing factor but not
-- the primary driver of delays.

