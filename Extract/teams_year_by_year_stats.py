# Importing required libraries and modules
import pandas as pd
from nba_api.stats.endpoints import teamyearbyyearstats
from nba_api.stats.static import teams

# Constants
SEASON_TARGET = "2022-23"
OUTPUT_FILENAME = "team_year_by_year_stats.csv"
LEAGUE_ID = "00"
SEASON_TYPE = "Regular Season"

def get_all_team_ids():
    """
    Retrieve all NBA team IDs.
    
    Returns:
        List[int]: List of NBA team IDs.
    """
    # Fetching list of NBA teams
    nba_teams = teams.get_teams()
    # Extracting team IDs from the list of teams
    return [team['id'] for team in nba_teams]

def fetch_team_year_by_year_stats(team_id):
    """
    Fetch year-by-year stats for a given NBA team.
    
    Parameters:
        team_id (int): ID of the NBA team.
        
    Returns:
        DataFrame: Year-by-year stats for the given team.
    """
    return teamyearbyyearstats.TeamYearByYearStats(
        team_id=team_id,
        season_type_all_star=SEASON_TYPE,
        league_id=LEAGUE_ID
    ).get_data_frames()[0]

def main():
    """
    Main function to retrieve year-by-year stats for all NBA teams for a given season.
    """
    # Initialize an empty DataFrame to store stats for all teams
    all_teams_stats_df = pd.DataFrame()

    # Fetch year-by-year stats for each NBA team and concatenate into one DataFrame
    for team_id in get_all_team_ids():
        team_stats_df = fetch_team_year_by_year_stats(team_id)
        all_teams_stats_df = pd.concat([all_teams_stats_df, team_stats_df], ignore_index=True)

    # Filtering the data to retain only records for the specified season
    filtered_teams_stats = all_teams_stats_df[all_teams_stats_df['YEAR'] == SEASON_TARGET]

    # Saving the final filtered data to a CSV file
    filtered_teams_stats.to_csv(OUTPUT_FILENAME, index=False)
    print(filtered_teams_stats)

# Ensure the script is executed as a standalone and not imported
if __name__ == "__main__":
    main()