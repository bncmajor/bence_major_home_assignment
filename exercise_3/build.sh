#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "🚀 Checking if registry is enabled in Minikube..."
STATUS=$(minikube addons list -o json | jq .registry.Status 2>/dev/null)
if ! [[ ${STATUS}  =~ "enabled" ]]; then
    echo "Minikube registry is not enabled (Status: ${STATUS}). Enabling now..."
    minikube addons enable registry
else
    echo "Minikube registry is already enabled."
fi

# If you encounter an issue similar to "ERROR: failed to build: failed to solve: error getting credentials - err: fork/exec /usr/bin/docker-credential-desktop.exe: exec format error, out: ``"
# removing the ~/.docker/config.json file solves the issue. It occurs when WSL2 and Windows docker interfere.

eval $(minikube docker-env)
docker build -t rest-1.0:latest .