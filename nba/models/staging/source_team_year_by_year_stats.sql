WITH source AS (
    SELECT
        *
    FROM {{ source(
            "PUBLIC",
            "TEAM_YEAR_BY_YEAR_STATS"
            ) }}
),

renamed as (
    SELECT
        TEAM_ID,
        concat(TEAM_CITY, ' ', team_name) as team_full_name,
        YEAR,
        GP as games_played,
        WINS,
        LOSSES,
        FGM as field_goals_made,
        FGA as field_goals_attempted,
        FG3M as three_pointers_made,
        FG3A as three_pointers_attempted,
        FTM as free_throws_made,
        FTA as free_throws_attempted,
        OREB as offensive_rebounds,
        DREB as defensive_rebounds,
        REB as total_rebounds,
        AST as assists,
        PF as personal_fouls,
        STL as steals,
        TOV as turnovers,
        BLK as blocks,
        PTS as points
    from 
        source
)

SELECT 
    *
FROM
    renamed