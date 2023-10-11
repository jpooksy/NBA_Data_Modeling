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
    -  Use [SnowSQL](https://docs.snowflake.com/en/user-guide/snowsql) to load data into Snowflake snowflake Tables
- ## Week 2: Data Transformation
  - Use Paradime and dbt to model data
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
- Run the python scripts (nba_scripts) in your terminal or editor of choice. I'm using VS code. 
  - This will ingest data from various NBA API endpoints and return them as CSVs
- Use SnowSQL to store data as tables in Snowflake. You can use the file I provided, or you can follow along with [Phil Dakin's](https://www.linkedin.com/in/phildakin/) excellent [SnowSQL tutorial](https://medium.com/@philipdakin/dbt-snowflake-basic-model-setup-845122814178)
