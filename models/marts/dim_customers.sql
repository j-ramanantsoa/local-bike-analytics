select
    customer_id,
    customer_name,
    city
from {{ ref('stg_local_bike__customers') }}
