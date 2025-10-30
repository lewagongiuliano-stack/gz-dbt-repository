WITH
    -- 1. Aggregate the margin and purchase cost from the line-item level (sales) to the order level
    sales_margin AS (
        SELECT
            orders_id,
            SUM(margin) AS margin,
            SUM(purchase_cost) AS purchase_cost
        FROM 
            -- Reference the intermediate sales margin model
            {{ ref('int_sales_margin') }}
        GROUP BY 
            orders_id
    ),

    -- 2. Select the operational costs (shipping) from the staging model
    shipping AS (
        SELECT
            s.orders_id,
            s.shipping_fee,
            -- These columns must be FLOAT64 in the staging model!
            s.log_cost, 
            s.ship_cost
        FROM 
            -- Reference the staging shipping model
            {{ ref('stg_gz_raw_data__raw_gz_ship') }} AS s
    )

-- 3. Final calculation: Join the two CTEs and calculate the operational margin
SELECT
    -- Keys and base metrics from sales_margin (aliased as 'm')
    m.orders_id,
    m.margin,
    m.purchase_cost,
    s.shipping_fee,
    s.log_cost,
    s.ship_cost,
    (m.margin + s.shipping_fee - s.log_cost - s.ship_cost) AS operational_margin

FROM
    sales_margin AS m
LEFT JOIN
    shipping AS s
    ON m.orders_id = s.orders_id