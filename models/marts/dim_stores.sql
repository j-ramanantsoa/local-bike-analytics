select
    store_id,
    store_name,
    city
from {{ ref('stg_local_bike__stores') }}
