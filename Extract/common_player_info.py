# Import the pandas library for data manipulation.
import pandas as pd

# Import the CommonPlayerInfo function from the nba_api's stats.endpoints module.
from nba_api.stats.endpoints import CommonPlayerInfo

# Import players and player_index_is_active from the nba_api's stats.library.data module.
from nba_api.stats.library.data import players, player_index_is_active

# Define a function to get active NBA players.
def get_active_players():
    """Return a DataFrame of active players."""
    # Convert the players list to a pandas DataFrame.
    df = pd.DataFrame(players)
    # Filter and return only the active players.
    return df[df[player_index_is_active]]

# Define a function to fetch detailed player information using a player's ID.
def fetch_player_info(player_id):
    """Retrieve player info given a player ID."""
    # Define the parameters needed for the API call.
    params = {
        "player_id": player_id,
        "league_id_nullable": "00",  # Specify the NBA league ID.
    }
    # Make the API call to get player info.
    common_player_info = CommonPlayerInfo(**params)
    # Extract and return the DataFrame containing the player's information.
    return common_player_info.get_data_frames()[0]

# Define the main routine of the script.
def main():
    # Fetch a DataFrame of active NBA players.
    active_players_df = get_active_players()

    # Extract player IDs from the first column of the DataFrame.
    player_ids = active_players_df.iloc[:, 0].tolist()

    # Use list comprehension to fetch detailed data for all active players.
    all_player_info_data = [fetch_player_info(player_id) for player_id in player_ids]

    # Combine all individual player DataFrames into a single DataFrame.
    combined_data = pd.concat(all_player_info_data, ignore_index=True)

    # Select the columns you want to export.
    columns_to_export = [
        "FIRST_NAME", "LAST_NAME", "DISPLAY_FIRST_LAST", "BIRTHDATE", "SCHOOL", "COUNTRY",
        "HEIGHT", "WEIGHT", "SEASON_EXP", "POSITION", "ROSTERSTATUS", "TEAM_ID", "TEAM_NAME", 
        "FROM_YEAR", "TO_YEAR", "DLEAGUE_FLAG", "GAMES_PLAYED_FLAG", "DRAFT_ROUND",	"DRAFT_NUMBER",	"GREATEST_75_FLAG"
    ]
    combined_data = combined_data[columns_to_export]

    # Save the selected columns to a CSV file.
    combined_data.to_csv("common_player_info.csv", index=False)

    # Print a success message to the console.
    print("Data has been saved as common_player_info.csv")

# Ensure the main routine is executed only when the script is run directly (not when imported).
if __name__ == "__main__":
    main()
