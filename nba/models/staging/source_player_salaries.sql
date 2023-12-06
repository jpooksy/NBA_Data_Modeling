with source as (
    select 
        *
    from 
        {{multi_engine_ref(source_name = "public", table_name = "player_salaries_output")}}
),

renamed AS (
    SELECT
        "FULL_NAME" as full_name,
        "2022-23" as "2022_23_salary",
        "2023-24" as "2023_24_salary",
        "2024-25" as "2024_25_salary",
        "2025-26" as "2025_26_salary",
        "2026-27" as "2026_27_salary"
    FROM
        source
)
SELECT
    *
FROM
    renamed