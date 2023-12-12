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

- `all_common_player_info.csv`: Information on each player from the 1950-2023 NBA season.
- `games.csv`: Statistics from each game played during the 1950-2023 NBA season.
- `player_game_logs.csv`: Detailed statistics per player per game from the 1970-2023 NBA season.
- `player_salaries.csv`: Salaries data for each player during the 1990-2023 NBA season.
- `team_spend.csv`: Salary information for each team during the 1990-2023 NBA season.
- `team_year_by_year_stats.csv`: Year-by-year statistics for each team during the 1950-2023 NBA season.
- `teams.csv`: Information about each team from the 1950-2023 NBA season.

Note: If you get stuck, you can download the `nba_compressed_CSVs`, but this only includes data from the 2022-23 NBA season

## Data Storage
1. Refer to the provided code in the storage file.
2. For a more in-depth guide, check out Phil Dakin's SnowSQL tutorial.
Use SnowSQL to store data as tables in Snowflake. You can reference the code in the `storage` file I provided or you can follow along with [Phil Dakin's excellent SnowSQL tutorial](https://medium.com/@philipdakin/dbt-snowflake-basic-model-setup-845122814178).

## Data Modeling
Model your data using [Paradime.io](https://www.paradime.io/) or your preferred dbt platform/IDE.

## Insights so far:

![image](https://github.com/jpooksy/NBA_Data_Modeling/assets/107123308/3b849e88-7207-4730-aaed-60eb6b476209)

