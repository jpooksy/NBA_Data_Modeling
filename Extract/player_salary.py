from nba_history import player_data
import pandas as pd

# Scrape player salaries
df = player_data.scrape_player_salaries(start_year=1990, end_year=2028, sleep_time=1)

# Modify the "Year" column
df['Year'] = df['Year'].apply(lambda x: f"{x}-{str(x + 1)[-2:]}")

# Export DataFrame to CSV
df.to_csv('player_salaries.csv', index=False)
