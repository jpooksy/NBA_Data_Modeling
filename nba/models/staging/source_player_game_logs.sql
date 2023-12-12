with source as (
    select 
        *
    from 
        {{multi_engine_ref(source_name = "public", table_name = "player_game_logs")}}
),

renamed as (
    select
        player_id,
        player_name,
        nickname,
        team_id,
        team_abbreviation,
        team_name,
        game_id,
        date(game_date) as game_date, 
        matchup,
        wl as win_loss,
        round(min, 2) as mins_played,
        fgm as field_goals_made,
        fga as field_goals_attempted,
        fg_pct as field_goal_pct,
        fg3m as three_point_made,
        fg3a as three_point_attempted,
        fg3_pct as three_point_pct,
        ftm as free_throws_made,
        fta as free_throws_attempted,
        ft_pct as free_throw_pct,
        oreb as offensive_rebounds,
        dreb as defensive_rebounds,
        reb as total_rebounds,
        ast as assists,
        tov as turnovers,
        stl as steals,
        blk as blocks,
        pf as personal_fouls,
        pts as points,
        plus_minus as plus_minus,
        season,
        game_type
   from
        source
)
select
    *
from
    renamed