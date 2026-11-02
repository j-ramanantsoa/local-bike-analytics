-- panier moyen par commande
with orders as (

    select
        order_id,
        sum(net_amount) as order_amount
    from {{ ref('fct_sales') }}
    group by order_id

)

select
    count(*)                    as nb_orders,
    round(avg(order_amount), 2) as average_basket
from orders
