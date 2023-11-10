{# break down the player season into quarters. 
remodel this differently. 
calculate a new column "quarter of the season" 
and then have aggregates for major stats. 

Task: Create intermediate date table
Then warehouse tables will be separated by weekly, quarterly, monthly, yearly. 
 #}


{{
    config (
        materialized = 'table'
    )
}}

with playerstats as (
    select 
        player_id,
        player_name,
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
        sum(block_attempts) as total_block_attempts,
        sum(personal_fouls) as total_personal_fouls,
        sum(personal_foul_drawn) as total_personal_foul_drawn,
        sum(points) as total_points,
        sum(plus_minus) as total_plus_minus,
        sum(case when mins_played > 0 then 1 else 0 end) as games_played
    from 
        {{ ref('source_player_game_logs') }} as g
    group by 
        player_id, player_name
), averages as (
    select 
        avg(total_assists) as avg_assists_per_game,
        avg(total_turnovers) as avg_turnovers_per_game,
        avg(total_points) as avg_points_per_game,
        avg(case when games_played > 0 then total_plus_minus else null end) as average_plus_minus
    from playerstats
)
select 
    ps.player_id,
    ps.player_name,
    s."2022_23_salary",
    ps.total_mins_played,
    ps.games_played,
    s."2022_23_salary" / nullif(ps.total_mins_played, 0) as salary_per_minute_played,
    s."2022_23_salary" / nullif(ps.games_played, 0) as salary_per_game_played,
    coalesce(ps.total_field_goals_made * 1.0 / nullif(ps.total_field_goals_attempted, 0), 0) as avg_field_goal_pct,
    coalesce(ps.total_three_point_made * 1.0 / nullif(ps.total_three_point_attempted, 0), 0) as avg_three_point_pct,
    coalesce(ps.total_free_throws_made * 1.0 / nullif(ps.total_free_throws_attempted, 0), 0) as avg_free_throw_pct,
    ps.total_assists,
    a.avg_assists_per_game,
    ps.total_turnovers,
    a.avg_turnovers_per_game,
    ps.total_steals,
    ps.total_blocks,
    ps.total_block_attempts,
    ps.total_personal_fouls,
    ps.total_personal_foul_drawn,
    ps.total_points,
    a.avg_points_per_game,
    ps.total_plus_minus,
    coalesce(ps.total_plus_minus * 1.0 / nullif(ps.games_played, 0), 0) as avg_plus_minus
from 
    playerstats ps
join
    {{ ref('source_player_salaries') }} as s 
on 
    ps.player_name = s.full_name
cross join
    averages a
