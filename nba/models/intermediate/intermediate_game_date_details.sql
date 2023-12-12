WITH ranked_games AS (
    SELECT
        team_id,
        game_id,
        team_name,
        game_date,
        season,
        month(game_date) as season_month,
        CASE
            WHEN game_type = 'Regular Season' THEN
                ROW_NUMBER() OVER (PARTITION BY team_id, season ORDER BY game_date, game_id)
            WHEN game_type = 'Playoffs' THEN
                ROW_NUMBER() OVER (PARTITION BY team_id, season ORDER BY game_date, game_id) + MAX(CASE WHEN game_type = 'Regular Season' THEN 1 ELSE 0 END) OVER (PARTITION BY team_id, season)
        END AS game_rank,
        game_type
    FROM
        {{ ref('source_games') }}
    WHERE 
        game_type IN ('Regular Season', 'Playoffs')
)
SELECT
    team_id,
    game_id,
    team_name,
    game_rank,
    game_date,
    season_month,
    season,
    game_type
FROM
    ranked_games
