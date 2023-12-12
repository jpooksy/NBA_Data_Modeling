with source as (
    select 
        *
    from 
        {{multi_engine_ref(source_name = "public", table_name = "team_spend")}}
),


renamed AS (
    SELECT
        team_id,
        team_city,
        team_name,
        full_name,
        year as season,
        total_spend as team_payroll,
        active_payroll,
        dead_payroll,
        luxury_tax_payroll,
        luxury_tax_space,
        luxury_tax_bill
    FROM
        source
)
SELECT
    *
FROM
    renamed