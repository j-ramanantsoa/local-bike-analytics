-- Q4 : les clients qui dépensent le plus
--
-- L'idée :
--   1. On prend toutes les ventes dans fct_sales
--   2. On va chercher le nom et la ville du client dans dim_customers
--   3. Pour chaque client, on compte ses commandes et ce qu'il a dépensé
--   4. On garde les 10 qui ont dépensé le plus

select
    dim_customers.customer_name,
    dim_customers.city,
    -- Une commande prend plusieurs lignes dans fct_sales, d'où le distinct
    -- sans lui on compterait les produits achetés au lieu des commandes
    count(distinct fct_sales.order_id)  as nb_orders,
    -- Tout ce que le client a dépensé sur l'année, remises déduites
    round(sum(fct_sales.net_amount), 2) as revenue
from {{ ref('fct_sales') }} as fct_sales
inner join {{ ref('dim_customers') }} as dim_customers
    on fct_sales.customer_id = dim_customers.customer_id
-- Un paquet par client
-- petite limite : deux clients avec le même nom dans la même ville seraient mélangés,
-- ajouter customer_id ici réglerait le problème
group by dim_customers.customer_name, dim_customers.city
-- On classe par argent dépensé, mettre "nb_orders desc" pour voir ceux qui reviennent le plus souvent
order by revenue desc
limit 10
