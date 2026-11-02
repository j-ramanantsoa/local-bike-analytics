with source as (

    select * from {{ source('local_bike', 'orders') }}

),

renamed as (

    select
        id                          as order_id,
        id_client                   as customer_id,
        id_magasin                  as store_id,
        cast(date_commande as date) as order_date
    from source

)

select * from renamed
