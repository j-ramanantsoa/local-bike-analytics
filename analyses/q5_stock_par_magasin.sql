-- stock disponible par magasin
select
    dim_stores.store_name,
    sum(fct_stocks.quantity_available) as total_stock
from {{ ref('fct_stocks') }} as fct_stocks
inner join {{ ref('dim_stores') }} as dim_stores
    on fct_stocks.store_id = dim_stores.store_id
group by dim_stores.store_name
order by total_stock desc
