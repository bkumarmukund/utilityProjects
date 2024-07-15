#!/bin/bash

# File containing key-value pairs
KV_FILE="/home/user0/Desktop/pasteApp/pasteData"

# Function to read key-value pairs into an associative array
declare -A kv_pairs

# Read key-value pairs from file while preserving order
while IFS=':' read -r key value; do
    kv_pairs["$key"]="$value"
    keys+=("$key")  # Maintain order of keys
done < "$KV_FILE"

# Function to perform fuzzy search and paste value
function fuzzy_search_and_paste() {
    # Get user input using rofi
    input=$(printf '%s\n' "${keys[@]}" | rofi -dmenu -i -p "Enter key:")

    if [ -n "$input" ]; then
        value="${kv_pairs[$input]}"
        if [ -n "$value" ]; then
            # Copy the value to the clipboard and paste it at the cursor position
            echo -n "$value" | xclip -selection clipboard
            xdotool key --clearmodifiers ctrl+v
        fi
    fi
}

# Execute the function
fuzzy_search_and_paste
