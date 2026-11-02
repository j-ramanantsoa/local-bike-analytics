with source as (

    select * from {{ source('local_bike', 'stores') }}

),

renamed as (

    select
        id    as store_id,
        nom   as store_name,
        ville as city
    from source

)

select * from renamed
