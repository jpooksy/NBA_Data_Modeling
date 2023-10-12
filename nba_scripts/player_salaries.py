# Import necessary module for data manipulation
import pandas as pd

# Constants for input/output filenames and player column name
INPUT_FILE = 'player_salaries_input.csv'
OUTPUT_FILE = 'player_salaries_output.csv'
PLAYER_COLUMN = 'PLAYER'

# Function to split player names into first and last names
def split_name(player_name):
    """Splits the player's name into first and last name."""
    # Split the name by spaces
    names = player_name.split()
    # The first part is the first name
    first_name = names[0]
    # The remaining parts are considered as the last name
    last_name = ' '.join(names[1:])
    return first_name, last_name

# Function to load data from a specified CSV file
def load_data(filename):
    """Loads data from a CSV file."""
    try:
        # Try reading the file and return the dataframe
        return pd.read_csv(filename)
    except FileNotFoundError:
        # If the file is not found, print an error message
        print(f"Error: '{filename}' not found.")
        return None

# Function to process the dataframe for desired modifications
def process_data(df):
    """Processes the dataframe by splitting names and reordering columns."""
    # Check if the PLAYER column exists in the dataframe
    if PLAYER_COLUMN not in df.columns:
        # Print an error message if not found
        print(f"Error: '{PLAYER_COLUMN}' column not found in {INPUT_FILE}")
        return None

    # Extract first and last names from the PLAYER column
    df['first_name'], df['last_name'] = zip(*df[PLAYER_COLUMN].apply(split_name))

    # Define the desired order and names for columns
    column_order = [PLAYER_COLUMN, 'first_name', 'last_name', '2022/23', '2023/24', '2024/25', '2025/26', '2026/27']
    column_names = {
        PLAYER_COLUMN: 'full_name',
        '2022/23': '2022-23',
        '2023/24': '2023-24',
        '2024/25': '2024-25',
        '2025/26': '2025-26',
        '2026/27': '2026-27'
    }
    
    # Return the reordered and renamed dataframe
    return df[column_order].rename(columns=column_names)

# Main function to execute the data loading, processing, and saving
def main():
    # Load data from the input file
    df = load_data(INPUT_FILE)

    # Check if data was successfully loaded
    if df is not None:
        # Process the data
        processed_data = process_data(df)
        # Check if processing was successful
        if processed_data is not None:
            # Save the processed data to the output file
            processed_data.to_csv(OUTPUT_FILE, index=False)
            # Notify user of success
            print(f"Processed data saved to {OUTPUT_FILE}")

# Ensure the script is executed as a standalone and not imported
if __name__ == "__main__":
    # Invoke the main function
    main()