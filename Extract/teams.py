import pandas as pd
from nba_api.stats.library.data import teams, team_index_full_name, team_index_abbreviation, team_index_id
from nba_api.stats.library.data import team_index_nickname, team_index_city, team_index_state, team_index_year_founded

def extract_team_data():
    """Return a list of dictionaries with team details."""
    return [
        {
            'id': team[team_index_id],
            'full_name': team[team_index_full_name],
            'abbreviation': team[team_index_abbreviation],
            'nickname': team[team_index_nickname],
            'city': team[team_index_city],
            'state': team[team_index_state],
            'year_founded': team[team_index_year_founded]
        }
        for team in teams
    ]

# Convert the extracted team data to a pandas DataFrame
teams_df = pd.DataFrame(extract_team_data())

# Save the DataFrame to a CSV file
teams_df.to_csv("teams.csv", index=False)
