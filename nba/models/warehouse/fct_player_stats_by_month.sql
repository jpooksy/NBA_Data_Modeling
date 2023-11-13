with player_stats as (
    select 
        player_id,
        player_name,
        month_of_year,
        sum(mins_played) as total_mins_played,
        sum(field_goals_made) as total_field_goals_made,
        sum(field_goals_attempted) as total_field_goals_attempted,
        sum(three_point_made) as total_three_point_made,
        sum(three_point_attempted) as total_three_point_attempted,
        sum(free_throws_made) as total_free_throws_made,
        sum(free_throws_attempted) as total_free_throws_attempted,
        sum(offensive_rebounds) as total_offensive_rebounds,
        sum(defensive_rebounds) as total_defensive_rebounds,
        sum(total_rebounds) as total_rebounds,
        sum(assists) as total_assists,
        sum(turnovers) as total_turnovers,
        sum(steals) as total_steals,
        sum(blocks) as total_blocks,
        sum(personal_fouls) as total_personal_fouls,
        sum(personal_foul_drawn) as total_personal_foul_drawn,
        sum(points) as total_points,
        MEDIAN( total_points ) OVER ( PARTITION BY player_id, month_of_year ),
        sum(plus_minus) as total_plus_minus,
        sum(case when mins_played > 0 then 1 else 0 end) as games_played
    from 
        {{ ref('intermediate_player_game_logs') }}
    group by 1,2,3
)

select 
    *,
    coalesce(total_field_goals_made * 1.0 / nullif(total_field_goals_attempted, 0), 0) as field_goal_pct,
    coalesce(total_three_point_made * 1.0 / nullif(total_three_point_attempted, 0), 0) as three_point_pct,
    coalesce(total_free_throws_made * 1.0 / nullif(total_free_throws_attempted, 0), 0) as free_throw_pct,
    coalesce(total_points * 1.0 / nullif(games_played, 0), 0) as avg_points_per_game
from player_stats 
where player_id = 2544
order by player_id