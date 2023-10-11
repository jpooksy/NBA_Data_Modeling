import pandas as pd

def split_name(player_name):
    """Splits the player's name into first and last name."""
    names = player_name.split()
    first_name = names[0]
    last_name = ' '.join(names[1:])
    return first_name, last_name

# Load data from CSV
df = pd.read_csv('player_salaries_input.csv')

# Ensure the required column 'PLAYER' exists
if 'PLAYER' in df.columns:
    
    # Extract first and last names
    df['first_name'], df['last_name'] = zip(*df['PLAYER'].apply(split_name))

    # Reorder and rename columns for clarity
    column_order = ['PLAYER', 'first_name', 'last_name', '2022/23', '2023/24', '2024/25', '2025/26', '2026/27']
    column_names = {
        'PLAYER': 'full_name',
        '2022/23': '2022-23',
        '2023/24': '2023-24',
        '2024/25': '2024-25',
        '2025/26': '2025-26',
        '2026/27': '2026-27'
    }
    
    df = df[column_order].rename(columns=column_names)

    # Save the processed data to a new CSV
    df.to_csv('player_salaries_output.csv', index=False)
else:
    print("Error: 'PLAYER' column not found in player_salaries_input.csv")
