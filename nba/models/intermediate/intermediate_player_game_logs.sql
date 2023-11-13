{{
    config(
        materialized = "view"
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