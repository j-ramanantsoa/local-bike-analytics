{#
    Les seeds vont dans le dataset indiqué par leur `schema` (local_bike_raw), tel quel.
    Les modèles gardent le comportement par défaut de dbt :
    dataset de la cible (local_bike_dev, local_bike_ci), suffixé par un éventuel schema personnalisé.
#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- elif node.resource_type == 'seed' -%}
        {{ custom_schema_name | trim }}
    {%- else -%}
        {{ target.schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
