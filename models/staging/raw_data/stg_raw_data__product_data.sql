with 

source as (

    select * from {{ source('raw_data', 'product_data') }}

),

renamed as (

    select
        products_id,
        purchse_price as purchase_price

    from source

)

select * from renamed