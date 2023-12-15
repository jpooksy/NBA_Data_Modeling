with player_game_logs_agg as (
    select 
        player_id,
        player_name,
        season,
        sum(field_goals_made) as field_goals_made,
        sum(field_goals_attempted) as field_goals_attempted,
        SUM(field_goals_made) / NULLIF(SUM(field_goals_attempted), 0) AS field_goal_pct,
        sum(three_point_made) as three_point_made,
        sum(three_point_attempted) as three_point_attempted,
        SUM(three_point_made) / NULLIF(SUM(three_point_attempted), 0) AS three_point_pct,
        sum(free_throws_made) as free_throws_made,
        sum(free_throws_attempted) as free_throws_attempted,
        SUM(free_throws_made) / NULLIF(SUM(free_throws_attempted), 0) AS free_throw_pct,
        sum(total_rebounds) as rebounds,
        sum(offensive_rebounds) as offensive_rebounds,
        sum(defensive_rebounds) as defensive_rebounds,
        sum(assists) as assists,
        sum(blocks) as blocks,
        sum(steals) as steals,
        sum(personal_fouls) as personal_fouls,
        sum(turnovers) as turnovers,
        sum(points) as points,
        sum(plus_minus) as plus_minus,
        sum(mins_played) as mins_played,
        avg(mins_played) as avg_mins_played,
        sum(case when win_loss = 'L' then 1 else 0 end) as loss_counter,
        sum(case when win_loss = 'W' then 1 else 0 end) as win_counter,
        sum(case when mins_played = 0 then 0 else 1 end) as total_games_played_counter
    from 
        {{ ref('source_player_game_logs') }}
    group by 
        player_id, player_name, season
),

remove_nulls as (
    select 
        COALESCE(player_id, 0) as player_id,
        COALESCE(player_name, '') as player_name,
        COALESCE(season, '') as season,
        COALESCE(field_goals_made, 0) as field_goals_made,
        COALESCE(field_goals_attempted, 0) as field_goals_attempted,
        COALESCE(field_goal_pct, 0) as field_goal_pct,        
        COALESCE(three_point_made, 0) as three_point_made,
        COALESCE(three_point_attempted, 0) as three_point_attempted,
        COALESCE(three_point_pct, 0) as three_point_pct,
        COALESCE(free_throws_made, 0) as free_throws_made,
        COALESCE(free_throws_attempted, 0) as free_throws_attempted,
        COALESCE(free_throw_pct, 0) as free_throw_pct,
        COALESCE(rebounds, 0) as rebounds,
        COALESCE(offensive_rebounds, 0) as offensive_rebounds,
        COALESCE(defensive_rebounds, 0) as defensive_rebounds,
        COALESCE(assists, 0) as assists,
        COALESCE(blocks, 0) as blocks,
        COALESCE(steals, 0) as steals,
        COALESCE(personal_fouls, 0) as personal_fouls,
        COALESCE(turnovers, 0) as turnovers,
        COALESCE(points, 0) as points,
        COALESCE(plus_minus, 0) as plus_minus,
        COALESCE(mins_played, 0) as mins_played,
        COALESCE(avg_mins_played, 0) as avg_mins_played,
        COALESCE(win_counter, 0) as win_counter,
        COALESCE(loss_counter, 0) as loss_counter,
        COALESCE(total_games_played_counter, 0) as total_games_played_counter
    from
        player_game_logs_agg
)
select 
    * 
from 
    remove_nulls
