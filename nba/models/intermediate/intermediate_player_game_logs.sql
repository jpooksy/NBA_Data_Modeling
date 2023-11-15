with season_quarters as (
    select 
        *
    from
        {{ ref('intermediate_game_date_details') }}
),

player_game_logs as (
    select * from {{ ref('source_player_game_logs') }}
),

joined as (
select
    p.*,
    s.game_rank,
    s.season_quarter,
    s.season_month
from
    player_game_logs p
left join
    season_quarters s 
        on p.game_date = s.game_date
        AND p.team_id = s.team_id
)

select 
    * 
from 
    joined