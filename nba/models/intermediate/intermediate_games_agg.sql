WITH team_stats AS (
    SELECT 
        team_id,
        AVG(points) AS avg_points,
        AVG(field_goals_made) AS avg_field_goals_made,
        AVG(field_goals_attempted) AS avg_field_goals_attempted,
        AVG(three_point_made) AS avg_three_pointers_made,
        AVG(three_point_attempted) AS avg_three_pointers_attempted,
        AVG(free_throws_made) AS avg_free_throws_made,
        AVG(free_throws_attempted) AS avg_free_throws_attempted,
        AVG(total_rebounds) AS avg_total_rebounds,
        AVG(offensive_rebounds) AS avg_offensive_rebounds,
        AVG(defensive_rebounds) AS avg_defensive_rebounds,
        AVG(assists) AS avg_assists,
        AVG(personal_fouls) AS avg_personal_fouls,
        AVG(steals) AS avg_steals,
        AVG(turnovers) AS avg_turnovers,
        AVG(blocks) AS avg_blocks,
        AVG(plus_minus) AS avg_plus_minus,
        SUM(plus_minus) AS total_plus_minus
    FROM 
        {{ ref('source_games') }}
    GROUP BY 
        team_id
)

SELECT 
    team_id,
    avg_points,
    avg_field_goals_made,
    avg_field_goals_attempted,
    avg_field_goals_made / avg_field_goals_attempted AS field_goal_percentage,
    avg_three_pointers_made,
    avg_three_pointers_attempted,
    avg_three_pointers_made / avg_three_pointers_attempted AS three_point_percentage,
    avg_free_throws_made,
    avg_free_throws_attempted,
    avg_free_throws_made / avg_free_throws_attempted AS free_throw_percentage,
    avg_total_rebounds,
    avg_offensive_rebounds,
    avg_defensive_rebounds,
    avg_assists,
    avg_personal_fouls,
    avg_steals,
    avg_turnovers,
    avg_blocks,
    avg_plus_minus,
    total_plus_minus
FROM 
    team_stats