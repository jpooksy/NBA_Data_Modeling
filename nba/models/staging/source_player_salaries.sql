with source as (
    select 
        *
    from 
        {{multi_engine_ref(source_name = "public", table_name = "player_salaries")}}
),

renamed AS (
    SELECT
        player,
        CAST(REPLACE(REPLACE(salary, '$', ''), ',', '') AS NUMBER) AS salary, 
        rank,
        year as season
    FROM
        source
)
SELECT
    *
FROM
    renamed