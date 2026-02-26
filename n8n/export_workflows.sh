#!/bin/bash

# Export workflow files from the Docker container
docker exec -u node n8n n8n export:workflow --all --pretty --separate --output=/files/workflows/

# Exported workflow files are named after the workflow ID
# Rename the workflow files according to workflow name for clarity
TARGET_DIR="./local-files/workflows"

# Enable nullglob so the loop doesn't fail if there are no JSON files
shopt -s nullglob

# 2. Loop through all .json files in the target directory
for FILE in "$TARGET_DIR"/*.json; do

    # Extract the value of "name" using jq
    NEW_NAME=$(jq -r '.name' "$FILE")

    # 3. Check if a name was found and is not "null"
    if [ -n "$NEW_NAME" ] && [ "$NEW_NAME" != "null" ]; then
        DIR=$(dirname "$FILE")

        # Clean the name to avoid weird file paths (replace spaces with underscores, keeps alphanumeric, dashes, and underscores)
        CLEAN_NAME=$(echo "$NEW_NAME" | tr ' ' '_' | tr -cd '[:alnum:]_-')
        NEW_PATH="$DIR/${CLEAN_NAME}.json"

        # 4. Rename the file, but skip if it already has the correct name
        if [ "$FILE" != "$NEW_PATH" ]; then
            mv "$FILE" "$NEW_PATH"
            echo "✅ Renamed: $(basename "$FILE") -> ${CLEAN_NAME}.json"
        else
            echo "⏭️  Skipped: $(basename "$FILE") is already correctly named."
        fi
    else
        echo "⚠️  Skipped: $(basename "$FILE") (No 'name' key found)."
    fi

done
