-- Test métier : un montant de vente ne doit jamais être négatif.
-- Le test échoue s'il renvoie au moins une ligne.
select
    sale_id,
    gross_amount,
    net_amount
from {{ ref('fct_sales') }}
where net_amount < 0
   or gross_amount < 0
