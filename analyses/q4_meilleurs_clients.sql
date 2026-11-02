-- clients qui achetent le plus
select
    dim_customers.customer_name,
    dim_customers.city,
    count(distinct fct_sales.order_id)  as nb_orders,
    round(sum(fct_sales.net_amount), 2) as revenue
from {{ ref('fct_sales') }} as fct_sales
inner join {{ ref('dim_customers') }} as dim_customers
    on fct_sales.customer_id = dim_customers.customer_id
group by dim_customers.customer_name, dim_customers.city
order by revenue desc
limit 10
