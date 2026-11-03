-- Q1 : combien chaque magasin a vendu, mois par mois
--
-- L'idée :
--   1. On prend toutes les ventes dans fct_sales (une ligne = un produit dans une commande)
--   2. On va chercher le nom du magasin dans dim_stores
--   3. On range chaque vente dans son mois et on fait la somme
-- On obtient une ligne par mois et par magasin, donc 12 x 5 = 60 lignes

select
    -- On ramène chaque date au 1er du mois (le 17 mars devient le 1er mars)
    -- comme ça toutes les ventes de mars se retrouvent ensemble
    date_trunc(fct_sales.order_date, month) as month,
    dim_stores.store_name,
    -- On additionne le montant net, c'est-à-dire après remise
    -- c'est l'argent que le magasin a vraiment encaissé
    round(sum(fct_sales.net_amount), 2)     as revenue
from {{ ref('fct_sales') }} as fct_sales
-- On relie chaque vente à son magasin
-- pas de risque de perdre des ventes : un test vérifie que chaque store_id existe bien dans dim_stores
inner join {{ ref('dim_stores') }} as dim_stores
    on fct_sales.store_id = dim_stores.store_id
-- On fait un paquet par mois et par magasin, et la somme se calcule dans chaque paquet
group by month, dim_stores.store_name
-- Les mois dans l'ordre, et dans chaque mois le magasin qui a le plus vendu en premier
order by month, revenue desc
