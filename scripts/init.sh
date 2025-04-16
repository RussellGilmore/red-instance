#!/bin/bash

# Script to install AWS CLI on Ubuntu Linux servers
# Supports both ARM and AMD64 architectures

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check if script is running with sudo privileges
check_sudo() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Error: This script must be run with sudo privileges"
        echo "Please run: sudo $0"
        exit 1
    fi
}

# Function to handle errors
handle_error() {
    echo "Error occurred at line $1"
    exit 1
}

# Set up error handling
trap 'handle_error $LINENO' ERR

echo "AWS CLI Installation Script for Ubuntu"
echo "====================================="

# Check for sudo privileges
check_sudo

# Detect architecture
ARCH=$(uname -m)
case "${ARCH}" in
    x86_64)
        ARCH="amd64"
        echo "Detected AMD64 architecture"
        ;;
    aarch64|arm64)
        ARCH="arm64"
        echo "Detected ARM architecture"
        ;;
    *)
        echo "Error: Unsupported architecture: ${ARCH}"
        exit 1
        ;;
esac

# Verify we're running on Ubuntu
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "${ID}" != "ubuntu" ]; then
        echo "Error: This script is designed for Ubuntu only"
        echo "Detected OS: ${ID}"
        exit 1
    fi
    echo "Detected Ubuntu ${VERSION_ID}"
else
    echo "Error: Unable to detect Linux distribution"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "Setting up on Ubuntu..."

# Install dependencies with error checking
echo "Installing dependencies..."
apt-get update || { echo "Failed to update package lists"; exit 1; }
apt-get install -y wget unzip curl htop jq yq || { echo "Failed to install dependencies"; exit 1; }

# Verify dependencies were installed
for cmd in wget unzip curl; do
    if ! command_exists "${cmd}"; then
        echo "Error: Required command '${cmd}' not found after installation"
        exit 1
    fi
done

# Check for existing AWS CLI installation
if command_exists aws; then
    current_version=$(aws --version 2>&1 | cut -d/ -f2 | cut -d' ' -f1)
    echo "AWS CLI is already installed (version ${current_version})"
    read -p "Do you want to proceed with reinstallation? (y/n): " -n 1 -r REPLY
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping AWS CLI installation"
        AWS_CLI_SKIP=true
    else
        echo "Will reinstall AWS CLI"
        AWS_CLI_SKIP=false
    fi
else
    AWS_CLI_SKIP=false
fi

# Install AWS CLI v2 if not skipped
if [ "${AWS_CLI_SKIP}" = "false" ]; then
    echo "Installing AWS CLI v2..."

    # Set download URL based on architecture
    if [ "${ARCH}" = "amd64" ]; then
        CLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
    elif [ "${ARCH}" = "arm64" ]; then
        CLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"
    fi

    echo "Downloading AWS CLI from ${CLI_URL}..."
    curl "${CLI_URL}" -o "awscliv2.zip" || { echo "Failed to download AWS CLI"; exit 1; }

    echo "Extracting AWS CLI..."
    unzip -q awscliv2.zip || { echo "Failed to extract AWS CLI package"; exit 1; }

    echo "Installing AWS CLI..."
    ./aws/install --update || { echo "Failed to install AWS CLI"; exit 1; }

    echo "Cleaning up AWS CLI installation files..."
    rm -rf aws awscliv2.zip

    # Create symbolic link if needed
    if ! command_exists aws; then
        echo "Creating symbolic link for AWS CLI..."
        ln -sf /usr/local/bin/aws /usr/bin/aws
    fi
fi

# Initialize success flag
INSTALL_SUCCESS=true

# Verify installation
echo "Verifying installation..."

# Check AWS CLI
if [ "${AWS_CLI_SKIP}" = "false" ] && command_exists aws; then
    AWS_CLI_VERSION=$(aws --version 2>&1)
    echo "✓ AWS CLI is installed: ${AWS_CLI_VERSION}"

    # Verify AWS CLI is in PATH
    if ! echo "${PATH}" | grep -q "/usr/local/bin"; then
        echo "Note: You may need to add /usr/local/bin to your PATH"
        echo "      You can do this by adding the following line to your ~/.bashrc file:"
        echo "      export PATH=\$PATH:/usr/local/bin"
    fi
elif [ "${AWS_CLI_SKIP}" = "true" ]; then
    echo "✓ AWS CLI installation was skipped as requested"
else
    echo "✗ AWS CLI installation failed"
    INSTALL_SUCCESS=false
fi

# Final status
if [ "${INSTALL_SUCCESS}" = "false" ]; then
    echo "Installation completed with errors"
    exit 1
else
    echo "Installation completed successfully"
    echo "To configure AWS CLI, run: aws configure"
fi
