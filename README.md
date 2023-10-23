# NBA
This repository provides a comprehensive guide on extracting, storing, transforming, and serving data from the official NBA API.

# Overview
This ongoingproject aims to provide a holistic approach to NBA data analysis. Current offerings include:

 - **Data Extraction**:
    - Retrieval of data from the [NBA API](https://github.com/swar/nba_api) through Python scripts.
    - Conversion of this data to .csv format.
  - **Data Storage**:
    - Utilizing [SnowSQL](https://docs.snowflake.com/en/user-guide/snowsql) to persist .csv data as tables in Snowflake.


## Prerequisites
Ensure the following are set up on your system before diving in:

- **Python**: This project uses Python 3.11, but other versions might work.
- **NBA API Package**: Install the required Python package using pip:
```
pip install nba_api
```

## Data Ingestion

Run the Python scripts located in the `extract` directory in your terminal or code editor of choice. These scripts will ingest data from various NBA API endpoints and save them as CSV files. Once executed, you will find the following CSV files in your `extract` folder:

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
1. Refer to the provided code in the storage file.
2. For a more in-depth guide, check out Phil Dakin's SnowSQL tutorial.
Use SnowSQL to store data as tables in Snowflake. You can reference the code in the `storage` file I provided or you can follow along with [Phil Dakin's excellent SnowSQL tutorial](https://medium.com/@philipdakin/dbt-snowflake-basic-model-setup-845122814178).

## Data Modeling
Model your data using [Paradime.io](https://www.paradime.io/) or your preferred dbt platform/IDE:
1. Execute the SQL files located in the [Models](https://github.com/jpooksy/NBA_Data_Modeling/tree/f156aa2664eae0c26469aeb7181b8326a7d82a9e/nba/models) directory:

- [Sources](https://github.com/jpooksy/NBA_Data_Modeling/tree/cc45da4cf7b2fdea6a5e74e861d98e366ed70c82/nba/models/staging):
  - [source_player_game_logs.sql](https://github.com/jpooksy/NBA_Data_Modeling/blob/cc45da4cf7b2fdea6a5e74e861d98e366ed70c82/nba/models/staging/source_player_game_logs.sql): stats and details on every game from the 2022-23 nba season
  - [source_player_salaries.sql](https://github.com/jpooksy/NBA_Data_Modeling/blob/cc45da4cf7b2fdea6a5e74e861d98e366ed70c82/nba/models/staging/source_player_salaries.sql): details on individual player salaries from the 2022-23 season and beyond.
  - [source_team_salaries.sql](https://github.com/jpooksy/NBA_Data_Modeling/blob/cc45da4cf7b2fdea6a5e74e861d98e366ed70c82/nba/models/staging/source_team_salaries.sql): details on individual team salaries during the 2022-23 season.
 
- [Warehouse](https://github.com/jpooksy/NBA_Data_Modeling/tree/39bb9f1360bb2d2352724bf0b818c4715bcafc33/nba/models/warehouse):
  - [fct_player_season_stats.sql](https://github.com/jpooksy/NBA_Data_Modeling/blob/cc45da4cf7b2fdea6a5e74e861d98e366ed70c82/nba/models/warehouse/fct_player_season_stats.sql): Aggregate stats per player during the 2022-23 season.
  - [fct_team_season_stats.sql](https://github.com/jpooksy/NBA_Data_Modeling/blob/cc45da4cf7b2fdea6a5e74e861d98e366ed70c82/nba/models/warehouse/fct_team_season_stats.sql): Aggregate stats per nba team during the 2022-23 NBA season.
  - [fct_opponent_stats_per_team.sql](https://github.com/jpooksy/NBA_Data_Modeling/blob/cc45da4cf7b2fdea6a5e74e861d98e366ed70c82/nba/models/warehouse/fct_opponent_stats_per_team.sql): Aggregate stats of all the opponents stats per NBA team during the 2022-23 season.
