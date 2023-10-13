# Import required libraries for data handling and NBA API
import pandas as pd
from nba_api.stats.endpoints import leaguegamefinder

# Define a function to fetch NBA game data
def fetch_nba_games(season="2022-23", season_type="Regular Season"):
    """
    Retrieve game data from the specified NBA season and season type.
    
    Parameters:
    - season: The NBA season to fetch data for.
    - season_type: Type of the season (e.g., Regular, Playoffs).
    
    Returns:
    - A DataFrame containing the fetched game data.
    """
    # Use the LeagueGameFinder endpoint to fetch the desired game data
    return leaguegamefinder.LeagueGameFinder(
        player_or_team_abbreviation="T", 
        season_type_nullable=season_type,
        season_nullable=season,
        league_id_nullable="00"
    ).league_game_finder_results.get_data_frame()

# Define a function to save a DataFrame to a CSV file
def save_to_csv(dataframe, filename):
    """
    Save the provided DataFrame to a CSV file.
    
    Parameters:
    - dataframe: The DataFrame to save.
    - filename: The name of the target CSV file.
    """
    # Use the pandas functionality to write the DataFrame to a CSV
    dataframe.to_csv(filename, index=False)

# Define the main routine to fetch game data and save it to a file
def main():
    # Fetch NBA game data for the default season (2022-23) and season type (Regular Season)
    games_data = fetch_nba_games()
    
    # Save the fetched data to a CSV file named "games.csv"
    save_to_csv(games_data, "games.csv")

# Ensure the main routine runs only when the script is executed (not when imported)
if __name__ == "__main__":
    main()