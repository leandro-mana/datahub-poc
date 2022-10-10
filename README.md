## DataHub POC

Proof-Of-Concept for [datahub](https://github.com/datahub-project/datahub)

### QuickStart

This setup is about to use a [Python](https://realpython.com/installing-python/) Virtual Environment and [Docker](https://docs.docker.com/get-docker/), to use the datahub cli in order to get all the needed Docker images and to ingest test metadata.

```Bash
# Python Virtual Environment
python -m venv .venv && source .venv/bin/activate

# sanity check - ok if it fails
uninstall datahub acryl-datahub || true

# Requirements
pip install --upgrade pip wheel setuptools
pip install --upgrade acryl-datahub

# Check version
datahub version

# docker start
datahub docker quickstart

# Ingest sample metadata
datahub docker ingest-sample-data

# docker stop
datahub docker quickstart --stop

# docker reset
datahub docker nuke
```

### Local Kubernetes

- Pre-requisites:
    - [Minikube](https://minikube.sigs.k8s.io/docs/) For a local Kubernetes deployment
    - [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) or [AWS kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html) to interact with the Kubernetes cluster
    - [helm](https://helm.sh/) as Kubernetes package manager

- Kubernetes Cluster setup and dependencies
```Bash
# Create a Cluster
minikube start --memory 7200 --cpus 2
minikube status
kubectl get node minikube -o jsonpath='{.status.capacity}'

# Check nodes and pods
kubectl get nodes
kubectl get pods -A
```

- DataHub Setup
```Bash
# 1 - Create kubernetes secrets that contain MySQL and Neo4j passwords
kubectl create secret generic mysql-secrets --from-literal=mysql-root-password=datahub
kubectl create secret generic neo4j-secrets --from-literal=neo4j-password=datahub

# 2 - Build and install PreRequisites
PREREQUISITES="./helm/prerequisites"
helm dependency update ${PREREQUISITES}
helm install prerequisites ${PREREQUISITES} --values ${PREREQUISITES}/values/local.yaml

# 3 - Monitor that each pod is in running state (CTL-C to exit)
kubectl get pods --namespace default -w

# 4 - Build and Install DataHub
DATAHUB="./helm/datahub"
helm dependency update ${DATAHUB}
helm install datahub ${DATAHUB} --values ${DATAHUB}/values/local.yaml

# 5 - Monitor that each pod is in running state (CTL-C to exit)
kubectl get pods --namespace default -w

# 6 - port-forward to the frontend
FRONTEND=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep datahub-frontend)
kubectl port-forward ${FRONTEND} 9002:9002

# 7 - Open on the Browser http://localhost:9002 (user:datahub | pass:datahub)
```

- Cleanup

```Bash

# List helm deployments
helm ls

# Remove deployments by name from the cluster
helm delete <name>

# Delete Minikube cluster
minikube delete
```

- **References:**
    - [datahub](https://github.com/datahub-project/datahub)
    - [datahub-helm](https://github.com/acryldata/datahub-helm/blob/master/charts/datahub/subcharts/datahub-frontend/templates/ingress.yaml)
    - [kubectl cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
    - [Using helm](https://helm.sh/docs/intro/using_helm/)
