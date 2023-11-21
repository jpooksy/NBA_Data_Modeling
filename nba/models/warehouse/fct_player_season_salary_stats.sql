with player_stats as (
    select 
        player_id, 
        player_name,
        games_played,
        total_mins_played
    from {{ ref('fct_player_stats_by_season') }}
),

salaries as (
    select 
        full_name,
        "2022_23_salary"
    from
        {{ ref('intermediate_player_salaries') }}
), 

joined as (
    select 
        ps.*,
        s."2022_23_salary",
        s."2022_23_salary" / nullif(ps.games_played, 0) as salary_per_game_played,
        s."2022_23_salary" / nullif(ps.total_mins_played, 0) as salary_per_minute_played
from 
    player_stats ps
join 
    salaries s
on  
    ps.player_name = s.full_name
)

select 
    *
from 
    joined

