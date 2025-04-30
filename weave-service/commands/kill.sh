#!/bin/bash

# Exit immediately if a command fails
set -e

# Source utilities helpers
if [ -f "./weave-service/helpers/utils.sh" ]; then
    source ./weave-service/helpers/utils.sh
else
    echo -e "\e[31m$SERVICE_NAME: Cannot find 'utils' helper file. Exiting...\e[0m"
    exit 1
fi

env_name="$1"

echo -e "\e[33m$SERVICE_NAME: Trying to stop in environment '$env_name'...\e[0m"

# Kill the process if it is running
env_pid="$env_name.pid"
if [ -f "$env_pid" ]; then
    if kill -0 "$(cat "$env_pid")" > /dev/null 2>&1; then
        kill "$(cat "$env_pid")" > /dev/null 2>&1
    fi

    # Remove the PID file
    rm $env_pid > /dev/null 2>&1
fi

# Check if the service is running and kill it
if ! [ $env_name == "dev" ]; then
    if pgrep -f "./$SERVICE_NAME" > /dev/null 2>&1; then
        pkill -f "./$SERVICE_NAME" > /dev/null 2>&1
    fi
fi

echo -e "\e[32m$SERVICE_NAME: Service stopped successfully.\e[0m"