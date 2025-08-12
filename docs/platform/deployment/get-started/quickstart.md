
# Quickstart

A local setup guide for running k8s locally, and installing with helm


## Requirements
- Docker installed ([install Docker](https://docs.docker.com/get-docker/))
- Docker Compose installed ([install Docker Compose](https://docs.docker.com/compose/install/))
- A terminal with network access

## Setup

1. **Install Minikube**

You can install Minikube by following the official instructions:  
https://minikube.sigs.k8s.io/docs/start/

Or just run this if on linux:

```bash
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

2. **Install Helm**

Run:

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

3. **Start Minikube**

```bash
minikube start
```

This will create a local Kubernetes cluster.

## Deploy CogStack with Helm

Run this command to install the MedCAT service Helm chart:

```bash
helm install my-medcat oci://registry-1.docker.io/cogstacksystems/medcat-service-helm --wait --timeout 10m0s
```

The `--wait` flag makes Helm wait until all resources are ready, and `--timeout` sets a maximum wait time.

### Verify deployment

Check that the pods are running:

```bash
helm test medcat-service --logs
```

You’re now running CogStack locally on Kubernetes! For more detailed usage, see the [Helm tutorial](../helm/tutorial.md).

### Access the service


