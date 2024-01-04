WITH intermediate_player_game_logs AS (
    SELECT 
        player_id,
        player_name,
        season,
        field_goals_made,
        field_goals_attempted,
        field_goal_pct,
        three_point_made,
        three_point_attempted,
        three_point_pct,
        free_throws_made,
        free_throws_attempted,
        free_throw_pct,
        rebounds,
        offensive_rebounds,
        defensive_rebounds,
        assists,
        blocks,
        steals,
        personal_fouls,
        turnovers,
        mins_played,
        win_counter,
        loss_counter,
        total_games_played_counter
    FROM 
        {{ ref('intermediate_player_game_logs') }}
    where 
       total_games_played_counter  >= 15
        and 
            TO_NUMBER(SUBSTRING(season, 1, 4)) > 1976
                and 
                    mins_played >= 1000
),

player_efficiency AS (
    SELECT 
        player_id,
        player_name, 
        season,
        CASE
            WHEN mins_played = 0 THEN 0  -- Handle division by zero by returning 0
            ELSE 
                (
                    (   
                    (field_goals_made * 85.910) +
                    (steals * 53.897) +
                    (three_point_made * 51.757) +
                    (free_throws_made * 46.845) +
                    (blocks * 39.190) +
                    (offensive_rebounds * 39.190) +
                    (assists * 34.677) +
                    (defensive_rebounds * 14.707) -
                    (personal_fouls * 17.174) -
                    ((free_throws_attempted - free_throws_made) * 20.091) -
                    ((field_goals_attempted - field_goals_made) * 39.190) -
                    (turnovers * 53.897)
                    )   
                    * (1 / mins_played)
                )
        END AS player_efficiency_rating,
        field_goals_made,
        field_goals_attempted,
        field_goal_pct,
        three_point_made,
        three_point_attempted,
        three_point_pct,
        free_throws_made,
        free_throws_attempted,
        free_throw_pct,
        rebounds,
        offensive_rebounds,
        defensive_rebounds,
        assists,
        blocks,
        steals,
        personal_fouls,
        turnovers,
        mins_played,
        win_counter,
        loss_counter,
        total_games_played_counter
    FROM
        intermediate_player_game_logs
),

player_salaries as (
    select 
        player_id,
        season,
        salary
    FROM 
        {{ ref('intermediate_player_salaries') }}
)

SELECT 
    pe.player_id, 
    pe.player_name, 
    pe.season,
    pe.player_efficiency_rating,
    ps.salary,
    CASE 
        WHEN pe.player_efficiency_rating > 0 THEN ps.salary / pe.player_efficiency_rating
        ELSE NULL -- Handle division by zero efficiency by returning NULL or a suitable value
    END AS salary_per_efficiency_unit
FROM
    player_efficiency pe
JOIN player_salaries ps 
    on pe.player_id = ps.player_id
    and ps.season = pe.season
ORDER BY 
    salary_per_efficiency_unit DESC
