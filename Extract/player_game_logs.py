# Import necessary libraries
import pandas as pd
from nba_api.stats.endpoints import playergamelogs

# Define a function to get and filter player game logs for a range of seasons
def get_and_filter_player_game_logs(start_season, end_season):
    # Create an empty DataFrame to store player game logs
    all_player_logs = pd.DataFrame()

    # Define the columns you want to select
    selected_columns = [
       'PLAYER_ID', 'PLAYER_NAME', 'NICKNAME', 'TEAM_ID',
        'TEAM_ABBREVIATION', 'TEAM_NAME', 'GAME_ID', 'GAME_DATE', 'MATCHUP',
        'WL', 'MIN', 'FGM', 'FGA', 'FG_PCT', 'FG3M', 'FG3A', 'FG3_PCT',
        'FTM', 'FTA', 'FT_PCT', 'OREB', 'DREB', 'REB', 'AST', 'TOV',
        'STL', 'BLK', 'PF', 'PTS', 'PLUS_MINUS'
    ]

    # Iterate through each season in the specified range
    for season in range(start_season, end_season + 1):
        # Generate the season string in the format "YYYY-YY"
        season_str = f"{season}-{(season + 1) % 100:02d}"

        # Use the PlayerGameLogs endpoint to retrieve regular season player game logs for the current season
        regular_season_logs_df = playergamelogs.PlayerGameLogs(
            season_nullable=season_str,
            season_type_nullable="Regular Season",
            league_id_nullable="00"
        ).player_game_logs.get_data_frame()

        # Use the PlayerGameLogs endpoint to retrieve playoff player game logs for the current season
        playoff_logs_df = playergamelogs.PlayerGameLogs(
            season_nullable=season_str,
            season_type_nullable="Playoffs",
            league_id_nullable="00"
        ).player_game_logs.get_data_frame()

        # Filter the DataFrames to include only the selected columns
        regular_season_logs_df = regular_season_logs_df[selected_columns]
        playoff_logs_df = playoff_logs_df[selected_columns]

        # Add a new column "season" with the season string to the DataFrames
        regular_season_logs_df['season'] = season_str
        playoff_logs_df['season'] = season_str

        # Add a new column "game_type" with the season type to the DataFrames
        regular_season_logs_df['game_type'] = "Regular Season"
        playoff_logs_df['game_type'] = "Playoffs"

        # Print information about the current season
        print(f"Season {season_str} (Regular Season): {len(regular_season_logs_df)} player game logs")
        print(f"Season {season_str} (Playoffs): {len(playoff_logs_df)} player game logs")

        # Append the current season's player game logs to the overall DataFrame
        all_player_logs = pd.concat([all_player_logs, regular_season_logs_df, playoff_logs_df], ignore_index=True)

    # Return the DataFrame containing filtered player game logs for the specified range of seasons
    return all_player_logs

# Example usage:
# Set the start and end seasons
start_season = 1970
end_season = 2022

# Call the function to get and filter player game logs for the specified range of seasons
all_player_game_logs = get_and_filter_player_game_logs(start_season, end_season)

# Save the filtered DataFrame to a CSV file with the added "season" and "game_type" columns
all_player_game_logs.to_csv(f"filtered_player_game_logs_{start_season}_{end_season}.csv", index=False)

