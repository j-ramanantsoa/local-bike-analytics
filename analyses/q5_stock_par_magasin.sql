-- Q5 : combien de vélos et d'accessoires chaque magasin a en stock
--
-- L'idée :
--   1. On prend fct_stocks, qui dit combien il reste de chaque produit dans chaque magasin (105 lignes)
--   2. On va chercher le nom du magasin dans dim_stores
--   3. On additionne tous les produits d'un même magasin
-- On obtient 5 lignes, une par magasin
-- C'est le stock au moment du chargement, on n'a pas l'historique

select
    dim_stores.store_name,
    -- Le nombre total d'articles en stock dans le magasin, tous produits confondus
    sum(fct_stocks.quantity_available) as total_stock
from {{ ref('fct_stocks') }} as fct_stocks
inner join {{ ref('dim_stores') }} as dim_stores
    on fct_stocks.store_id = dim_stores.store_id
group by dim_stores.store_name
-- Le magasin le mieux fourni en premier
order by total_stock desc
-- Pour voir le détail produit par produit, il suffit de joindre dim_products sur product_id
-- et d'ajouter product_name dans le select et le group by
