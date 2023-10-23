WITH source AS (
    SELECT
        *
    FROM
        {{ source(
            "PUBLIC",
            "PLAYER_SALARIES_OUTPUT"
        ) }}
),
renamed AS (
    SELECT
        "full_name" as full_name,
        "2022-23" as "2022_23_salary",
        "2023-24" as "2023_24_salary",
        "2024-25" as "2024_25_salary",
        "2025-26" as "2025_26_salary",
        "2026-27" as "2026_27_salary"
    FROM
        source
)
SELECT
    *
FROM
    renamed