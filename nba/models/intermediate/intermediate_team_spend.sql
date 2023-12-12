with team_spend as (
    select 
        team_id,
        team_city,
        team_name,
        full_name,
        season,
        CASE
            WHEN season = '1990-91' THEN 2.3483
            WHEN season = '1991-92' THEN 2.2227
            WHEN season = '1992-93' THEN 2.1663
            WHEN season = '1993-94' THEN 2.098
            WHEN season = '1994-95' THEN 2.0463
            WHEN season = '1995-96' THEN 1.9905
            WHEN season = '1996-97' THEN 1.9376
            WHEN season = '1997-98' THEN 1.8804
            WHEN season = '1998-99' THEN 1.8513
            WHEN season = '1999-00' THEN 1.8209
            WHEN season = '2000-01' THEN 1.7723
            WHEN season = '2001-02' THEN 1.7086
            WHEN season = '2002-03' THEN 1.6893
            WHEN season = '2003-04' THEN 1.6465
            WHEN season = '2004-05' THEN 1.6154
            WHEN season = '2005-06' THEN 1.5688
            WHEN season = '2006-07' THEN 1.5087
            WHEN season = '2007-08' THEN 1.478
            WHEN season = '2008-09' THEN 1.4173
            WHEN season = '2009-10' THEN 1.4169
            WHEN season = '2010-11' THEN 1.3807
            WHEN season = '2011-12' THEN 1.3585
            WHEN season = '2012-13' THEN 1.3199
            WHEN season = '2013-14' THEN 1.2992
            WHEN season = '2014-15' THEN 1.279
            WHEN season = '2015-16' THEN 1.279
            WHEN season = '2016-17' THEN 1.2628
            WHEN season = '2017-18' THEN 1.232
            WHEN season = '2018-19' THEN 1.207
            WHEN season = '2019-20' THEN 1.1885
            WHEN season = '2020-21' THEN 1.1597
            WHEN season = '2021-22' THEN 1.1437
            WHEN season = '2022-23' THEN 1.0641
        ELSE 1
    END AS inflation_rate_calc,
        team_payroll,
        CASE
            WHEN luxury_tax_bill < 0 THEN 0
            ELSE luxury_tax_bill
            END AS luxury_tax_bill
    from 
        {{ ref('source_team_spend') }}
    WHERE TO_NUMBER(SUBSTRING(season, 1, 4)) BETWEEN 1990 AND 2022
),

team_stats as (
    select 
        team_id, 
        team_city, 
        team_name, 
        season, 
        games_played,
        wins, 
        losses,
        playoff_wins,
        playoff_losses,
        nba_finals_appearance
    from 
        {{ ref('source_team_stats') }}
),

joined as (
    select 
        team_stats.team_id,
        team_stats.team_name,
        team_stats.team_city,
        team_stats.season,
        team_spend.team_payroll,
        team_spend.luxury_tax_bill,
        team_spend.inflation_rate_calc,
        team_spend.team_name as current_team_name,
        team_spend.team_city as current_team_city
    from 
        team_stats
    left join team_spend 
        on team_stats.team_id = team_spend.team_id
            and team_stats.season = team_spend.season
)

select 
    * 
from 
    joined