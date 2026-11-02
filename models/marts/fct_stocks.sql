select
    concat(cast(store_id as string), '-', cast(product_id as string)) as stock_id,
    store_id,
    product_id,
    quantity_available
from {{ ref('stg_local_bike__stocks') }}
