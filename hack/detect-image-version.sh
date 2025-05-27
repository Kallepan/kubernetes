#!/bin/bash
#
# This script checks the image versions of all pods in all namespaces that match the selector
# and reports whether they are using the allowed versions.
#

export KUBECONFIG=$1

# Fetch all pods matching the selector in all namespaces
pods=$(kubectl get pods --all-namespaces --selector app.kubernetes.io/name=ingress-nginx -o json)

# Extract and check the image versions
echo "Checking Ingress NGINX pod images..."
echo "-------------------------------------"

echo "$pods" | jq -r '.items[] | "\(.metadata.namespace) \(.metadata.name) \(.spec.containers[].image)"' | while read namespace pod image; do
    # Extract the tag from the image (assumes format: repo/image:tag@digest)
    tag=$(echo "$image" | awk -F:v '{print $2}' | awk -F@ '{print $1}')

    if [[ "$tag" == "1.12.1" || "$tag" == "1.11.5" ]]; then
        echo "[OK] Pod: $pod (Namespace: $namespace) is using allowed version: $tag"
    else
        echo "[WARN] Pod: $pod (Namespace: $namespace) is using an unsupported version: $tag"
    fi
done
