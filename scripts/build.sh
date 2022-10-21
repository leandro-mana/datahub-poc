#!/usr/bin/env bash
# Build Script
# WORK-IN-PROGRESS
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

# Functions Definition
function get_config {
    export SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
    source ${SCRIPT_DIR}/config.sh

}

function get_docker_images {
    if [ ${DATAHUB_ENVIRONMENT} != 'local' ]; then
        for image in ${DOCKER_IMAGES[@]}; do
            docker pull ${image}
        done
    
    fi

}

function install_prerequisites {
    echo "Installing Helm Prerequisites"
    helm dependency update ${HELM_PREREQ_DIR}

}

function install_datahub {
    echo "Installing Helm Datahub Repository"
    helm repo add datahub ${DATAHUB_REPO_URL}

}


# Main
echo "Build Stage Start"
get_config
install_prerequisites
install_datahub
echo "Build Stage Completed"
