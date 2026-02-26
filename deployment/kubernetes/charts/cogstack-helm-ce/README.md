# CogStack Helm Community Edition

This is a all in one helm chart that runs CogStack on Kubernetes

## Overview

This chart is an umbrella chart that deploys:

| Component        | Description |
|------------------|-------------|
| **MedCAT**       | Medical Concept Annotation Tool — NER and linking for clinical text. |
| **AnonCAT**      | De-identification service (MedCAT in DEID mode) for anonymising text. |
| **MedCAT Trainer** | Training and model management for MedCAT, with Solr and PostgreSQL. |

## Prerequisites

- Kubernetes cluster
- Helm 3

## Installation

From the chart directory (or repo root), update dependencies and install:

```bash
cd deployment/kubernetes/charts/cogstack-helm-ce
helm dependency update
helm install cogstack-ce . --namespace cogstack --create-namespace
```

Or from the repo root:

```bash
helm dependency update deployment/kubernetes/charts/cogstack-helm-ce
helm install cogstack-ce deployment/kubernetes/charts/cogstack-helm-ce --namespace cogstack --create-namespace
```

## Configuration

Key values in `values.yaml`:

| Value | Default | Description |
|-------|---------|-------------|
| `imagePullSecrets` | `[]` | Secrets for pulling images from a private registry. |
| `nameOverride` | `""` | Override the chart name used in resource names. |
| `fullnameOverride` | `""` | Override the full name used in resource names. |
| `medcat-service.replicasCount` | `1` | Number of MedCAT service replicas. |
| `anoncat-service.replicasCount` | `1` | Number of AnonCAT service replicas. |
| `anoncat-service.env.APP_ENABLE_DEMO_UI` | `true` | Enable AnonCAT demo UI. |
| `anoncat-service.env.DEID_MODE` | `true` | Run AnonCAT in de-identification mode. |
| `anoncat-service.env.DEID_REDACT` | `false` | Redaction behaviour for de-identification. |

Subcharts (MedCAT service, AnonCAT service, MedCAT Trainer) support additional options; see their respective charts under `../medcat-service-helm` and `../medcat-trainer-helm`. Pass them under the same keys as in this chart’s `values.yaml` (e.g. `medcat-service.*`, `anoncat-service.*`, `medcat-trainer-helm.*`).

Example override file:

```yaml
# my-values.yaml
medcat-service:
  replicasCount: 2
anoncat-service:
  replicasCount: 1
  env:
    APP_ENABLE_DEMO_UI: true
    DEID_MODE: true
```

Install with overrides:

```bash
helm install cogstack-ce . -f my-values.yaml --namespace cogstack --create-namespace
```

## Dependencies

The chart uses local subcharts via relative paths:

- `medcat-service-helm` (as `medcat-service` and `anoncat-service`)
- `medcat-trainer-helm`

## Uninstall

```bash
helm uninstall cogstack-ce --namespace cogstack
```

If the namespace was created only for this release, remove it with:

```bash
kubectl delete namespace cogstack
```
