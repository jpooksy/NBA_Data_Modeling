with source as (
    select *
    from {% if target.name == "dev_duck_db" -%}
            {{ ref('common_player_info') }}
         {%- else -%}
            {{ source(
                "PUBLIC",
                "COMMON_PLAYER_INFO"
            ) }}
         {%- endif %}

),

renamed as (
    select
        person_id,
        first_name,
        last_name,
        display_first_last as full_name,
        school,
        country,
        (CAST(SPLIT_PART(height, '-', 1) AS INT) * 12) + CAST(SPLIT_PART(height, '-', 2) AS INT) as height_in_inches,
        weight,
        season_exp as seasons_played,
        position,
        rosterstatus as roster_status,
        team_id,
        team_name,
        from_year as first_year_played,
        to_year as last_year_played,
        dleague_flag as g_league_has_played,
        games_played_flag as games_played,
        draft_round,
        draft_number,
        greatest_75_flag as greatest_75_member
    from
        source
)

select *
from
    renamed
