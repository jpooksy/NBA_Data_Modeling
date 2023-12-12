# Importing required libraries and modules
import pandas as pd
from nba_api.stats.endpoints import teamyearbyyearstats
from nba_api.stats.static import teams

# Function to retrieve all NBA team IDs
def get_all_team_ids():
    # Fetching list of NBA teams
    nba_teams = teams.get_teams()
    # Extracting team IDs from the list of teams
    team_ids = [team['id'] for team in nba_teams]
    return team_ids

# Initialize an empty DataFrame to store stats for all teams
all_teams_stats_df = pd.DataFrame()

# Fetch both regular season and playoff stats for each NBA team and concatenate into one DataFrame
for team_id in get_all_team_ids():
    for season_type in ["Regular Season", "Playoffs"]:
        team_stats_dfs = teamyearbyyearstats.TeamYearByYearStats(
            team_id=team_id,
            season_type_all_star=season_type,
            league_id="00"  # NBA league ID
        ).get_data_frames()  # Fetching the list of data frames
        
        team_stats_df = team_stats_dfs[0]
        all_teams_stats_df = pd.concat([all_teams_stats_df, team_stats_df], ignore_index=True)

# Saving the final data to a CSV file
all_teams_stats_df.to_csv("team_year_by_year_stats.csv", index=False)
print(all_teams_stats_df)
