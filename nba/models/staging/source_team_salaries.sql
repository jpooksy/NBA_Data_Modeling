WITH source AS (
    SELECT
        *
    FROM
        {{ source(
            "PUBLIC",
            "TEAM_SALARIES"
        ) }}
),
renamed AS (
    SELECT
        "Team" as full_name,
        "Total Cap" as total_cap,
        "Luxury Tax Bill" as luxury_tax_bill
    FROM
        source
)
SELECT
    *
FROM
    renamed