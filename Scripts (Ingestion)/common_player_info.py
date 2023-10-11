import pandas as pd
from nba_api.stats.endpoints import CommonPlayerInfo
from nba_api.stats.library.data import players
from nba_api.stats.library.data import player_index_is_active

# Convert players list to a DataFrame
df = pd.DataFrame(players)

# Filter only active players
active_players_df = df[df[player_index_is_active]]

# Get a Python list of all values from the first column
player_ids = active_players_df.iloc[:, 0].tolist()

# Initialize an empty list to store the DataFrames
all_player_info_data = []

# Loop through each player ID and retrieve their information
for player_id in player_ids:
    params = {
        "player_id": player_id,
        "league_id_nullable": "00",
    }
    common_player_info = CommonPlayerInfo(**params)
    player_info_data = common_player_info.get_data_frames()[0]
    
    # Append the player's information DataFrame to the list
    all_player_info_data.append(player_info_data)

# Concatenate the list of DataFrames into a single DataFrame
combined_data = pd.concat(all_player_info_data, ignore_index=True)

# Save the combined data as a CSV file
combined_data.to_csv("common_player_info.csv", index=False)

print("Data has been saved as common_player_info.csv")
