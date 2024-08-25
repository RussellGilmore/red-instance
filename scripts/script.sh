#!/bin/bash

# Install AWS CLI v2 on SUSE and Ubuntu Linux (x86_64 and arm)

# Check the Linux distribution
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  if [[ $ID == "ubuntu" ]]; then
    # Update Ubuntu and install unzip
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y unzip
  elif [[ $ID == "suse" ]]; then
    # Update SUSE and install unzip
    sudo zypper refresh
    sudo zypper update -y
    sudo zypper install -y unzip
  else
    echo "Unsupported Linux distribution: $ID"
    exit 1
  fi
else
  echo "Unable to determine Linux distribution"
  exit 1
fi

# Check the architecture
if [[ $(uname -m) == "x86_64" ]]; then
  # Install AWS CLI for x86_64
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
else
  # Install AWS CLI for arm
  curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
fi
