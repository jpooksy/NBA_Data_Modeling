with source as (
    select 
        *
    from 
        {{multi_engine_ref(source_name = "public", table_name = "common_player_info")}}
),

renamed as (
    select
        person_id as player_id,
        first_name,
        last_name,
        display_first_last as full_name,
        DATE(birthdate) AS birthdate, 
        school,
        country,
        (CAST(SPLIT_PART(HEIGHT, '-', 1) AS INT) * 12) + CAST(SPLIT_PART(HEIGHT, '-', 2) AS INT) as height_in_inches,
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
    