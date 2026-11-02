-- chiffre d'affaires par mois et par magasin
select
    date_trunc(fct_sales.order_date, month) as month,
    dim_stores.store_name,
    round(sum(fct_sales.net_amount), 2)     as revenue
from {{ ref('fct_sales') }} as fct_sales
inner join {{ ref('dim_stores') }} as dim_stores
    on fct_sales.store_id = dim_stores.store_id
group by month, dim_stores.store_name
order by month, revenue desc