# Import the pandas library for data manipulation
import pandas as pd

# Import specific functions from the nba_api package for retrieving game and player data
from nba_api.stats.endpoints import leaguegamefinder

# Define a function to get all NBA games for a range of seasons
def get_all_nba_games(start_season, end_season):
    # Create an empty DataFrame to store all games
    all_games = pd.DataFrame()

    # Iterate through each season in the specified range
    for season in range(start_season, end_season + 1):
        # Generate the season string in the format "YYYY-YY"
        season_str = f"{season}-{(season + 1) % 100:02d}"

        # Use the LeagueGameFinder endpoint to retrieve regular season game data for the current season
        regular_season_games_df = leaguegamefinder.LeagueGameFinder(
            player_or_team_abbreviation="T",
            season_type_nullable="Regular Season",
            season_nullable=season_str,
            league_id_nullable="00"
        ).league_game_finder_results.get_data_frame()

        # Use the LeagueGameFinder endpoint to retrieve playoff game data for the current season
        playoff_games_df = leaguegamefinder.LeagueGameFinder(
            player_or_team_abbreviation="T",
            season_type_nullable="Playoffs",
            season_nullable=season_str,
            league_id_nullable="00"
        ).league_game_finder_results.get_data_frame()

        # Add a new column "season" with the season string to both DataFrames
        regular_season_games_df['season'] = season_str
        playoff_games_df['season'] = season_str

        # Add a new column "game_type" to indicate whether the game is regular season or playoff
        regular_season_games_df['game_type'] = "Regular Season"
        playoff_games_df['game_type'] = "Playoffs"

        # Print information about the current season
        print(f"Season {season_str}: Regular Season - {len(regular_season_games_df)} games, Playoffs - {len(playoff_games_df)} games")

        # Append the current season's regular season and playoff games to the overall DataFrame
        all_games = pd.concat([all_games, regular_season_games_df, playoff_games_df], ignore_index=True)

    # Return the DataFrame containing all games for the specified range of seasons
    return all_games

# Example usage:
# Set the start and end seasons
start_season = 1970
end_season = 2022

# Call the function to get all NBA games (regular season and playoffs) for the specified range of seasons
all_nba_games = get_all_nba_games(start_season, end_season)

# Save the DataFrame to a CSV file with the added "season" and "game_type" columns
all_nba_games.to_csv(f"all_nba_games_{start_season}_{end_season}.csv", index=False)
