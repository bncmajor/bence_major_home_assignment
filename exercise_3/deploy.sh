#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
DEPLOY_FINISHED="false"

get_pod_status(){
    POD_STATUS=$(kubectl get pods -l 'app=backend-server' -o jsonpath='{.items[*].status.phase}')
    if [[ ${POD_STATUS} == "Running" ]]; then
        echo "✅ Application deployed successfully."
        DEPLOY_FINISHED="true"
    elif [[ "$POD_STATUS" == "ImagePullBackOff" ]] || [[ "$POD_STATUS" == "CrashLoopBackOff" ]]; then
        echo "❌ Deployment failed: $POD_STATUS"
        exit 1
    else
        echo "⏳ Status: ${POD_STATUS:-Pending}..."
    fi
}

echo "🚀 Deploying the application to the K8s cluster..."

kubectl kustomize manifest/ | kubectl apply -f -

while [[ $DEPLOY_FINISHED == "false" ]]; do
    get_pod_status
    sleep 5
done

echo "❗ Port forward is required to access the application via localhost:8080. You will need to keep this terminal session open."
kubectl port-forward service/backend-server-service 8080:8080