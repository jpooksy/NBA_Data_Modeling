# Import necessary libraries
import pandas as pd
from nba_api.stats.endpoints import playergamelogs

# Retrieve player game-by-game statistics for the NBA season 2022-23
player_game_logs_df = playergamelogs.PlayerGameLogs(
    season_nullable="2022-23",               # Target season
    season_type_nullable="Regular Season",  # Specify regular season games
    league_id_nullable="00"                 # NBA's ID
).player_game_logs.get_data_frame()

# Save the retrieved data to a CSV file
player_game_logs_df.to_csv("player_game_logs.csv", index=False)
