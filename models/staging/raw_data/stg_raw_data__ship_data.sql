with 

source as (

    select * from {{ source('raw_data', 'ship_data') }}

),

renamed as (

    select
        orders_id,
        shipping_fee,
        logcost,
        cast(ship_cost as float64)

    from source

)

select * from renamed