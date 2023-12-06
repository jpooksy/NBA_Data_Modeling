with source as (
    select 
        *
    from 
        {{multi_engine_ref(source_name = "public", table_name = "team_salaries")}}
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