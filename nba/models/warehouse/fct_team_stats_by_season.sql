with team_stats as (
    select
        team_id,
        team_city,
        team_name,
        season,
        field_goals_made,
        field_goals_attempted,
        CASE 
            WHEN field_goals_attempted = 0 THEN 0 -- Avoid division by zero
            ELSE field_goals_made / field_goals_attempted
        END as field_goal_percentage,
        three_pointers_made,
        three_pointers_attempted,
        CASE 
            WHEN three_pointers_attempted = 0 THEN 0 -- Avoid division by zero
            ELSE three_pointers_made / three_pointers_attempted
        END as three_point_percentage,
        free_throws_made,
        free_throws_attempted,
        CASE 
            WHEN free_throws_attempted = 0 THEN 0 -- Avoid division by zero
            ELSE free_throws_made / free_throws_attempted
        END as free_throw_percentage,
        offensive_rebounds,
        defensive_rebounds,
        total_rebounds,
        assists,
        personal_fouls,
        steals,
        turnovers,
        blocks,
        points
    from
        {{ ref('source_team_stats') }}
    WHERE TO_NUMBER(SUBSTRING(season, 1, 4)) BETWEEN 1970 AND 2022
)
select 
    *
from 
    team_stats
