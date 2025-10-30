
WITH 
    intermediate_data AS (
        SELECT
            -- Key column needed for aggregation (orders_id)
            s.orders_id,      -- <--- ADD THIS LINE!
            
            -- Date (from int_sales_margin, as it is the most granular)
            s.date_date, 
            
            -- Metrics from int_sales_margin (line-item level)
            s.revenue,
            s.quantity,
            s.purchase_cost,
            s.margin,
            
            -- Metrics from int_orders_operational (order level)
            o.operational_margin,
            o.shipping_fee,
            o.log_cost,
            o.ship_cost

        FROM
            {{ ref('int_sales_margin') }} AS s
        LEFT JOIN
            {{ ref('int_orders_operational') }} AS o
            ON s.orders_id = o.orders_id
    )

-- 2. Aggregate the data to the required daily granularity
SELECT
    -- Date Granularity
    date_date,
    margin,
    -- Total number of transactions (now 'orders_id' is available!)
    COUNT(DISTINCT orders_id) AS total_transactions, 
    
    -- Sum of revenue and costs
    SUM(revenue) AS total_revenue,
    SUM(purchase_cost) AS total_purchase_cost,
    SUM(operational_margin) AS operational_margin,
    
    SUM(shipping_fee) AS total_shipping_fees,
    SUM(log_cost) AS total_log_costs,
    
    -- Average Basket (Total Revenue / Total number of transactions)
    SUM(revenue) / COUNT(DISTINCT orders_id) AS average_basket,
    
    -- Total quantity of products sold
    SUM(quantity) AS total_quantity_sold

FROM 
    intermediate_data
GROUP BY 
    date_date,
    margin
ORDER BY 
    date_date DESC