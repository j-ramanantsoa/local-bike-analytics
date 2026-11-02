-- un stock disponible ne peut pas être négatif
select
    stock_id,
    quantity_available
from {{ ref('fct_stocks') }}
where quantity_available < 0
