# Import the pandas library for data manipulation
import pandas as pd

# Import specific functions from the nba_api package for retrieving game and player data
from nba_api.stats.endpoints import leaguegamefinder

# Use the LeagueGameFinder endpoint to retrieve game data:
# - player_or_team_abbreviation="T": Fetch data for teams (not individual players)
# - season_nullable="2022-23": Specify the desired season
# - league_id_nullable="00": Identify the NBA as the target league (its ID is "00")
games_df = leaguegamefinder.LeagueGameFinder(
    player_or_team_abbreviation="T", 
    season_type_nullable = "Regular Season",
    season_nullable="2022-23", 
    league_id_nullable="00"
# Convert the API response into a pandas DataFrame
).league_game_finder_results.get_data_frame() 

#download to CSV
games_df.to_csv("games.csv", index=False)
# play_by_play_combined.to_csv("play_by_play", index = False)