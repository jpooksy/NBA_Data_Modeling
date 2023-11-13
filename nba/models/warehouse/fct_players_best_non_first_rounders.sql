with second_rounders as (
    select 
        * 
    from 
        {{ ref('source_common_player_info') }} as cpi
    where 
        DRAFT_ROUND != '1'
)

select 
    pss.*,
    sr.draft_round,
    sr.draft_number
from
    {{ ref('fct_player_stats_by_season') }} as pss
join
    second_rounders as sr

on
    pss.player_id = sr.person_id
order by
    pss.total_plus_minus desc