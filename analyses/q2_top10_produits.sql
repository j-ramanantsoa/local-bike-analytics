-- top 10 des produits les plus vendus (en qté et en montant)
select
    dim_products.product_name,
    dim_products.category,
    sum(fct_sales.quantity)             as total_quantity,
    round(sum(fct_sales.net_amount), 2) as revenue
from {{ ref('fct_sales') }} as fct_sales
inner join {{ ref('dim_products') }} as dim_products
    on fct_sales.product_id = dim_products.product_id
group by dim_products.product_name, dim_products.category
order by total_quantity desc   -- remplace par "revenue desc" pour le top en montant
limit 10
