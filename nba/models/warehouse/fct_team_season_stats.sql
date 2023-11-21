with team_stats as (
    select
        team_id,
        team_name,
        win_loss,
        points,
        field_goals_made,
        field_goals_attempted,
        field_goal_pct,
        three_point_made,
        three_point_attempted,
        three_point_pct,
        free_throws_made,
        free_throws_attempted,
        free_throw_pct,
        offensive_rebounds,
        defensive_rebounds,
        total_rebounds,
        assists,
        steals,
        blocks,
        turnovers,
        personal_fouls,
        plus_minus
    from
        {{ ref('source_games') }} as ts
),

team_salaries as (
    select 
        full_name,
        (total_cap + luxury_tax_bill) as total_team_cap
    from 
        {{ ref('source_team_salaries') }} tsal
)

select
    ts.team_id as team_id,
    ts.team_name as team_name,
    tsal.total_team_cap,
    tsal.total_team_cap / sum(case when ts.win_loss = 'W' then 1 else 0 end) as cost_per_win,
    sum(case when ts.win_loss = 'W' then 1 else 0 end) as total_wins,
    sum(case when ts.win_loss = 'L' then 1 else 0 end) as total_losses,
    sum(ts.points) as tot_points,
    avg(ts.points) as avg_points,
    sum(ts.field_goals_made) as tot_field_goals_made,
    avg(ts.field_goals_made) as avg_field_goals_made,
    sum(ts.field_goals_attempted) as tot_field_goals_attempted,
    avg(ts.field_goals_attempted) as avg_field_goals_attempted,
    avg(ts.field_goal_pct) as avg_field_goal_percentage,
    sum(ts.three_point_made) as tot_three_pointers_made,
    avg(ts.three_point_made) as avg_three_pointers_made,
    sum(ts.three_point_attempted) as tot_three_pointers_attempted,
    avg(ts.three_point_attempted) as avg_three_pointers_attempted,
    avg(ts.three_point_pct) as avg_three_pointers_percentage,
    sum(ts.free_throws_made) as tot_free_throws_made,
    avg(ts.free_throws_made) as avg_free_throws_made,
    sum(ts.free_throws_attempted) as tot_free_throws_attempted,
    avg(ts.free_throws_attempted) as avg_free_throws_attempted,
    avg(ts.free_throw_pct) as avg_free_throw_percentage,
    sum(ts.total_rebounds) as tot_total_rebounds,
    avg(ts.total_rebounds) as avg_total_rebounds,
    sum(ts.offensive_rebounds) as tot_offensive_rebounds,
    avg(ts.offensive_rebounds) as avg_offensive_rebounds,
    sum(ts.defensive_rebounds) as tot_defensive_rebounds,
    avg(ts.defensive_rebounds) as avg_defensive_rebounds,
    sum(ts.assists) as tot_assists,
    avg(ts.assists) as avg_assists,
    sum(ts.steals) as tot_steals,
    avg(ts.steals) as avg_steals,
    sum(ts.blocks) as tot_blocks,
    avg(ts.blocks) as avg_blocks,
    sum(ts.turnovers) as tot_turnovers,
    avg(ts.turnovers) as avg_turnovers,
    sum(ts.personal_fouls) as tot_personal_fouls,
    avg(ts.personal_fouls) as avg_personal_fouls,
    sum(ts.plus_minus) as tot_plus_minus,
    avg(ts.plus_minus) as avg_plus_minus
from
    team_stats ts
join
    team_salaries tsal on ts.team_name = tsal.full_name -- Join based on team_name
group by
    ts.team_id,
    ts.team_name,
    tsal.total_team_cap -- Include total_team_cap in the GROUP BY clause
order by
    ts.team_id1
