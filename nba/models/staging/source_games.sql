WITH source AS (
    SELECT
        *
    FROM
        {{ source(
            "PUBLIC",
            "GAMES"
        ) }}
),
renamed AS (
    SELECT
        SEASON_ID as season_id,
        TEAM_ID as team_id, 
        TEAM_ABBREVIATION as team_abbreviation,
        TEAM_NAME as team_name, 
        GAME_ID as game_id,
        GAME_DATE as game_date,
        MATCHUP as matchup,
        WL AS win_loss,
        "MIN" AS game_duration_mins,
        PTS AS points,
        FGM AS field_goals_made,
        FGA AS field_goals_attempted,
        FG_PCT AS field_goal_pct,
        FG3M AS three_point_made,
        FG3A AS three_point_attempted,
        FG3_PCT AS three_point_pct,
        FTM AS free_throws_made,
        FTA AS free_throws_attempted,
        FT_PCT AS free_throw_pct,
        OREB AS offensive_rebounds,
        DREB AS defensive_rebounds,
        REB AS total_rebounds,
        AST AS assists,
        STL AS steals,
        BLK AS blocks,
        TOV AS turnovers,
        PF AS personal_fouls,
        PLUS_MINUS
    FROM
        source
)
SELECT
    *
FROM
    renamed