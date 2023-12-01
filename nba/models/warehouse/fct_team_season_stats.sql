with team_stats as (
    select
        *
    from
        {{ ref('source_team_year_by_year_stats') }}
),

games as (
    select
        *
    from 
        {{ ref('intermediate_games_agg') }}
),

team_salaries as (
    select 
        full_name,
        (total_cap + luxury_tax_bill) as total_team_spend
    from 
        {{ ref('source_team_salaries') }}
), 

joined as (
    select
        t.*,
        g.* EXCLUDE(team_id),
        ts.* EXCLUDE(full_name)
    from
        team_stats t
    join
        games g on t.team_id = g.team_id
    join
        team_salaries ts on t.team_full_name = ts.full_name  
)

select 
    *
from 
    joined