#!/bin/bash

# Function to install Skaffold
install_skaffold() {
  echo "Checking if Skaffold is installed..."
  if ! skaffold version &> /dev/null; then
    echo "Skaffold not found. Installing Skaffold..."
    curl -Lo skaffold.exe https://storage.googleapis.com/skaffold/releases/latest/skaffold-windows-amd64.exe &&
    chmod +x skaffold.exe &&
    mv skaffold.exe /usr/local/bin/skaffold
  else
    echo "Skaffold is already installed."
  fi
}

run_skaffold() {
    
    if powershell.exe -Command skaffold version &> /dev/null; then
        echo "Deploying Kubernetes cluster in local environment"
        powershell.exe -Command skaffold dev -vdebug
    else
        echo "Skaffold not found. Please make sure it is installed."
    fi
}

# Function to update the Windows hosts file
update_hosts_file() {
  echo "Updating Windows hosts file to include yaaratest.com..."
  HOSTS_FILE="/mnt/c/Windows/System32/drivers/etc/hosts"
  ENTRY="127.0.0.1 yaaratest.com"
  PS_COMMAND="Add-Content -Path 'C:\\Windows\\System32\\drivers\\etc\\hosts' -Value '127.0.0.1 yaaraapi.com'"


if ! grep -q "$ENTRY" "$HOSTS_FILE"; then
    # PowerShell command to add the entry to the hosts file
    powershell.exe -Command "$PS_COMMAND" &&
    echo "Hosts file updated successfully. Added: $ENTRY"
  else
    echo "Entry already exists in the hosts file. No changes made."
  fi

  echo "Current contents of the hosts file:"
  grep "yaaratest.com" "$HOSTS_FILE"
}

# Main script execution
echo "Starting deployment script..."

# install_skaffold &&
run_skaffold &&
update_hosts_file

echo "Deployment script completed."
