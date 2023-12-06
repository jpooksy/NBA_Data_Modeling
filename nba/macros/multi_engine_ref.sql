{% macro multi_engine_ref(table_name, source_name=none) %}
--  Snowflake Target
    {% if target.name == 'dev' %}
        {{ source(source_name.upper(), table_name.upper()) }}
        --  add jinja function to change lowercase to uppercase
--  duckdb targets
    {% elif target.name in ['dev_mother_duck', 'dev_duck_db'] %}
        {{ ref(table_name) }}
    {% else %}
        -- Handle other targets or provide a default action
        SELECT 'Unsupported target' as error_message
    {% endif %}

{% endmacro %}