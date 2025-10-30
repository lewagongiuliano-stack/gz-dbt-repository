SELECT
    -- Sales (stg_gz_raw_data__raw_gz_sales) Columns
    s.date_date,
    s.orders_id,
    s.products_id,
    s.quantity,
    s.revenue,
    
    -- Product (stg_gz_raw_data__raw_gz_product) Column
    p.purchase_price,

    -- Metrics Calculation
    -- 1. Calculate Purchase Cost: purchase_cost = quantity * purchase_price
    s.quantity * cast(p.purchase_price as float64) AS purchase_cost,

    -- 2. Calculate Margin: margin = revenue - purchase_cost
    s.revenue - (s.quantity * cast(p.purchase_price as float64)) AS margin

FROM 
    -- Referencing the Sales Staging Model (Base Fact Table)
    {{ ref('stg_gz_raw_data__raw_gz_sales') }} AS s

-- LEFT JOIN to bring in the Product Cost data
LEFT JOIN 
    -- Referencing the Product Staging Model
    {{ ref('stg_gz_raw_data__raw_gz_product') }} AS p
    ON s.products_id = p.products_id