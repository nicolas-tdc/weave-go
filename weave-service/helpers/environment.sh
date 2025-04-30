#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script provides utility helper functions for a weave service.

# Function: prepare_service
# Purpose: Set the service environment variables
# Arguments: None
# Returns: None
# Usage: prepare_service
prepare_service() {
    export SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1

    # Function: get_go_package
    # Purpose: Check if a Go package is installed, and install it if not
    # Arguments:
    #   $1 - The package name to check
    # Returns: None
    # Usage: get_go_package <package_name>
    get_go_package() {
        if [ -z "$1" ]; then
            echo -e "\e[31mget_go_package() - Error: First argument is required.\e[0m"
            echo -e "\e[31musage: get_go_package <package_name>\e[0m"
            exit 1
        fi
        local package_name=$1

        local package_path=$(go list -m -f '{{.Path}}' all 2>/dev/null | grep "$package_name")
        if [ -z "$package_path" ]; then
            go get "$package_name"
        fi
    }

    # Check if Go is installed
    if ! command -v go &> /dev/null; then
        echo -e "\e[31mGo is not installed. Exiting...\e[0m"
        exit 1
    fi

    # Check if 'air' is installed
    if ! command -v air &> /dev/null; then
        echo "\e[33m'air' not found, installing...\e[0m"
        go install github.com/air-verse/air@latest
        if [ $? -ne 0 ]; then
            echo "\e[31mFailed to install air.\e[0m"
            exit 1
        fi
    fi

    # Check and edit module name to service name
    if [ $(go list -m) != "$SERVICE_NAME" ]; then
        go mod edit -module="weave.com/$SERVICE_NAME"
    fi

    # Install required Go packages
    get_go_package "github.com/joho/godotenv"
}

# Function: prepare_environment_files
# Purpose: Aggregate the environment files into a single .env file
# Arguments:
#   1. environment_name: The name of the environment to prepare
# Returns: None
# Usage: prepare_environment_files <environment_name>
prepare_environment_files() {
    if [ -z "$1" ]; then
        echo -e "\e[31mprepare_environment_files() - Error: First argument is required.\e[0m"
        echo -e "\e[31musage: prepare_environment_files <environment_name>\e[0m"
        exit 1
    fi

    local env_name=$1

    # Copy the environment-specific file to .env
    if ! [ -f ".env.$env_name" ] && ! [ -f "./env-remote/.env.$env_name" ]; then
        echo -e "\e[31mError: Local and remote environment files .env.$env_name not found.\e[0m"
        exit 1
    fi

    if ! [ -f ".env.$env_name" ] && [ -f "./env-remote/.env.$env_name" ]; then
        cp "./env-remote/.env.$env_name" ".env.$env_name"
    fi

    cp -f ".env.$env_name" ".env"
    source .env
}

# Function: log_service_usage
# Purpose: Log the usage of the service script
# Arguments:
#   None
# Returns:
#   None
# Usage: log_service_usage
log_service_usage() {
    echo -e "\e[33mUsage: ./weave.sh <run|kill|backup-task|log-available-ports>\e[0m"
    echo -e "\e[33mOptions available:\e[0m"
    echo -e "\e[33mDevelopment mode: -d | -dev\e[0m"
    echo -e "\e[33mStaging mode: -s | -staging\e[0m"
}