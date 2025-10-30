WITH intermediate_calculations AS (
    SELECT
        -- Sales (stg_gz_raw_data__raw_gz_sales) Columns
        s.date_date,
        s.orders_id,
        s.products_id,
        s.quantity,
        s.revenue,
        
        -- Product (stg_gz_raw_data__raw_gz_product) Column
        p.purchase_price,
        
        -- 1. Calculate Purchase Cost:
        s.quantity * cast(p.purchase_price as float64) AS purchase_cost
        
    FROM 
        {{ ref('stg_gz_raw_data__raw_gz_sales') }} AS s
    LEFT JOIN 
        {{ ref('stg_gz_raw_data__raw_gz_product') }} AS p
        ON s.products_id = p.products_id
)

SELECT
    *,
    
    -- 2. Calculate Margin: (Now using the alias 'purchase_cost' from the CTE)
    revenue - purchase_cost AS margin,
    
    -- 3. Calculate Margin Percent: Now 'revenue' and 'purchase_cost' are recognized
    -- The macro call is clean and correctly generates the necessary parentheses.
    {{ margin_percent('revenue', 'purchase_cost', 4) }} AS margin_rate_pct_high_precision

FROM 
    intermediate_calculations