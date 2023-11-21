with players_by_college as (
    select 
        school,
        count(*) as player_count
    from 
        {{ ref('source_common_player_info') }}
    where
        school is not null -- This ensures that only rows with a non-null school are included
    group by
        school
    order by
        player_count desc -- This orders the results by the number of players, from highest to lowest
)

select 
    *
from 
    players_by_college
