# Import necessary modules
import pandas as pd
from nba_api.stats.endpoints import playergamelogs

# Define default constants for league ID, season type, and output file name
LEAGUE_ID = "00"
SEASON_TYPE = "Regular Season"
OUTPUT_FILE = "player_game_logs.csv"

# Function to fetch player game logs based on season, season type, and league ID
def fetch_player_game_logs(season, season_type=SEASON_TYPE, league_id=LEAGUE_ID):
    """Retrieve player game logs for the specified season and season type."""
    # Use the NBA API to get player game logs and return as a dataframe
    return playergamelogs.PlayerGameLogs(
        season_nullable=season, 
        season_type_nullable=season_type, 
        league_id_nullable=league_id
    ).player_game_logs.get_data_frame()

# Function to save the fetched game logs into a CSV file
def save_game_logs_to_csv(dataframe, filename):
    """Save the game logs to a CSV file."""
    # Use pandas functionality to write the dataframe to a CSV
    dataframe.to_csv(filename, index=False)

# Main function to orchestrate fetching and saving game logs
def main():
    # Define the target season
    season = "2022-23"
    
    # Fetch game logs for the specified season
    game_logs = fetch_player_game_logs(season)
    
    # Save the fetched game logs to a CSV file
    save_game_logs_to_csv(game_logs, OUTPUT_FILE)
    
    # Print a success message to console
    print(f"Game logs for season {season} saved to {OUTPUT_FILE}")

# Check if this script is run directly and if so, invoke the main function
if __name__ == "__main__":
    main()
