# Importing the necessary pandas library
import pandas as pd
from nba_api.stats.library.data import (
    teams,
    team_index_full_name,
    team_index_abbreviation,
    team_index_id,
    team_index_nickname,
    team_index_city,
    team_index_state,
    team_index_year_founded
)

# Defining a constant for the output filename for clarity and easy modification in the future
OUTPUT_FILENAME = "teams.csv"

def extract_team_data():
    """Return a list of dictionaries with team details."""
    # Using a list comprehension to build a list of team dictionaries by iterating over each team and mapping relevant indices to their values
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
        for team in teams  # Iterating over each team in the provided teams data
    ]

def main():
    """Main function to extract team data and save it to a CSV file."""
    # Convert the list of extracted team dictionaries to a pandas DataFrame
    teams_df = pd.DataFrame(extract_team_data())

    # Saving the DataFrame with team details to a CSV file
    teams_df.to_csv(OUTPUT_FILENAME, index=False)

# Checking if the script is executed directly (and not imported) before running the main function
if __name__ == "__main__":
    # If the script is executed directly, call the main function
    main()
