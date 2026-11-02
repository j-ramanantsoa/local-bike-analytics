{{
    config(
        partition_by = {'field': 'order_date', 'data_type': 'date'},
        cluster_by = ['store_id']
    )
}}

with order_items as (

    select * from {{ ref('stg_local_bike__order_items') }}

),

orders as (

    select * from {{ ref('stg_local_bike__orders') }}

),

joined as (

    select
        concat(cast(order_items.order_id as string), '-', cast(order_items.product_id as string)) as sale_id,
        order_items.order_id,
        orders.order_date,
        orders.customer_id,
        orders.store_id,
        order_items.product_id,
        order_items.quantity,
        order_items.unit_price,
        order_items.discount,
        order_items.quantity * order_items.unit_price                                    as gross_amount,
        round(order_items.quantity * order_items.unit_price * (1 - order_items.discount), 2) as net_amount
    from order_items
    inner join orders
        on order_items.order_id = orders.order_id

)

select * from joined
