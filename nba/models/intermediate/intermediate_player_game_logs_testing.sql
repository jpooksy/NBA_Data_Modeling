WITH player_game_logs AS (
    SELECT 
        player_id,
        player_name,
        game_id,
        game_date,
        season,
        COALESCE(field_goals_made, 0) AS field_goals_made,
        COALESCE(field_goals_attempted, 0) AS field_goals_attempted,
        COALESCE(field_goal_pct, 0) AS field_goal_pct,        
        COALESCE(three_point_made, 0) AS three_point_made,
        COALESCE(three_point_attempted, 0) AS three_point_attempted,
        COALESCE(three_point_pct, 0) AS three_point_pct,
        COALESCE(free_throws_made, 0) AS free_throws_made,
        COALESCE(free_throws_attempted, 0) AS free_throws_attempted,
        COALESCE(free_throw_pct, 0) AS free_throw_pct,
        COALESCE(total_rebounds, 0) AS total_rebounds,
        COALESCE(offensive_rebounds, 0) AS offensive_rebounds,
        COALESCE(defensive_rebounds, 0) AS defensive_rebounds,
        COALESCE(assists, 0) AS assists,
        COALESCE(blocks, 0) AS blocks,
        COALESCE(steals, 0) AS steals,
        COALESCE(personal_fouls, 0) AS personal_fouls,
        COALESCE(turnovers, 0) AS turnovers,
        COALESCE(points, 0) AS points,
        COALESCE(plus_minus, 0) AS plus_minus,
        COALESCE(mins_played, 0) AS mins_played
    FROM 
        {{ ref('source_player_game_logs') }}
    --  where player_id = 202391
),

numbered_games AS (
    SELECT 
        *,
        CEIL(ROW_NUMBER() OVER (PARTITION BY player_id, season ORDER BY game_date, game_id) / 8.0) AS game_group
    FROM 
        player_game_logs
),

grouped_games AS (
    SELECT 
        player_id,
        player_name,
        season,
        game_group,
        SUM(field_goals_made) AS field_goals_made,
        SUM(field_goals_attempted) AS field_goals_attempted,
        SUM(field_goals_made) / NULLIF(SUM(field_goals_attempted), 0) AS field_goal_pct,
        SUM(three_point_made) AS three_point_made,
        SUM(three_point_attempted) AS three_point_attempted,
        SUM(three_point_made) / NULLIF(SUM(three_point_attempted), 0) AS three_point_pct,
        SUM(free_throws_made) AS free_throws_made,
        SUM(free_throws_attempted) AS free_throws_attempted,
        SUM(free_throws_made) / NULLIF(SUM(free_throws_attempted), 0) AS free_throw_pct,
        SUM(total_rebounds) AS total_rebounds,
        SUM(offensive_rebounds) AS offensive_rebounds,
        SUM(defensive_rebounds) AS defensive_rebounds,
        SUM(assists) AS assists,
        SUM(blocks) AS blocks,
        SUM(steals) AS steals,
        SUM(personal_fouls) AS personal_fouls,
        SUM(turnovers) AS turnovers,
        SUM(points) AS points,
        SUM(plus_minus) AS plus_minus,
        SUM(mins_played) AS mins_played,
        COUNT(*) AS games_in_group -- Count of games in each group
    FROM 
        numbered_games
    GROUP BY 
        player_id, player_name, season, game_group
), 

adding_pgl AS (
    SELECT 
        player_id,
        player_name,
        game_group,
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
        total_rebounds,
        offensive_rebounds,
        defensive_rebounds,
        assists,
        blocks,
        steals,
        personal_fouls,
        turnovers,
        mins_played,
        games_in_group
    FROM 
        grouped_games
    where 
       TO_NUMBER(SUBSTRING(season, 1, 4)) BETWEEN 2000 AND 2022

),

player_efficiency AS (
    SELECT 
        player_id,
        player_name, 
        game_group,
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
        total_rebounds,
        offensive_rebounds,
        defensive_rebounds,
        assists,
        blocks,
        steals,
        personal_fouls,
        turnovers,
        mins_played
    FROM
        adding_pgl
),

game_group_count AS (
    SELECT 
        player_id,
        COUNT(DISTINCT game_group) AS num_game_groups -- Change to game_group or actual seasons
    FROM 
        adding_pgl
    GROUP BY 
        player_id
),

best_game_group AS (
    SELECT 
        player_id, 
        player_name,
        game_group,
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
        best_game_group bgg ON pe.player_id = bgg.player_id AND pe.game_group = bgg.game_group
    WHERE 
        bgg.rank IS NULL OR bgg.rank > 1
    GROUP BY 
        pe.player_id, pe.player_name
),
joined AS (
    SELECT 
        bgg.player_id,
        bgg.player_name,
        bgg.game_group as best_game_group,
        bgg.player_efficiency_rating as best_game_group_per,
        ae.avg_per_excluding_best,
        bgg.player_efficiency_rating - ae.avg_per_excluding_best as per_difference,
        ggc.num_game_groups
    FROM 
        best_game_group bgg
    JOIN 
        average_efficiency_excluding_best ae ON bgg.player_id = ae.player_id
    JOIN 
        game_group_count ggc ON bgg.player_id = ggc.player_id
    WHERE 
        bgg.rank = 1
        AND bgg.player_efficiency_rating between 22 AND 30 -- Define the 'great' threshold
        AND ae.avg_per_excluding_best < 17 -- Define the 'terrible' threshold
        AND ggc.num_game_groups > 5 -- Players with more than 5 seasons
)

SELECT * FROM joined
ORDER BY best_game_group_per DESC
