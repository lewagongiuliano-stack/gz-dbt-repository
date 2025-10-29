with 

source as (

    select * from {{ source('raw_data', 'sales_data') }}

),

renamed as (

    select
        date_date,
        orders_id,
        pdt_id,
        revenue,
        quantity

    from source

)

select * from renamed