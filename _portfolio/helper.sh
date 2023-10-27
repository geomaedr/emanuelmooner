#!/bin/bash

# Read input JSON file
input_file="input.json"
if [ ! -f "$input_file" ]; then
    echo "Error: Input JSON file '$input_file' not found."
    exit 1
fi

# Read JSON and process each object
while IFS= read -r line; do
    # Check if the line is a valid JSON object
    if jq -e . >/dev/null 2>&1 <<< "$line"; then
        # Extract filename, col_size, portfolio_nr, and image from the JSON object
        filename=$(jq -r '.filename' <<< "$line")
        col_size=$(jq -r '.col_size' <<< "$line")
        portfolio_nr=$(jq -r '.portfolio_nr' <<< "$line")
        image=$(jq -r '.image' <<< "$line")

        # Check if the file already exists
        if [ ! -f "$filename" ]; then
            # Create the Markdown file with the specified content
            echo "---" > "$filename"
            echo "title: " >> "$filename"
            echo "layout: portfolio" >> "$filename"
            echo "subtext: " >> "$filename"
            echo "image: $image" >> "$filename"
            echo "portfolio_nr: $portfolio_nr" >> "$filename"
            echo "col_size: $col_size" >> "$filename"
            echo "---" >> "$filename"
            echo "Munich artist Emanuel Mooner / Neon Artist, Neon Art" >> "$filename"
            echo "Markdown file '$filename' created successfully."
        else
            echo "Error: File '$filename' already exists."
        fi
    else
        echo "Error: Invalid JSON object: $line"
    fi
done < "$input_file"
