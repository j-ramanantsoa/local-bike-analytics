with source as (

    select * from {{ source('local_bike', 'stocks') }}

),

renamed as (

    select
        id_magasin          as store_id,
        id_produit          as product_id,
        quantite_disponible as quantity_available
    from source

)

select * from renamed
