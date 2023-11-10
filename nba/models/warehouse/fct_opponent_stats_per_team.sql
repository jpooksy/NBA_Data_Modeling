{{
    config (
        materialized = 'table'
    )
}}

with team_stats as (
    select
        g1.game_id,
        g1.team_id,
        g1.team_name,
        g2.win_loss,
        g2.points,
        g2.field_goals_made,
        g2.field_goals_attempted,
        g2.field_goal_pct,
        g2.three_point_made,
        g2.three_point_attempted,
        g2.three_point_pct,
        g2.free_throws_made,
        g2.free_throws_attempted,
        g2.free_throw_pct,
        g2.offensive_rebounds,
        g2.defensive_rebounds,
        g2.total_rebounds,
        g2.assists,
        g2.steals,
        g2.blocks,
        g2.turnovers,
        g2.personal_fouls,
        g2.plus_minus
    from
        {{ ref('source_games') }} g1
    join
        {{ ref('source_games') }} g2
        on g1.game_id = g2.game_id and g1.team_id <> g2.team_id
)
-- select and aggregate data from the teamstats cte
    -- this section calculates various statistics for each team, such as total wins, losses, points, averages, etc.
select
    ts.team_id as team_id,
    ts.team_name as team_name,
    sum(ts.points) as tot_opp_points,
    avg(ts.points) as avg_opp_points,
    sum(ts.field_goals_made) as tot_opp_field_goals_made,
    avg(ts.field_goals_made) as avg_opp_field_goals_made,
    sum(ts.field_goals_attempted) as tot_opp_field_goals_attempted,
    avg(ts.field_goals_attempted) as avg_opp_field_goals_attempted,
    avg(ts.field_goal_pct) as avg_opp_field_goal_percentage,
    sum(ts.three_point_made) as tot_opp_three_pointers_made,
    avg(ts.three_point_made) as avg_opp_three_pointers_made,
    sum(ts.three_point_attempted) as tot_opp_three_pointers_attempted,
    avg(ts.three_point_attempted) as avg_opp_three_pointers_attempted,
    avg(ts.three_point_pct) as avg_opp_three_pointers_percentage,
    sum(ts.free_throws_made) as tot_opp_free_throws_made,
    avg(ts.free_throws_made) as avg_opp_free_throws_made,
    sum(ts.free_throws_attempted) as tot_opp_free_throws_attempted,
    avg(ts.free_throws_attempted) as avg_opp_free_throws_attempted,
    avg(ts.free_throw_pct) as avg_opp_free_throw_percentage,
    sum(ts.total_rebounds) as tot_opp_total_rebounds,
    avg(ts.total_rebounds) as avg_opp_total_rebounds,
    sum(ts.offensive_rebounds) as tot_opp_offensive_rebounds,
    avg(ts.offensive_rebounds) as avg_opp_offensive_rebounds,
    sum(ts.defensive_rebounds) as tot_opp_defensive_rebounds,
    avg(ts.defensive_rebounds) as avg_opp_defensive_rebounds,
    sum(ts.assists) as tot_opp_assists,
    avg(ts.assists) as avg_opp_assists,
    sum(ts.steals) as tot_opp_steals,
    avg(ts.steals) as avg_opp_steals,
    sum(ts.blocks) as tot_opp_blocks,
    avg(ts.blocks) as avg_opp_blocks,
    sum(ts.turnovers) as tot_opp_turnovers,
    avg(ts.turnovers) as avg_opp_turnovers,
    sum(ts.personal_fouls) as tot_opp_personal_fouls,
    avg(ts.personal_fouls) as avg_opp_personal_fouls,
    sum(ts.plus_minus) as tot_opp_plus_minus,
    avg(ts.plus_minus) as avg_opp_plus_minus
from
    team_stats ts
group by
    ts.team_id,
    ts.team_name
order by
    ts.team_id