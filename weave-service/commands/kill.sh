#!/bin/bash

# Exit immediately if a command fails
set -e

# Source utilities helpers
if [ -f "./scripts/helpers/utils.sh" ]; then
    source ./scripts/helpers/utils.sh
else
    echo -e "\e[31m$SERVICE_NAME: Cannot find 'utils' helper file. Exiting...\e[0m"
    exit 1
fi

env_name="$1"

echo -e "\e[33m$SERVICE_NAME: Trying to stop in environment '$env_name'...\e[0m"
