WITH ranked_games AS (
  SELECT
    team_id,
    game_id,
    team_name,
    game_date,
    month(game_date) as season_month,
    ROW_NUMBER() OVER (PARTITION BY team_id ORDER BY game_date, game_id) AS game_rank
  FROM
    {{ ref('source_games') }}
)
SELECT
    team_id,
    game_id,
    team_name,
    game_rank,
    game_date,
    CASE 
        WHEN game_rank BETWEEN 1 AND 20 THEN 1
        WHEN game_rank BETWEEN 21 AND 41 THEN 2
        WHEN game_rank BETWEEN 42 AND 61 THEN 3
        WHEN game_rank BETWEEN 62 AND 82 THEN 4
    END AS season_quarter,
    CASE 
        WHEN season_month = 10 THEN 1
        WHEN season_month = 11 THEN 2
        WHEN season_month = 12 THEN 3
        WHEN season_month = 1 THEN 4
        WHEN season_month = 2 THEN 5
        WHEN season_month = 3 THEN 6
        WHEN season_month = 4 THEN 7
    END AS season_month
FROM
  ranked_games