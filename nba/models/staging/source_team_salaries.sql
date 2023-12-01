WITH source AS (
    SELECT
        *
    FROM {% if target.name == "dev_duck_db" -%}
            {{ ref('team_salaries') }}
         {%- else -%}
            {{ source(
            "PUBLIC",
            "TEAM_SALARIES"
            ) }}
         {%- endif %}

),
renamed AS (
    SELECT
        "TEAM" as full_name,
        "Total Cap" as total_cap,
        "Luxury Tax Bill" as luxury_tax_bill
    FROM
        source
)
SELECT
    *
FROM
    renamed