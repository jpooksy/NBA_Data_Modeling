with team_stats as (
    select
        team_id,
        team_full_name,
        season,
        games_played,
        wins,
        losses,
        conference_rank,
        division_rank,
        playoff_wins,
        playoff_losses,
        nba_finals_appearance
    from
        {{ ref('source_team_stats') }}
    WHERE TO_NUMBER(SUBSTRING(season, 1, 4)) BETWEEN 1970 AND 2022
),

team_salaries as (
    select 
        team_id,
        current_team_name,
        season,
        team_payroll + luxury_tax_bill as total_spend,
        (team_payroll + luxury_tax_bill) * inflation_rate_calc as total_spend_inflation_adj
    from 
        {{ ref('intermediate_team_spend') }}
), 

joined as (
    select
        t.*,
        ts.* EXCLUDE(team_id,season),
        ts.total_spend/t.wins as cost_per_win,
        (ts.total_spend_inflation_adj/t.wins) as cost_per_win_inflation_adj
    from
        team_stats t
    left join
        team_salaries ts 
        on t.team_id = ts.team_id 
            and t.season = ts.season
)

select 
    *
from 
    joined