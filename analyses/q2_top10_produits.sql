-- Q2 : les 10 produits qui se vendent le mieux
--
-- L'idée :
--   1. On prend toutes les ventes dans fct_sales
--   2. On va chercher le nom et la catégorie du produit dans dim_products
--   3. Pour chaque produit, on compte combien d'unités sont parties et combien ça a rapporté
--   4. On trie et on garde les 10 premiers
-- La même requête sert pour les deux classements, il suffit de changer le tri

select
    dim_products.product_name,
    dim_products.category,
    -- Combien d'unités de ce produit on a vendues sur l'année
    sum(fct_sales.quantity)             as total_quantity,
    -- Combien ce produit a rapporté, remises déduites
    round(sum(fct_sales.net_amount), 2) as revenue
from {{ ref('fct_sales') }} as fct_sales
inner join {{ ref('dim_products') }} as dim_products
    on fct_sales.product_id = dim_products.product_id
-- Un paquet par produit
-- la catégorie est là parce qu'on l'affiche, mais un produit n'a qu'une catégorie donc ça ne change rien
group by dim_products.product_name, dim_products.category
-- Ici on classe par quantité, mettre "revenue desc" pour classer par montant
-- les deux tops ne se ressemblent pas : un vélo électrique se vend peu mais rapporte gros,
-- un accessoire part souvent mais rapporte peu
order by total_quantity desc
-- On ne garde que les 10 premiers une fois le tri fait
limit 10
