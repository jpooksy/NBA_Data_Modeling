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
    coalesce(total_free_throws_made * 1.0 / nullif(total_free_throws_attempted, 0), 0) as free_throw_pct

from player_stats 
order by player_id