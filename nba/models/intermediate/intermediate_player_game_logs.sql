{# {{
    config (
        materialized = 'view'
    )
}}

with date_details as (
    select 
        PLAYER_ID,
        {{ dbt_date.day_name('GAME_DATE') }} as day_name,
        {{ dbt_date.date_part("dayofweek", 'GAME_DATE') }} as day_of_week,
        {{ dbt_date.day_of_year('GAME_DATE') }} as day_of_year,
        {{ dbt_date.week_of_year('GAME_DATE') }} as week_of_year,
        {{ dbt_date.month_name('GAME_DATE') }} as month_name,
        {{ dbt_date.day_of_month('GAME_DATE') }} as day_of_month,
        cast({{ dbt_date.date_part('month', 'GAME_DATE') }} as {{ dbt.type_int() }}) as month_of_year,
        cast({{ dbt_date.date_part('year', 'GAME_DATE') }} as {{ dbt.type_int() }}) as year_name,
        {{ dbt_date.day_of_year('GAME_DATE') }} as day_of_year,
        cast({{ dbt_date.date_part('quarter', 'GAME_DATE') }} as {{ dbt.type_int() }}) as quarter_of_year,
        GAME_DATE


    from {{ ref('source_player_game_logs') }}
)

select * from date_details order by PLAYER_ID #}


{{
    config(
        materialized = "table"
    )
}}
with date_details as (
    select * from {{ ref('date_details') }}
)
select
    p.*,
    d.*
    
from
    {{ ref('source_player_game_logs') }} p
    left join
    date_details d
        on p.GAME_DATE = d.date_day