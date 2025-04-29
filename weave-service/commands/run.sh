#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to start the service

# Source utilities helpers
if [ -f "./weave-service/helpers/utils.sh" ]; then
    source ./weave-service/helpers/utils.sh
else
    echo -e "\e[31m$SERVICE_NAME: Cannot find 'utils' helper file. Exiting...\e[0m"
    exit 1
fi

env_name="$1"

if [ "$env_name" == "dev" ]; then
    air
else
    go run .
fi

echo -e "\e[33m$SERVICE_NAME: Trying to start in environment '$env_name'...\e[0m"
