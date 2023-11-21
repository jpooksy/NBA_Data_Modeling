with team_stats as (
    select
        g1.game_id,
        g1.team_id,
        g1.team_name,
        g2.win_loss,
        (g2.points - g1.points) as point_differential,
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
), final as (
select
    team_id as team_id,
    team_name as team_name,
    sum(points) as tot_opp_points,
    avg(points) as avg_opp_points,
    sum(field_goals_made) as tot_opp_field_goals_made,
    avg(field_goals_made) as avg_opp_field_goals_made,
    sum(field_goals_attempted) as tot_opp_field_goals_attempted,
    avg(field_goals_attempted) as avg_opp_field_goals_attempted,
    avg(field_goal_pct) as avg_opp_field_goal_percentage,
    sum(three_point_made) as tot_opp_three_pointers_made,
    avg(three_point_made) as avg_opp_three_pointers_made,
    sum(three_point_attempted) as tot_opp_three_pointers_attempted,
    avg(three_point_attempted) as avg_opp_three_pointers_attempted,
    avg(three_point_pct) as avg_opp_three_pointers_percentage,
    sum(free_throws_made) as tot_opp_free_throws_made,
    avg(free_throws_made) as avg_opp_free_throws_made,
    sum(free_throws_attempted) as tot_opp_free_throws_attempted,
    avg(free_throws_attempted) as avg_opp_free_throws_attempted,
    avg(free_throw_pct) as avg_opp_free_throw_percentage,
    sum(total_rebounds) as tot_opp_total_rebounds,
    avg(total_rebounds) as avg_opp_total_rebounds,
    sum(offensive_rebounds) as tot_opp_offensive_rebounds,
    avg(offensive_rebounds) as avg_opp_offensive_rebounds,
    sum(defensive_rebounds) as tot_opp_defensive_rebounds,
    avg(defensive_rebounds) as avg_opp_defensive_rebounds,
    sum(assists) as tot_opp_assists,
    avg(assists) as avg_opp_assists,
    sum(steals) as tot_opp_steals,
    avg(steals) as avg_opp_steals,
    sum(blocks) as tot_opp_blocks,
    avg(blocks) as avg_opp_blocks,
    sum(turnovers) as tot_opp_turnovers,
    avg(turnovers) as avg_opp_turnovers,
    sum(personal_fouls) as tot_opp_personal_fouls,
    avg(personal_fouls) as avg_opp_personal_fouls,
    sum(plus_minus) as tot_opp_plus_minus,
    avg(plus_minus) as avg_opp_plus_minus,
    sum(point_differential) as tot_point_diff,
    avg(point_differential) as avg_point_dif
from
    team_stats ts
group by
    team_id,
    team_name
order by
    tot_point_diff desc
)

Select * from final