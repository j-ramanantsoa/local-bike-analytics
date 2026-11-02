with source as (

    select * from {{ source('local_bike', 'products') }}

),

renamed as (

    select
        id             as product_id,
        nom            as product_name,
        categorie      as category,
        prix_catalogue as list_price
    from source

)

select * from renamed
