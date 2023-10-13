# Import necessary libraries
import pandas as pd
from nba_api.stats.endpoints import teamgamelogs

# Retrieve team game logs for the NBA season 2022-23
team_game_logs_df = teamgamelogs.TeamGameLogs(
    season_nullable="2022-23",               # Target season
    season_type_nullable="Regular Season",  # Specify regular season games
    league_id_nullable="00"                 # NBA's ID
).team_game_logs.get_data_frame()

# Save the retrieved data to a CSV file
team_game_logs_df.to_csv("team_game_logs.csv", index=False)
