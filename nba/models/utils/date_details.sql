{{
    config(
        materialized = "table"
    )
}}
{{ dbt_date.get_date_dimension('2021-01-01', '2023-12-31') }}