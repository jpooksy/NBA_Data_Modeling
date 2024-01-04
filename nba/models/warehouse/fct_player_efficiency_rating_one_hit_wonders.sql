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
        END AS player_efficiency_rating
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

ranked_seasons AS (
    SELECT 
        player_id, 
        player_name,
        season,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY player_efficiency_rating DESC) as rank,
        player_efficiency_rating
    FROM 
        player_efficiency
),

season_pairs AS (
    SELECT 
        r1.player_id,
        r1.player_name,
        r1.season as best_season,
        r1.player_efficiency_rating as best_season_per,
        r2.season as second_best_season,
        r2.player_efficiency_rating as second_best_season_per
    FROM 
        ranked_seasons r1
    JOIN 
        ranked_seasons r2 ON r1.player_id = r2.player_id AND r2.rank = 2
    WHERE 
        r1.rank = 1
),

per_by_season AS (
    SELECT 
        player_id,
        ARRAY_AGG(season || ':' || player_efficiency_rating) AS per_by_year
    FROM 
        (
            SELECT 
                player_id, 
                season, 
                player_efficiency_rating
            FROM 
                player_efficiency
            ORDER BY 
                player_id, season
        )
    GROUP BY 
        player_id
),



joined AS (
    SELECT 
        sp.player_id,
        sp.player_name,
        sp.best_season,
        sp.best_season_per,
        sp.second_best_season,
        sp.second_best_season_per,
        pbs.per_by_year,
        sc.num_seasons,
        sc.potential_injury_seasons
    FROM 
        season_pairs sp
    JOIN 
        season_count sc ON sp.player_id = sc.player_id
    JOIN 
        per_by_season pbs ON sp.player_id = pbs.player_id
    WHERE 
        sp.best_season_per >= 18 
        AND sp.second_best_season_per <= 14
        AND sc.num_seasons > 3
)

SELECT * FROM joined
ORDER BY best_season DESC