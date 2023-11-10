with base as (
    select * from {{ ref('fct_player_season_stats') }}
)

staging as (
    select
        date_func(month) as quarter_of_season,
        base.* except month
    from base
    group by 1
)

select * from staging