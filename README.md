# NBA
Using the official NBA API, this repo explains how to ingest, store, transform, and serve insights

# Overview
This is an ongoing project. As of today, this project only provides instructions for:
- Data Ingestion
- Data Storage

# Weekly repo updates schedule
- ## Week 1:
  -  Data Ingestion:
    -  Pulling data from the [NBA API](https://github.com/swar/nba_api) via Python Scripts
    -  Export data as .csvs
  -  Data Storage
    -  Use [SnowSQL](https://docs.snowflake.com/en/user-guide/snowsql) or [Snowflake Web Interface](https://docs.snowflake.com/en/user-guide/data-load-web-ui) to load data into Snowflake as Tables
- ## Week 2:
  - dbt data Transformations. Using Paradime for data transformations. 
- ## Week 3:
  - Serve insights in a BI tool
- ## Week 4:
  - Create scheduled dbt runs to ensure the NBA 2023 season data is always up to date
- ## Week 5:
  - Implement CI/CD
- ## Week 7:
  -  Add in NBA play by play data to calculate historical [RAPM](https://medium.com/@johnchenmbb/calculating-rapm-steps-1-and-2-of-my-summer-plan-1a78e1476b1f)
- ## Week 8:
  - TBD!

# Requirements
- Install Python on your system. I'm using python 3.11, but it's not required.
- Install the nba_api package using pip, run the following command:
```
pip install nba_api
```
- Run the python scripts (nba_scripts) in your terminal or editor of choice. I'm using VSCode. These scripts will ingest data from various NBA API endpoints and return them as CSVs. Once executed, you should have the following .csv files downloaded within your "nba_scripts" folder:
  - **common_player_info.csv**: Info on each player from the 2022 NBA season.
  - **games.csv**: Stats from each game played during the 2022 NBA season.
  - **player_game_logs.csv**: Detailed stats per player per game from the 2022 NBA season.
  - **player_salaries_output.csv**: Salaries data for each player during the 2022 NBA season.
  - **team_game_logs.csv**: Game statistics for each team from the 2022 NBA season.
  - **team_salaries.csv**: Salary information for each team during the 2022 NBA season.
  - **team_year_by_year_stats.csv**: Year-by-year statistics for each team during the 2022 NBA season.
  - **teams.csv**: Information about each team from the 2022 NBA season.
- Use SnowSQL to store data as tables in Snowflake. You reference the code in "setup_Snowflake_database_with_SnowSQL", or you can follow along with [Phil Dakin's](https://www.linkedin.com/in/phildakin/) excellent [SnowSQL tutorial](https://medium.com/@philipdakin/dbt-snowflake-basic-model-setup-845122814178)m
  - 
