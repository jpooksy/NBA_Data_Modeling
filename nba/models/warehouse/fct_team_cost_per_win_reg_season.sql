with team_stats as (
    select
        team_id,
        current_team_name,
        round(avg(cost_per_win),0) as avg_cost_per_win,
        round(avg(cost_per_win_inflation_adj),0) as avg_cost_per_win_inflation_adj,
        round(avg(total_spend),0) as avg_total_spend,
        round(avg(total_spend_inflation_adj),0) as avg_total_spend_inflation_adjusted
    from 
        {{ ref('dim_team_stats_by_season') }}
    WHERE TO_NUMBER(SUBSTRING(season, 1, 4)) BETWEEN 1990 AND 2022
    group by 
        1,2
    order by team_id
)

select 
    * 
from
    team_stats
order by avg_cost_per_win asc

