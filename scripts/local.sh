#!/usr/bin/env bash
# Local Kubernetes Setup Script
# WORK-IN-PROGRESS
set -o errexit
set -o pipefail
set -o nounset

# Check IF Local Environment
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source ${SCRIPT_DIR}/config.sh
if [ ${DATAHUB_ENVIRONMENT} != 'local' ]; then
    echo "This Target is only for Local Environment"
    exit 1

fi

# Globals
ACTION=${1}
MINIKUBE=$(which minikube 2>/dev/null || false)
KUBECTL=$(which kubectl 2>/dev/null || false)
HELM=$(which helm 2>/dev/null || false)
NAMESPACE="datahub-${DATAHUB_ENVIRONMENT}"

# Check Requirements
if [ ! ${MINIKUBE} ] || [ ! ${KUBECTL} ] || [ ! ${HELM} ]; then
    echo 'minikube OR kubectl OR helm, NOT FOUND'
    echo 'Check README for instructions'
    exit 1

fi


# Main based on ACTION
case ${ACTION} in
    cluster)
        ${MINIKUBE} start \
            --memory ${MINIKUBE_MEMORY} \
            --cpus ${MINIKUBE_CPU}
        
        for image in ${DOCKER_IMAGES[@]}; do
            docker pull ${image}
            ${MINIKUBE} image load ${image}
            echo -e "\nUploaded to Minikube ${image}\n"

        done

    ;;
    frontend)
        FRONTEND=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" --namespace ${NAMESPACE} | grep datahub-frontend)
        kubectl port-forward ${FRONTEND} 9002:9002 --namespace ${NAMESPACE}

    ;;

    status)
        ${MINIKUBE} status
        echo ''
        ${HELM} ls -n ${NAMESPACE} 
        echo ''
        ${KUBECTL} get pods --all-namespaces
    ;;

    clean)
        for deployment in prerequisites datahub; do 
            ${HELM} delete ${deployment}  \
                --namespace ${NAMESPACE} \
                2>/dev/null || echo "No \"${deployment}\" Helm deployment to delete"
        done

        sleep 10
        PODS=$(kubectl get pods --namespace ${NAMESPACE} --no-headers -o custom-columns=":metadata.name" | tr '\n' ' ')
        for pod in $(echo ${PODS}); do
            kubectl delete pod ${pod} --namespace ${NAMESPACE}
        
        done

        ${MINIKUBE} delete

        echo -e '\nLocal Environment Clean.'
    ;;

    *)
        echo "Action: ${ACTION} Not Supported"
        exit 1
    ;;

esac
