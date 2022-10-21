export DATAHUB_ENVIRONMENT=${DATAHUB_ENVIRONMENT:-'local'}
export DATAHUB_REPO_URL='https://helm.datahubproject.io/'
export HELM_PREREQ_DIR='helm/prerequisites'
export HELM_DATAHUB_VALUES_DIR='helm/datahub'
export HELM_DEPLOYMENT_TIMEOUT='10m'
export MINIKUBE_MEMORY=7200
export MINIKUBE_CPU=2
export DOCKER_IMAGES=(
    "elasticsearch:7.17.3"
    "neo4j:4.2.4-community"
    "bitnami/mysql:8.0.29-debian-10-r23"
    "confluentinc/cp-schema-registry:6.0.10"
    "bitnami/kafka:3.2.0-debian-10-r4"
    "bitnami/zookeeper:3.8.0-debian-10-r64"
    "linkedin/datahub-gms:v0.9.0"
    "linkedin/datahub-frontend-react:v0.9.0"
    "linkedin/datahub-mae-consumer:v0.9.0"
    "linkedin/datahub-mce-consumer:v0.9.0"
    "linkedin/datahub-elasticsearch-setup:79575b2"
    "linkedin/datahub-kafka-setup:v0.9.0"
    "acryldata/datahub-mysql-setup:v0.9.0"
)