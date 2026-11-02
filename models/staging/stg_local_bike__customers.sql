with source as (

    select * from {{ source('local_bike', 'customers') }}

),

renamed as (

    select
        id    as customer_id,
        nom   as customer_name,
        ville as city
    from source

)

select * from renamed
