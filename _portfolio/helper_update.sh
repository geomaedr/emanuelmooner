#!/bin/bash

# Read input JSON file
input_file="input.json"

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input JSON file '$input_file' not found."
    exit 1
fi

# Read JSON data and process each object
while IFS= read -r line; do
    filename=$(echo "$line" | jq -r '.filename')
    col_size=$(echo "$line" | jq -r '.col_size')
    portfolio_nr=$(echo "$line" | jq -r '.portfolio_nr')

    # Check if Markdown file exists
    if [ -f "$filename" ]; then
        # Check if col_size and portfolio_nr lines exist in the Markdown file
        if ! grep -q "col_size:" "$filename"; then
            echo "col_size: \"$col_size\"" >> "$filename"
        fi

        if ! grep -q "portfolio_nr:" "$filename"; then
            echo "portfolio_nr: $portfolio_nr" >> "$filename"
        fi

        echo "Updated $filename"
    else
        echo "Error: Markdown file '$filename' not found."
    fi
done < "$input_file"
