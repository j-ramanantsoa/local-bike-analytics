with source as (

    select * from {{ source('local_bike', 'order_items') }}

),

renamed as (

    select
        id_commande   as order_id,
        id_produit    as product_id,
        quantite      as quantity,
        prix_unitaire as unit_price,
        remise        as discount
    from source

)

select * from renamed
