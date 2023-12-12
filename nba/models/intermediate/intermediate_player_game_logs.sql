with player_game_logs as (
    select 
        player_id,
        player_name,
        team_id,
        team_abbreviation,
        team_name,
        game_id,
        game_date, 
        matchup,
        win_loss,
        mins_played,
        field_goals_made,
        field_goals_attempted,
        three_point_made,
        three_point_attempted,
        three_point_pct,
        free_throws_made,
        free_throws_attempted,
        free_throw_pct,
        offensive_rebounds,
        defensive_rebounds,
        total_rebounds,
        assists,
        turnovers,
        steals,
        blocks,
        personal_fouls,
        points,
        plus_minus,
        season,
        game_type
    from {{ ref('source_player_game_logs') }}
),

game_date_details as (
    SELECT  
        team_id,
        game_date,
        game_rank,
        season_month
    from
        {{ ref('intermediate_game_date_details') }}
),

joined as (
    select
        pgl.*,
        gdd.game_rank,
        gdd.season_month
    from
        player_game_logs pgl
    left join
        game_date_details gdd
            on pgl.game_date = gdd.game_date
            and pgl.team_id = gdd.team_id
)

select 
    * 
from 
    joined