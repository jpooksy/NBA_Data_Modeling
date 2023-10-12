# NBA
This repository provides a guide on how to ingest, store, transform, and analyze data from the official NBA API.

# Overview
This is an ongoing project that aims to cover various aspects of NBA data analysis. As of today, this project provides instructions for:

- Data Ingestion
- Data Storage

# Weekly repo updates schedule
- **Week 1**:
  - **Data Ingestion**:
    - Pulling data from the [NBA API](https://github.com/swar/nba_api) using Python scripts.
    - Exporting data as .csv files.
  - **Data Storage**:
    - Using [SnowSQL](https://docs.snowflake.com/en/user-guide/snowsql) or the [Snowflake Web Interface](https://docs.snowflake.com/en/user-guide/data-load-web-ui) to load data into Snowflake as tables.

- **Week 2**:
  - **Data Transformations**:
    - Using Paradime for data transformations.

- **Week 3**:
  - **Serve Insights in a BI Tool**.

- **Week 4**:
  - Creating scheduled dbt runs to ensure NBA 2023 season data is always up to date.

- **Week 5**:
  - Implementing CI/CD.

- **Week 7**:
  - Adding NBA play-by-play data to calculate historical [RAPM](https://medium.com/@johnchenmbb/calculating-rapm-steps-1-and-2-of-my-summer-plan-1a78e1476b1f).

- **Week 8**:
  - TBD!

# Requirements
Before getting started, make sure you have the following requirements in place:

- Python installed on your system (Python 3.11 is used in this project, but it's not required).
- Install the `nba_api` package using pip:
```
pip install nba_api
```

## Data Ingestion

Run the Python scripts located in the `nba_scripts` directory in your terminal or code editor of choice. These scripts will ingest data from various NBA API endpoints and save them as CSV files. Once executed, you will find the following CSV files in your `nba_scripts` folder:

- `common_player_info.csv`: Information on each player from the 2022 NBA season.
- `games.csv`: Statistics from each game played during the 2022 NBA season.
- `player_game_logs.csv`: Detailed statistics per player per game from the 2022 NBA season.
- `player_salaries_output.csv`: Salaries data for each player during the 2022 NBA season.
- `team_game_logs.csv`: Game statistics for each team from the 2022 NBA season.
- `team_salaries.csv`: Salary information for each team during the 2022 NBA season.
- `team_year_by_year_stats.csv`: Year-by-year statistics for each team during the 2022 NBA season.
- `teams.csv`: Information about each team from the 2022 NBA season.

Note: If you get stuck, you can download the `nba_compressed_CSVs` and more on to the next step - Data Storage

## Data Storage

Use SnowSQL to store data as tables in Snowflake. You can reference the code in the `setup_Snowflake_database_with_SnowSQL` file or follow along with [Phil Dakin's excellent SnowSQL tutorial](https://medium.com/@philipdakin/dbt-snowflake-basic-model-setup-845122814178).
