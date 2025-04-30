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

echo -e "\e[33m$SERVICE_NAME: Trying to stop in environment '$env_name'...\e[0m"

env_name="$1"

env_pid="$env_name.pid"
if [ -f "$env_pid" ]; then
    # Kill the process if it exists
    if ! [ "$(cat $env_pid)" == "" ]; then
        kill -9 $(cat $env_pid) > /dev/null 2>&1
    fi

    rm $env_pid > /dev/null 2>&1
fi

if ! [ $env_name == "dev" ]; then
    # Check if the service is running and kill it
    if pgrep -f "./$SERVICE_NAME" > /dev/null 2>&1; then
        pkill -f "./$SERVICE_NAME" > /dev/null 2>&1
    fi
fi

echo -e "\e[32m$SERVICE_NAME: Service stopped successfully.\e[0m"