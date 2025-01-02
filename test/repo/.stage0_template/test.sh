#!/bin/bash

# Exit immediately if a command fails
set -e

# Validate the script is being run in the correct context
if [ ! -e ./.stage0_template ]; then
    echo "Error: This script must be run from the root of the repo. Ensure the repo is an unprocessed Stage0 template repository."
    exit 1
fi

# Setup the testing folder
TEMP_REPO=~/tmp/testRepo
echo "Setting up temporary testing folder at $TEMP_REPO..."
rm -rf ~/tmp/testRepo
mkdir -p ~/tmp/testRepo 
cp -r . ~/tmp/testRepo

# Run the container
echo "Running the container..."
docker run --rm \
    -v "$TEMP_REPO:/repo" \
    -v "$(pwd)/.stage0_template/test_data:/specifications" \
    -e SERVICE_NAME=user \
    -e DATA_SOURCE=organization \
    ghcr.io/agile-learning-institute/stage0-generator:latest

# Check the results
echo "Checking output..."
diff -qr "$(pwd)/.stage0_template/test_expected/" "$TEMP_REPO/"

echo "Done."