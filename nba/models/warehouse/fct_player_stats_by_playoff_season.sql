with player_stats_1 as (
    select 
        player_id,
        player_name,
        season,
    {# sum values #}
        sum(case when mins_played > 0 then 1 else 0 end) as games_played,
        sum(mins_played) as total_mins_played,
        sum(field_goals_made) as total_field_goals_made,
        sum(field_goals_attempted) as total_field_goals_attempted,
        sum(three_point_made) as total_three_point_made,
        sum(three_point_attempted) as total_three_point_attempted,
        sum(free_throws_made) as total_free_throws_made,
        sum(free_throws_attempted) as total_free_throws_attempted,
        sum(total_rebounds) as total_rebounds,
        sum(assists) as total_assists,
        sum(blocks) as total_blocks,
        sum(steals) as total_steals,
        sum(personal_fouls) as total_personal_fouls,
        sum(turnovers) as total_turnovers,
        sum(points) as total_points,
        sum(plus_minus) as total_plus_minus,
    {# average values #}
        avg(mins_played) as avg_mins_played,
        avg(field_goals_made) as avg_field_goals_made,
        avg(field_goals_attempted) as avg_field_goals_attempted,
        avg(three_point_made) as avg_three_point_made,
        avg(three_point_attempted) as avg_three_point_attempted,
        avg(free_throws_made) as avg_free_throws_made,
        avg(free_throws_attempted) as avg_free_throws_attempted,
        avg(total_rebounds) as avg_rebounds,
        avg(steals) as avg_steals,
        avg(personal_fouls) as avg_personal_fouls,
        avg(turnovers) as avg_turnovers,
        avg(points) as avg_points,
        avg(plus_minus) as avg_plus_minus

    from {{ ref('source_player_game_logs') }}
    where game_type = 'Playoffs'
    group by 1,2,3
), 

player_stats_2 as (
    select 
        *,
    {# percentage values #}
        coalesce(total_field_goals_made * 1.0 / nullif(total_field_goals_attempted, 0), 0) as field_goal_pct,
        coalesce(total_three_point_made * 1.0 / nullif(total_three_point_attempted, 0), 0) as three_point_pct,
        coalesce(total_free_throws_made * 1.0 / nullif(total_free_throws_attempted, 0), 0) as free_throw_pct
    from 
        player_stats_1
    order by player_id 

)
select * from player_stats_2