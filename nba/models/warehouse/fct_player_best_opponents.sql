WITH player_stats AS (
    SELECT
        p.player_id,
        player_name,
        g.team_name AS opponent,
        AVG(p.points) AS avg_points_scored
    FROM
        {{ ref('source_player_game_logs') }} p
    JOIN
        {{ ref('source_games') }} g
        ON 
            p.game_id = g.game_id
    GROUP BY
        p.player_id, player_name, g.team_name
),

ranked_opponents as (

    select 
        *,
        RANK() OVER (PARTITION BY PLAYER_ID ORDER BY avg_points_scored DESC) AS opponent_rank
    from 
        player_stats
)

select 
    * 
from 
    ranked_opponents 
where 
    opponent_rank = 1
order by 
    player_id
