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
        avg_mins_played
        win_counter,
        loss_counter,
        total_games_played_counter
    FROM 
        {{ ref('intermediate_player_game_logs') }}
    where 
       total_games_played_counter  >= 15
        and 
            TO_NUMBER(SUBSTRING(season, 1, 4)) BETWEEN 1980 AND 2022

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

season_count AS (
    SELECT 
        player_id,
        COUNT(DISTINCT season) AS num_seasons,
        SUM(CASE WHEN total_games_played_counter = 0 THEN 1 ELSE 0 END) AS potential_injury_seasons
    FROM 
        intermediate_player_game_logs
    GROUP BY 
        player_id
    HAVING 
        COUNT(DISTINCT season) > 5 -- Players with more than 5 seasons
),

best_season AS (
    SELECT 
        player_id, 
        player_name,
        season,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY player_efficiency_rating DESC) as rank,
        player_efficiency_rating
    FROM 
        player_efficiency
),

average_efficiency_excluding_best AS (
    SELECT 
        pe.player_id,
        pe.player_name,
        AVG(pe.player_efficiency_rating) as avg_per_excluding_best
    FROM 
        player_efficiency pe
    LEFT JOIN 
        best_season bs ON pe.player_id = bs.player_id AND pe.season = bs.season
    WHERE 
        bs.rank IS NULL OR bs.rank > 1
    GROUP BY 
        pe.player_id, pe.player_name
),
joined AS (
    SELECT 
        bs.player_id,
        bs.player_name,
        bs.season as best_season,
        bs.player_efficiency_rating as best_season_per,
        ae.avg_per_excluding_best,
        bs.player_efficiency_rating - ae.avg_per_excluding_best as per_difference,
        sc.num_seasons,
        sc.potential_injury_seasons
    FROM 
        best_season bs
    JOIN 
        average_efficiency_excluding_best ae ON bs.player_id = ae.player_id
    JOIN 
        season_count sc ON bs.player_id = sc.player_id
    WHERE 
        bs.rank = 1
        AND bs.player_efficiency_rating >= 18 -- Define the 'great' threshold
        AND ae.avg_per_excluding_best <= 13 -- Define the 'terrible' threshold
        AND sc.num_seasons > 5 -- Players with more than 5 seasons
)

SELECT * FROM joined
ORDER BY best_season DESC