#!/bin/bash

# Script to install AWS SSM Agent and AWS CLI on SUSE or Ubuntu Linux servers
# Supports both ARM and AMD64 architectures

set -e

echo "AWS SSM Agent and AWS CLI Installation Script"
echo "============================================"

# Detect architecture
ARCH=$(uname -m)
case ${ARCH} in
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

# Detect Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=${ID}
    VERSION_ID=${VERSION_ID}
    echo "Detected ${OS} ${VERSION_ID}"
else
    echo "Error: Unable to detect Linux distribution"
    exit 1
fi

# Install AWS SSM Agent and AWS CLI based on detected OS and architecture
case ${OS} in
    ubuntu)
        echo "Setting up on Ubuntu..."

        # Install dependencies
        apt-get update
        apt-get install -y wget unzip curl

        # Install AWS SSM Agent
        echo "Installing AWS SSM Agent..."
        if [ "${ARCH}" = "amd64" ]; then
            wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
            dpkg -i amazon-ssm-agent.deb
            rm amazon-ssm-agent.deb
        elif [ "${ARCH}" = "arm64" ]; then
            wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_arm64/amazon-ssm-agent.deb
            dpkg -i amazon-ssm-agent.deb
            rm amazon-ssm-agent.deb
        fi

        # Enable and start the SSM service
        systemctl enable amazon-ssm-agent
        systemctl start amazon-ssm-agent

        # Install AWS CLI v2
        echo "Installing AWS CLI v2..."
        if [ "${ARCH}" = "amd64" ]; then
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        elif [ "${ARCH}" = "arm64" ]; then
            curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
        fi

        unzip -q awscliv2.zip
        ./aws/install
        rm -rf aws awscliv2.zip
        ;;

    sles|suse|opensuse*)
        echo "Setting up on SUSE..."

        # Install dependencies
        zypper --non-interactive install wget unzip curl

        # Install AWS SSM Agent
        echo "Installing AWS SSM Agent..."
        if [ "${ARCH}" = "amd64" ]; then
            wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
            rpm -U amazon-ssm-agent.rpm
            rm amazon-ssm-agent.rpm
        elif [ "${ARCH}" = "arm64" ]; then
            wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_arm64/amazon-ssm-agent.rpm
            rpm -U amazon-ssm-agent.rpm
            rm amazon-ssm-agent.rpm
        fi

        # Enable and start the SSM service
        systemctl enable amazon-ssm-agent
        systemctl start amazon-ssm-agent

        # Install AWS CLI v2
        echo "Installing AWS CLI v2..."
        if [ "${ARCH}" = "amd64" ]; then
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        elif [ "${ARCH}" = "arm64" ]; then
            curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
        fi

        unzip -q awscliv2.zip
        ./aws/install
        rm -rf aws awscliv2.zip
        ;;

    *)
        echo "Error: Unsupported Linux distribution: ${OS}"
        exit 1
        ;;
esac

# Initialize success flag
INSTALL_SUCCESS=true

# Verify installations
echo "Verifying installations..."

# Check SSM Agent
if systemctl is-active --quiet amazon-ssm-agent; then
    echo "✓ AWS SSM Agent is installed and running"
else
    echo "✗ AWS SSM Agent installation failed or service not running"
    INSTALL_SUCCESS=false
fi

# Check AWS CLI
if command -v aws >/dev/null 2>&1; then
    AWS_CLI_VERSION=$(aws --version)
    echo "✓ AWS CLI is installed: ${AWS_CLI_VERSION}"
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
