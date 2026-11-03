-- Q3 : combien un client dépense en moyenne par commande
--
-- Attention au piège : dans fct_sales, une commande est éclatée sur plusieurs lignes
-- (une par produit acheté), donc si on fait directement la moyenne de net_amount
-- on obtient le prix moyen d'une ligne, pas celui d'une commande
--
-- Donc on fait ça en deux temps :
--   1. On recolle les lignes pour avoir le total de chaque commande
--   2. On fait la moyenne de ces totaux

-- Étape 1 : le total de chaque commande
with orders as (

    select
        order_id,
        sum(net_amount) as order_amount
    from {{ ref('fct_sales') }}
    group by order_id

)

-- Étape 2 : la moyenne sur toutes les commandes
-- pas de group by, donc on obtient une seule ligne pour tout le monde
select
    -- Le nombre de commandes, pratique pour vérifier qu'on tombe bien sur 3 000
    count(*)                    as nb_orders,
    -- Le panier moyen : ce qu'une commande rapporte en moyenne
    round(avg(order_amount), 2) as average_basket
from orders
