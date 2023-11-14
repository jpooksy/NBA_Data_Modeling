with source as (
    select 
        * 
    from 
        {{ ref('source_player_salaries') }}
)

select 
    *
from 
    source
where "2022_23_salary" IS NOT NULL