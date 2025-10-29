WITH source AS (
    SELECT *
    FROM {{ source('raw_data', 'ship_data') }}
),

renamed AS (
    SELECT
        orders_id,
        shipping_fee,
        logcost,
        -- Cast ship_cost to a numerical format (e.g., FLOAT64)
        CAST(ship_cost AS FLOAT64) AS ship_cost, 
    
    FROM source
)
SELECT * FROM renamed