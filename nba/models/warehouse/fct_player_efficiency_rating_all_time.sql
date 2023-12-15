WITH intermediate_player_game_logs AS (
    SELECT 
        player_id,
        player_name,
        SUM(field_goals_made) AS field_goals_made,
        SUM(field_goals_attempted) AS field_goals_attempted,
        SUM(field_goal_pct) AS field_goal_pct,
        SUM(three_point_made) AS three_point_made,
        SUM(three_point_attempted) AS three_point_attempted,
        SUM(three_point_pct) AS three_point_pct,
        SUM(free_throws_made) AS free_throws_made,
        SUM(free_throws_attempted) AS free_throws_attempted,
        SUM(free_throw_pct) AS free_throw_pct,
        SUM(rebounds) AS rebounds,
        SUM(offensive_rebounds) AS offensive_rebounds,
        SUM(defensive_rebounds) AS defensive_rebounds,
        SUM(assists) AS assists,
        SUM(blocks) AS blocks,
        SUM(steals) AS steals,
        SUM(personal_fouls) AS personal_fouls,
        SUM(turnovers) AS turnovers,
        SUM(mins_played) AS mins_played,
        SUM(win_counter) AS win_counter,
        SUM(loss_counter) AS loss_counter,
        SUM(total_games_played_counter) AS total_games_played_counter
    FROM 
        {{ ref('intermediate_player_game_logs') }}
    where 
       TO_NUMBER(SUBSTRING(season, 1, 4)) > 1976
    group by 
        player_id, player_name
),

player_efficiency AS (
    SELECT 
        player_id,
        player_name, 
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
    WHERE  
        mins_played >= 15000
)

SELECT 
    player_id, 
    player_name, 
    player_efficiency_rating
FROM
    player_efficiency
order by 
    player_efficiency_rating desc