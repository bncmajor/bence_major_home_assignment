#!/bin/bash

install_minikube_linux_x86(){
    echo "Linux x86 detected. Installing minikube..."
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
    echo "✅ Minikube is installed."
}

install_minikube_darwin_x86(){
    echo "macOS x86 detected. Installing minikube..."
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-amd64
    sudo install minikube-darwin-amd64 /usr/local/bin/minikube
    echo "✅ Minikube is installed."
}

install_minikube_darwin_arm64(){
    echo "macOS arm64 detected. Installing minikube..."
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-arm64
    sudo install minikube-darwin-arm64 /usr/local/bin/minikube
    echo "✅ Minikube is installed."
}

OS_NAME="$(uname -s)"
ARCH_NAME="$(uname -m)"
if ! command -v minikube >/dev/null 2>&1
then
    echo "❌ Minikube is not installed."
    if [[ "$OS_NAME" == "Linux"* ]]; then
        install_minikube_linux_x86
    elif [[ "$OS_NAME" == "Darwin"* ]]; then
        if [[ "$ARCH_NAME" == "x86_64"* ]]; then
            install_minikube_darwin_x86
        elif [[ "$ARCH_NAME" == "arm64"* ]]; then
            install_minikube_darwin_arm64
        fi
    fi
else
    echo "✅ minikube is already installed."
fi

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed."
else
    echo "✅ Docker is installed."
    # Check if the Docker daemon is actually running
    if docker info &> /dev/null; then
        echo "🚀 Docker daemon is running."
        docker --version
    else
        echo "⚠️  Docker is installed, but the daemon is not running."
        echo "Try starting it with: sudo systemctl start docker"
        exit 1
    fi
fi

STATUS=$(minikube status --format='{{.Host}}' 2>/dev/null)

echo "🚀 Checking if Minikube is running..."

if [ "$STATUS" != "Running" ]; then
    echo "Minikube is not running (Status: ${STATUS:-Stopped}). Starting now..."
    minikube start
else
    echo "Minikube is already running."
fi

if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed."
else
    echo "✅ kubectl is installed."
fi
