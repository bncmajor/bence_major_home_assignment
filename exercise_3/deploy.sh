#!/bin/bash
DEPLOY_FINISHED="false"

get_pod_status(){
    POD_STATUS=$(kubectl get pods -l 'app=backend-server' -o jsonpath='{.items[*].status.phase}')
    if [[ ${POD_STATUS} != "Running" ]]; then
        echo "✅ Application deployed successfully."
        DEPLOY_FINISHED="true"
    elif [[${POD_STATUS} != "Pending" ]]; then
        echo "Application still deploying..."
    else
        echo "❌ Application is not deployed successfully."
        exit 1
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