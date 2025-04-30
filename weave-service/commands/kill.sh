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

if [ "$env_name" == "dev" ]; then

    if [ -f dev.pid ]; then
        if ! [ "$(cat dev.pid)" == "" ]; then
            kill -9 $(cat dev.pid) > /dev/null 2>&1
        fi

        rm dev.pid > /dev/null 2>&1
    fi
else
    if [ -f prod.pid ]; then

        pid=$(cat prod.pid)
        if ! [ "$pid" == "" ] && [ kill -0 "$pid" 2>/dev/null ]; then
            kill -9 $(cat prod.pid)
        fi

        rm prod.pid > /dev/null 2>&1

        pkill -f "./$SERVICE_NAME" > /dev/null 2>&1
    fi
fi

echo -e "\e[32m$SERVICE_NAME: Service stopped successfully.\e[0m"