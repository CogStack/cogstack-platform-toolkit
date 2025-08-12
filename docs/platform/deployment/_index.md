# Deployment

## Introduction
:::{warning}
We are actively working on improving the deployment of CogStack

The following section shows how to run MedCAT Service in a variety of environments and configs.

To setup a full deployment of CogStack including the data pipelines and infrastructure, contact us
:::

## Overview
CogStack is a self-hosted platform made up of microservices and tools

If you want to get started quickly, check out the [Quickstart](./get-started/quickstart) guide to run CogStack locally in just a few simple steps.

Our recommended deployment method is on Kubernetes using Helm charts. This makes installing and managing CogStack easy and consistent. For a detailed walkthrough, see [Helm](./helm/_index) .

You can run Kubernetes anywhere — on your own hardware or through cloud providers like AWS (EKS) or Azure (AKS). To help with this, we provide basic examples that deploy infrastructure, CogStack, and tests using Terraform. These are available in the [Examples](./examples/_index) folder.

Along with kubernetes, it is also possible to run CogStack through docker compose. See the [Reference](./reference/_index) folder for this. 


## Recommendations

- Deploy CogStack on Kubernetes for best scalability and reliability.
- Use Helm to install and manage your CogStack instances.
- Manage your infrastructure declaratively with Terraform.
- Keep your Terraform code in a Git repository and adopt GitOps workflows so all infrastructure changes go through version control


```{toctree}
:maxdepth: 2

get-started/_index

helm/_index

examples/_index

reference/_index
```
