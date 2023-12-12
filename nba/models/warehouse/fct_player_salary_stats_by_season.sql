with player_stats as (
    select 
        player_id, 
        player_name,
        season,
        games_played,
        total_mins_played
    from {{ ref('fct_player_stats_by_season') }}
),

salaries as (
    select 
        player_id,
        player_name,
        salary,
        season
    from
        {{ ref('intermediate_player_salaries') }}
), 

joined as (
    select 
        ps.*,
        s.* EXCLUDE(player_id, player_name,season)
from 
    player_stats ps
left join 
    salaries s
    on ps.player_id = s.player_id
    and ps.season = s.season
)

select 
    *
from 
    joined