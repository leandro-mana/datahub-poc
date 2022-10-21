#!/usr/bin/env bash
# Accept Script
# WORK-IN-PROGRESS
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

# Functions Definition
function get_config {
    export SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
    source ${SCRIPT_DIR}/config.sh
    if [ ${DATAHUB_ENVIRONMENT} == 'local' ]; then
        CONTEXT='minikube'
        NAMESPACE="datahub-${DATAHUB_ENVIRONMENT}"
    
    else
        echo "WORK-IN-PROGRESS for EKS"
    
    fi

}

function kubectl_profile {
    kubectl config use-context ${CONTEXT}

}

function setup_namespace {
    IS_NAMESPACE=$(kubectl get namespace --no-headers -o custom-columns=":metadata.name" | grep -w ${NAMESPACE} || echo NOT)
    if [ ${IS_NAMESPACE} == 'NOT' ]; then
        kubectl create namespace ${NAMESPACE}

    fi
    echo "Namespace: ${NAMESPACE} Setup"

}

function setup_secrets {
    if [ ${DATAHUB_ENVIRONMENT} == 'local' ]; then
        kubectl create secret \
            generic mysql-secrets \
            --from-literal=mysql-root-password=datahub \
            --namespace=${NAMESPACE} \
            --dry-run=client -o yaml | kubectl apply -f -

        kubectl create secret \
            generic neo4j-secrets \
            --from-literal=neo4j-password=datahub \
            --namespace=${NAMESPACE} \
            --dry-run=client -o yaml | kubectl apply -f -

    else
        echo "WORK-IN-PROGRESS for EKS"
    
    fi

}

function deploy_prerequisites {
    helm -n ${NAMESPACE} \
        upgrade --install prerequisites ${HELM_PREREQ_DIR} \
        --values ${HELM_PREREQ_DIR}/values/${DATAHUB_ENVIRONMENT}.yaml \
        --timeout ${HELM_DEPLOYMENT_TIMEOUT} \
        --wait

}

function deploy_datahub {
    helm -n ${NAMESPACE} \
        upgrade --install datahub datahub/datahub \
        --values ${HELM_DATAHUB_VALUES_DIR}/${DATAHUB_ENVIRONMENT}.yaml

}

# Main
echo "Accept Stage Start"
get_config
kubectl_profile
setup_namespace
setup_secrets
deploy_prerequisites
deploy_datahub
echo "Accept Stage Completed"