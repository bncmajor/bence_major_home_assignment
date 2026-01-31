# Exercise 3: Kubernetes Deployment

This directory contains the scripts and configuration to build and deploy a REST application to a local Minikube cluster.

## Prerequisites

- **Docker**: Must be installed and running.
- **Minikube**: Will be installed/checked by `setup.sh`.
- **Kubectl**: Should be installed.

## Usage

Follow these steps to deploy and test the application:

1.  **Setup Environment**
    Installs/checks dependencies (Minikube, Docker, Kubectl) and starts the Minikube cluster.
    ```bash
    ./setup.sh
    ```

2.  **Build Image**
    Enables the Minikube registry and builds the Docker image (`rest-1.0:latest`) directly inside Minikube's Docker daemon.
    ```bash
    ./build.sh
    ```

3.  **Deploy Application**
    Deploys the application manifest to the cluster, waits for the pod to start, and sets up port-forwarding to `localhost:8080`.
    ```bash
    ./deploy.sh
    ```
    *Note: This script will keep running to maintain the port forward. You can stop it with `Ctrl+C`.*

4.  **Test Endpoint**
    In a new terminal window, verify the application is responding:
    ```bash
    ./test.sh
    ```
    Expected output: `{"message": "Hello World"}`

## Project Structure

- `manifest/`: Kubernetes manifests (Deployment, Service, Kustomization).
- `rest_1.0/`: Pre-built application binaries.
- `Dockerfile`: Configuration for building the application container.
